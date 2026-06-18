import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weeksalive/core/styles/app_color_tokens.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/core/utils/sensorial_feedback.dart';
import 'package:weeksalive/data/wallpaper/wallpaper_background_image_storage.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_config.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_grid_data.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_grid_tokens.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_grid_type.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/user/user_state.dart';
import 'package:weeksalive/presentation/redux/wallpaper/wallpaper_actions.dart';
import 'package:weeksalive/presentation/wallpaper/wallpaper_editor_controller.dart';
import 'package:weeksalive/presentation/wallpaper/wallpaper_setup_page.dart';
import 'package:weeksalive/presentation/wallpaper/widgets/wallpaper_preview.dart';
import 'package:weeksalive/presentation/wallpaper/widgets/wallpaper_theme_picker.dart';
import 'package:weeksalive/presentation/widgets/primary_appbar.dart';
import 'package:weeksalive/presentation/widgets/primary_button.dart';
import 'package:weeksalive/presentation/widgets/secondary_button.dart';
import 'package:weeksalive/presentation/widgets/segmented_chip_picker.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class WallpaperEditorPage extends StatefulWidget {
  const WallpaperEditorPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (context) => const WallpaperEditorPage());
  }

  static Future<void> show(BuildContext context) {
    return Navigator.of(context).push(route());
  }

  @override
  State<WallpaperEditorPage> createState() => _WallpaperEditorPageState();
}

class _WallpaperEditorPageState extends State<WallpaperEditorPage> {
  final _picker = ImagePicker();
  late final WallpaperEditorController _controller;
  String? _documentsDirectoryPath;
  bool _pendingIosSetupPage = false;

  @override
  void initState() {
    super.initState();
    final store = StoreProvider.of<AppState>(context, listen: false);
    _controller = WallpaperEditorController(
      initialConfig: store.state.wallpaperState.config,
      onPersist: (config, {reRender = false}) {
        store.dispatch(SaveWallpaperConfigAction(config, reRender: reRender));
      },
    )..addListener(_onControllerChanged);
    _loadDocumentsDirectory();
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onControllerChanged)
      ..dispose();
    super.dispose();
  }

  void _onControllerChanged() => setState(() {});

  Future<void> _loadDocumentsDirectory() async {
    final dir = await getApplicationDocumentsDirectory();
    if (!mounted) return;
    setState(() => _documentsDirectoryPath = dir.path);
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    final fileName = await WallpaperBackgroundImageStorage.saveFromPicker(picked.path);
    _controller.setBackgroundImage(fileName);
  }

  void _install() {
    final store = StoreProvider.of<AppState>(context, listen: false);
    store.dispatch(SaveWallpaperConfigAction(_controller.config));
    if (Platform.isIOS) _pendingIosSetupPage = true;
    store.dispatch(const InstallWallpaperAction());
  }

  Future<void> _onAutomaticToggle(bool enabled) async {
    if (enabled) {
      _install();
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => _DisableConfirmationDialog(dialogContext: dialogContext),
    );
    if (!mounted || confirmed != true) return;

    StoreProvider.of<AppState>(context, listen: false).dispatch(const DisableWallpaperAction());
  }

  void _onEditorStateChanged(_EditorViewModel? previous, _EditorViewModel current) {
    if (previous?.enabled != current.enabled) {
      final store = StoreProvider.of<AppState>(context, listen: false);
      _controller.syncFromStore(store.state.wallpaperState.config);
    }

    if (previous?.installing == true && !current.installing && current.installSucceeded == true) {
      _controller.markSaved();
    }

    _onInstallStateChanged(previous, current);
  }

  void _onInstallStateChanged(_EditorViewModel? previous, _EditorViewModel current) {
    if (!_pendingIosSetupPage || previous == null) return;
    if (previous.installing && !current.installing && current.installSucceeded == true) {
      _pendingIosSetupPage = false;
      _controller.markSaved();
      Navigator.of(context).pop();
      if (Platform.isIOS) WallpaperSetupPage.show(context);
    } else if (!current.installing && current.installSucceeded != null) {
      _pendingIosSetupPage = false;
    }
  }

  Future<void> _onAttemptDismiss() async {
    if (!_controller.hasUnsavedChanges) {
      Navigator.of(context).pop();
      return;
    }

    final discard = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => _CloseConfirmationDialog(dialogContext: dialogContext),
    );

    if (!mounted || discard != true) return;

    _controller.discardChanges();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final config = _controller.config;

    return StoreConnector<AppState, _EditorViewModel>(
      converter: (store) => _EditorViewModel(
        installing: store.state.wallpaperState.installing,
        installSucceeded: store.state.wallpaperState.installSucceeded,
        enabled: store.state.wallpaperState.config.enabled,
      ),
      onWillChange: (previous, current) => previous != current,
      onDidChange: _onEditorStateChanged,
      builder: (context, vm) {
        final installing = vm.installing;
        final enabled = vm.enabled;
        final canSave = !installing && (!enabled || _controller.hasUnsavedChanges);
        final store = StoreProvider.of<AppState>(context, listen: false);
        final wallpaperTokens = resolveWallpaperGridTokens(config);
        final data = WallpaperGridData.build(
          gridType: config.gridType,
          user: store.state.userState.userOrNull,
          entries: store.state.dayState.entries.values,
          at: DateTime.now(),
        );

        return PopScope(
          canPop: !_controller.hasUnsavedChanges,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _onAttemptDismiss();
          },
          child: Scaffold(
            backgroundColor: AppColors.bg(context),
            appBar: PrimaryAppBar(
              title: Strings.wallpaperPageTitle,
              onLeadingPressed: _onAttemptDismiss,
              actions: [
                if (canSave)
                  _WallpaperAppBarAction(
                    onPressed: _install,
                    isLoading: installing,
                    label: enabled ? Strings.save : Strings.wallpaperInstallAction,
                  ),
              ],
            ),
            body: CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _PreviewSliverHeaderDelegate(
                    maxPreviewHeight: MediaQuery.sizeOf(context).height * 0.50,
                    minPreviewHeight: MediaQuery.sizeOf(context).height * 0.20,
                    config: config,
                    data: data,
                    tokens: wallpaperTokens,
                    gridTokens: wallpaperTokens,
                    documentsDirectoryPath: _documentsDirectoryPath,
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: Margins.spacingM),
                      if (!Platform.isIOS) ...[
                        _WallpaperAutomaticToggle(
                          enabled: enabled,
                          gridType: config.gridType,
                          installing: installing,
                          onChanged: _onAutomaticToggle,
                        ),
                        const _SectionDivider(),
                      ],
                      _WallpaperSection(
                        title: Strings.wallpaperGridSectionTitle,
                        child: SegmentedChipPicker(
                          labels: [Strings.wallpaperGridLife, Strings.wallpaperGridYear],
                          selectedIndex: config.gridType == WallpaperGridType.life ? 0 : 1,
                          onSelected: (index) => _controller.setGridType(
                            index == 0 ? WallpaperGridType.life : WallpaperGridType.year,
                          ),
                        ),
                      ),
                      const _SectionDivider(),
                      _WallpaperSection(
                        title: Strings.wallpaperGridLayoutSectionTitle,
                        child: _GridLayoutSection(
                          config: config,
                          onScaleChanged: _controller.setGridScale,
                          onVerticalOffsetChanged: _controller.setGridVerticalOffset,
                        ),
                      ),
                      const _SectionDivider(),
                      _WallpaperSection(
                        title: Strings.wallpaperThemeSectionTitle,
                        child: WallpaperThemePicker(
                          selectedThemeId: _controller.effectiveGridThemeId,
                          onSelected: _controller.setGridTheme,
                        ),
                      ),
                      const _SectionDivider(),
                      _WallpaperSection(
                        title: Strings.wallpaperBackgroundImageSectionTitle,
                        child: _BackgroundImageSection(
                          config: config,
                          documentsDirectoryPath: _documentsDirectoryPath,
                          onPickImage: _pickImage,
                          onRemoveImage: _controller.removeBackgroundImage,
                          onOpacitySelected: _controller.setBackgroundImageOpacity,
                          onBlurSelected: _controller.setBackgroundBlur,
                          onGridOpacitySelected: _controller.setGridOpacity,
                        ),
                      ),
                      SizedBox(height: Margins.spacingM + MediaQuery.paddingOf(context).bottom),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DisableConfirmationDialog extends StatelessWidget {
  const _DisableConfirmationDialog({required this.dialogContext});

  final BuildContext dialogContext;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.radiusBase),
        side: BorderSide(color: AppColors.strokeColor(context)),
      ),
      backgroundColor: AppColors.bg(context),
      title: Texts.primaryMediumBold(Strings.wallpaperDisableTitle),
      content: Texts.primaryRegularMedium(
        Strings.wallpaperDisableMessage,
        color: AppColors.contentSoft(context),
      ),
      actions: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PrimaryButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              text: Strings.wallpaperDisableCancel,
            ),
            const SizedBox(height: Margins.spacingS),
            SecondaryButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              text: Strings.wallpaperDisableConfirm,
            ),
          ],
        ),
      ],
    );
  }
}

class _WallpaperAutomaticToggle extends StatelessWidget {
  const _WallpaperAutomaticToggle({
    required this.enabled,
    required this.gridType,
    required this.installing,
    required this.onChanged,
  });

  final bool enabled;
  final WallpaperGridType gridType;
  final bool installing;
  final ValueChanged<bool> onChanged;

  String _subtitle() {
    if (!enabled) return Strings.wallpaperAutomaticUpdatesOff;
    return gridType == WallpaperGridType.year
        ? Strings.wallpaperAutomaticUpdatesDaily
        : Strings.wallpaperAutomaticUpdatesWeekly;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Margins.spacingBase,
        vertical: Margins.spacingBase,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgSoft(context),
        borderRadius: BorderRadius.circular(Dimens.radiusBase),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Texts.primaryMediumBold(Strings.wallpaperAutomaticTitle),
                const SizedBox(height: Margins.spacingXs),
                Texts.primaryXsMedium(
                  _subtitle(),
                  color: AppColors.contentSoft(context),
                ),
              ],
            ),
          ),
          CupertinoSwitch(
            value: enabled,
            onChanged: installing ? null : onChanged,
            activeTrackColor: AppColors.greenSuccess(context),
          ),
        ],
      ),
    );
  }
}

class _CloseConfirmationDialog extends StatelessWidget {
  const _CloseConfirmationDialog({required this.dialogContext});

  final BuildContext dialogContext;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.radiusBase),
        side: BorderSide(color: AppColors.strokeColor(context)),
      ),
      backgroundColor: AppColors.bg(context),
      title: Texts.primaryMediumBold(Strings.dayFormDiscardTitle),
      actions: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PrimaryButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              text: Strings.dayFormDiscardCancel,
            ),
            const SizedBox(height: Margins.spacingS),
            SecondaryButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              text: Strings.dayFormDiscardConfirm,
            ),
          ],
        ),
      ],
    );
  }
}

int _nearestPresetIndex(List<double> values, double current) {
  var best = 0;
  var bestDelta = double.infinity;
  for (var i = 0; i < values.length; i++) {
    final delta = (values[i] - current).abs();
    if (delta < bestDelta) {
      bestDelta = delta;
      best = i;
    }
  }
  return best;
}

class _GridLayoutSection extends StatelessWidget {
  const _GridLayoutSection({
    required this.config,
    required this.onScaleChanged,
    required this.onVerticalOffsetChanged,
  });

  final WallpaperConfig config;
  final ValueChanged<double> onScaleChanged;
  final ValueChanged<double> onVerticalOffsetChanged;

  static const _scaleDivisions = 20;
  static const _offsetDivisions = 30;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _WallpaperSlider(
          label: Strings.wallpaperGridScale,
          valueLabel: Strings.wallpaperGridScaleValue(config.gridScale),
          value: config.gridScale,
          min: WallpaperConfig.gridScaleMin,
          max: WallpaperConfig.gridScaleMax,
          divisions: _scaleDivisions,
          onChanged: onScaleChanged,
        ),
        const SizedBox(height: Margins.spacingM),
        _WallpaperSlider(
          label: Strings.wallpaperGridVerticalOffset,
          valueLabel: Strings.wallpaperGridVerticalOffsetValue(config.gridVerticalOffset),
          value: config.gridVerticalOffset,
          min: WallpaperConfig.gridVerticalOffsetMin,
          max: WallpaperConfig.gridVerticalOffsetMax,
          divisions: _offsetDivisions,
          onChanged: onVerticalOffsetChanged,
        ),
      ],
    );
  }
}

class _WallpaperSlider extends StatefulWidget {
  const _WallpaperSlider({
    required this.label,
    required this.valueLabel,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  });

  final String label;
  final String valueLabel;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;

  @override
  State<_WallpaperSlider> createState() => _WallpaperSliderState();
}

class _WallpaperSliderState extends State<_WallpaperSlider> {
  double? _lastSoundValue;

  void _handleChanged(double value) {
    if (_lastSoundValue == null || (value - _lastSoundValue!).abs() >= 0.001) {
      _lastSoundValue = value;
      SensorialFeedback.sliderChanged();
    }
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Texts.primaryMedium(widget.label)),
            Texts.primaryMedium(widget.valueLabel),
          ],
        ),
        const SizedBox(height: Margins.spacingBase),
        Slider(
          padding: EdgeInsets.zero,
          min: widget.min,
          max: widget.max,
          divisions: widget.divisions,
          value: widget.value.clamp(widget.min, widget.max),
          onChanged: _handleChanged,
          thumbColor: AppColors.content(context),
          activeColor: AppColors.content(context),
          inactiveColor: AppColors.bgSoft(context),
        ),
      ],
    );
  }
}

class _BackgroundImageSection extends StatelessWidget {
  const _BackgroundImageSection({
    required this.config,
    required this.documentsDirectoryPath,
    required this.onPickImage,
    required this.onRemoveImage,
    required this.onOpacitySelected,
    required this.onBlurSelected,
    required this.onGridOpacitySelected,
  });

  final WallpaperConfig config;
  final String? documentsDirectoryPath;
  final VoidCallback onPickImage;
  final VoidCallback onRemoveImage;
  final ValueChanged<double> onOpacitySelected;
  final ValueChanged<double> onBlurSelected;
  final ValueChanged<double> onGridOpacitySelected;

  static const _dimValues = [1.0, 0.75, 0.5];
  static const _dimLabels = ['100%', '75%', '50%'];
  static const _gridOpacityValues = [1.0, 0.75, 0.5];
  static const _gridOpacityLabels = ['100%', '75%', '50%'];
  static const _blurValues = [0.0, 10.0, 20.0];
  static const _blurLabels = ['0', '10', '20'];

  bool get _hasImage {
    if (documentsDirectoryPath == null) return false;
    return WallpaperBackgroundImageStorage.resolveSync(
          config.backgroundImagePath,
          documentsDirectoryPath!,
        ) !=
        null;
  }

  String? get _resolvedImagePath {
    if (documentsDirectoryPath == null) return null;
    return WallpaperBackgroundImageStorage.resolveSync(
      config.backgroundImagePath,
      documentsDirectoryPath!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_hasImage) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BackgroundImagePreview(
                imagePath: _resolvedImagePath!,
                onRemove: onRemoveImage,
                onTap: onPickImage,
              ),
              const SizedBox(width: Margins.spacingM),
              Expanded(
                child: PrimaryButton(
                  text: Strings.wallpaperChangeImage,
                  onPressed: onPickImage,
                  backgroundColor: AppColors.bgSoft(context),
                  textColor: AppColors.content(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: Margins.spacingM),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Texts.primaryMedium(Strings.wallpaperImageDim),
              const SizedBox(height: Margins.spacingBase),
              SegmentedChipPicker(
                labels: _dimLabels,
                selectedIndex: _nearestPresetIndex(_dimValues, config.backgroundImageOpacity),
                onSelected: (index) => onOpacitySelected(_dimValues[index]),
              ),
            ],
          ),
          const SizedBox(height: Margins.spacingM),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Texts.primaryMedium(Strings.wallpaperImageBlur),
              const SizedBox(height: Margins.spacingBase),
              SegmentedChipPicker(
                labels: _blurLabels,
                selectedIndex: _nearestPresetIndex(_blurValues, config.backgroundBlur),
                onSelected: (index) => onBlurSelected(_blurValues[index]),
              ),
            ],
          ),
          const SizedBox(height: Margins.spacingM),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Texts.primaryMedium(Strings.wallpaperGridOpacity),
              const SizedBox(height: Margins.spacingBase),
              SegmentedChipPicker(
                labels: _gridOpacityLabels,
                selectedIndex: _nearestPresetIndex(_gridOpacityValues, config.gridOpacity),
                onSelected: (index) => onGridOpacitySelected(_gridOpacityValues[index]),
              ),
            ],
          ),
        ] else
          GestureDetector(
            onTap: onPickImage,
            child: _EmptyImagePlaceholder(),
          ),
      ],
    );
  }
}

class _EmptyImagePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Margins.spacingBase),
      decoration: BoxDecoration(
        color: AppColors.bgSoft(context),
        borderRadius: BorderRadius.circular(Dimens.radiusBase),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_photo_alternate_outlined,
            size: Dimens.iconSizeM,
            color: AppColors.contentSoft(context),
          ),
          const SizedBox(height: Margins.spacingS),
          Texts.primaryMedium(Strings.wallpaperAddImage, color: AppColors.contentSoft(context)),
        ],
      ),
    );
  }
}

class _BackgroundImagePreview extends StatelessWidget {
  const _BackgroundImagePreview({
    required this.imagePath,
    required this.onRemove,
    required this.onTap,
  });

  final String imagePath;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  static const _size = 88.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: _size,
        height: _size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(Dimens.radiusBase),
              child: Image.file(
                File(imagePath),
                width: _size,
                height: _size,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: -Margins.spacingS,
              right: -Margins.spacingS,
              child: GestureDetector(
                onTap: () {
                  SensorialFeedback.selectionChanged();
                  onRemove();
                },
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.content(context),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.bg(context), width: Dimens.strokeWidthBase),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(Margins.spacingXs),
                    child: Icon(Icons.close, size: Dimens.iconSizeS, color: AppColors.bg(context)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditorViewModel {
  const _EditorViewModel({
    required this.installing,
    required this.installSucceeded,
    required this.enabled,
  });

  final bool installing;
  final bool? installSucceeded;
  final bool enabled;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _EditorViewModel &&
          installing == other.installing &&
          installSucceeded == other.installSucceeded &&
          enabled == other.enabled;

  @override
  int get hashCode => Object.hash(installing, installSucceeded, enabled);
}

class _PreviewSliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  _PreviewSliverHeaderDelegate({
    required this.maxPreviewHeight,
    required this.minPreviewHeight,
    required this.config,
    required this.data,
    required this.tokens,
    required this.gridTokens,
    required this.documentsDirectoryPath,
  });

  final double maxPreviewHeight;
  final double minPreviewHeight;
  final WallpaperConfig config;
  final WallpaperGridData data;
  final AppColorTokens tokens;
  final AppColorTokens gridTokens;
  final String? documentsDirectoryPath;

  static const _horizontalPadding = Margins.spacingM;
  static const _verticalPadding = Margins.spacingBase;

  @override
  double get maxExtent => maxPreviewHeight + _verticalPadding * 2;

  @override
  double get minExtent => minPreviewHeight + _verticalPadding * 2;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final previewHeight = (maxPreviewHeight - shrinkOffset).clamp(minPreviewHeight, maxPreviewHeight);
    final headerHeight = previewHeight + _verticalPadding * 2;

    return SizedBox(
      height: headerHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.bg(context),
          border: Border(
            bottom: BorderSide(color: AppColors.strokeColor(context)),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: _horizontalPadding,
            vertical: _verticalPadding,
          ),
          child: Center(
            child: WallpaperPreview(
              config: config,
              data: data,
              tokens: tokens,
              gridTokens: gridTokens,
              maxHeight: previewHeight,
              documentsDirectoryPath: documentsDirectoryPath,
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _PreviewSliverHeaderDelegate oldDelegate) {
    return maxPreviewHeight != oldDelegate.maxPreviewHeight ||
        minPreviewHeight != oldDelegate.minPreviewHeight ||
        config != oldDelegate.config ||
        data != oldDelegate.data ||
        tokens != oldDelegate.tokens ||
        gridTokens != oldDelegate.gridTokens ||
        documentsDirectoryPath != oldDelegate.documentsDirectoryPath;
  }
}

class _WallpaperAppBarAction extends StatelessWidget {
  const _WallpaperAppBarAction({
    required this.onPressed,
    required this.isLoading,
    required this.label,
  });

  final VoidCallback? onPressed;
  final bool isLoading;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: Margins.spacingS),
      child: PrimaryButton(
        onPressed: isLoading ? null : onPressed,
        text: label,
      ),
    );
  }
}

class _WallpaperSection extends StatelessWidget {
  const _WallpaperSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Texts.primaryMediumBold(title),
        const SizedBox(height: Margins.spacingBase),
        child,
      ],
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: Margins.spacingM),
        SmallDivider(width: double.infinity),
        SizedBox(height: Margins.spacingM),
      ],
    );
  }
}
