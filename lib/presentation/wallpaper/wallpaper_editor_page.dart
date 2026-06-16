import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:weeksalive/core/styles/app_color_tokens.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/app_theme_id.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/core/utils/sensorial_feedback.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_background_mode.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_config.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_grid_data.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_grid_tokens.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_grid_type.dart';
import 'package:weeksalive/presentation/onboarding/widgets/custom_tab_bar.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/user/user_state.dart';
import 'package:weeksalive/presentation/redux/wallpaper/wallpaper_actions.dart';
import 'package:weeksalive/presentation/wallpaper/wallpaper_setup_page.dart';
import 'package:weeksalive/presentation/wallpaper/widgets/wallpaper_ios_help_sheet.dart';
import 'package:weeksalive/presentation/wallpaper/widgets/wallpaper_preview.dart';
import 'package:weeksalive/presentation/wallpaper/widgets/wallpaper_theme_picker.dart';
import 'package:weeksalive/presentation/widgets/primary_appbar.dart';
import 'package:weeksalive/presentation/widgets/primary_button.dart';
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

class _WallpaperEditorPageState extends State<WallpaperEditorPage> with TickerProviderStateMixin {
  static const double _tabHeight = 48.0;

  final _picker = ImagePicker();
  late WallpaperConfig _config;
  late TabController _gridTabController;
  bool _pendingIosHelpSheet = false;

  @override
  void initState() {
    super.initState();
    _config = StoreProvider.of<AppState>(context, listen: false).state.wallpaperState.config;
    _gridTabController = CustomTabController(
      length: 2,
      vsync: this,
      initialIndex: _config.gridType == WallpaperGridType.life ? 0 : 1,
    );
  }

  @override
  void dispose() {
    _gridTabController.dispose();
    super.dispose();
  }

  AppThemeId _effectiveGridThemeId() => resolveWallpaperThemeId(_config);

  void _syncTabControllers() {
    final gridIndex = _config.gridType == WallpaperGridType.life ? 0 : 1;
    if (_gridTabController.index != gridIndex) _gridTabController.index = gridIndex;
  }

  void _update(WallpaperConfig next, {bool persist = true, bool reRender = false}) {
    setState(() {
      _config = next;
      _syncTabControllers();
    });
    if (persist) {
      StoreProvider.of<AppState>(context, listen: false).dispatch(
        SaveWallpaperConfigAction(next, reRender: reRender),
      );
    }
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    final dir = await getApplicationDocumentsDirectory();
    final dest = p.join(
      dir.path,
      'wallpaper_bg_${DateTime.now().millisecondsSinceEpoch}${p.extension(picked.path)}',
    );
    await File(picked.path).copy(dest);
    _update(
      _config.copyWith(
        backgroundMode: WallpaperBackgroundMode.image,
        backgroundImagePath: () => dest,
      ),
      reRender: _config.enabled,
    );
  }

  void _install() {
    if (Platform.isIOS) _pendingIosHelpSheet = true;
    StoreProvider.of<AppState>(context, listen: false).dispatch(const InstallWallpaperAction());
  }

  void _onInstallStateChanged(_InstallViewModel? previous, _InstallViewModel current) {
    if (!_pendingIosHelpSheet || previous == null) return;
    if (previous.installing && !current.installing && current.installSucceeded == true) {
      _pendingIosHelpSheet = false;
      WallpaperIosHelpSheet.show(context);
    } else if (!current.installing && current.installSucceeded != null) {
      _pendingIosHelpSheet = false;
    }
  }

  void _onGridTabTapped(int index) {
    SensorialFeedback.navigationChanged();
    _update(
      _config.copyWith(
        gridType: index == 0 ? WallpaperGridType.life : WallpaperGridType.year,
      ),
      reRender: _config.enabled,
    );
  }

  void _removeImage() {
    _update(
      _config.copyWith(
        backgroundMode: WallpaperBackgroundMode.solid,
        backgroundImagePath: () => null,
      ),
      reRender: _config.enabled,
    );
  }

  void _onGridThemeSelected(AppThemeId themeId) {
    _update(
      _config.copyWith(
        gridThemeId: () => themeId,
        gridColorArgb: () => null,
        dark: switch (themeId) {
          AppThemeId.dark => true,
          AppThemeId.light => false,
          _ => _config.dark,
        },
      ),
      reRender: _config.enabled,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _InstallViewModel>(
      converter: (store) => _InstallViewModel(
        installing: store.state.wallpaperState.installing,
        installSucceeded: store.state.wallpaperState.installSucceeded,
      ),
      onWillChange: (previous, current) => previous != current,
      onDidChange: _onInstallStateChanged,
      builder: (context, vm) {
        final installing = vm.installing;
        final store = StoreProvider.of<AppState>(context, listen: false);
        final wallpaperTokens = resolveWallpaperGridTokens(_config);
        final data = WallpaperGridData.build(
          gridType: _config.gridType,
          user: store.state.userState.userOrNull,
          entries: store.state.dayState.entries.values,
          at: DateTime.now(),
        );

        return Scaffold(
          backgroundColor: AppColors.bg(context),
          appBar: PrimaryAppBar(
            title: Strings.wallpaperPageTitle,
            actions: [
              _WallpaperAppBarAction(
                onPressed: installing ? null : _install,
                isLoading: installing,
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _PinnedPreviewPanel(
                config: _config,
                data: data,
                tokens: wallpaperTokens,
                gridTokens: wallpaperTokens,
              ),
              Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: Margins.spacingM),
                      _WallpaperSection(
                        title: Strings.wallpaperGridSectionTitle,
                        child: CustomTabBar(
                          controller: _gridTabController,
                          onTap: _onGridTabTapped,
                          tabHeight: _tabHeight,
                          tabs: [
                            Tab(child: Text(Strings.wallpaperGridLife, style: TextStyles.primaryRegularBold)),
                            Tab(child: Text(Strings.wallpaperGridYear, style: TextStyles.primaryRegularBold)),
                          ],
                        ),
                      ),
                      const _SectionDivider(),
                      _WallpaperSection(
                        title: Strings.wallpaperThemeSectionTitle,
                        child: WallpaperThemePicker(
                          selectedThemeId: _effectiveGridThemeId(),
                          onSelected: _onGridThemeSelected,
                        ),
                      ),
                      const _SectionDivider(),
                      _WallpaperSection(
                        title: Strings.wallpaperBackgroundImageSectionTitle,
                        child: _BackgroundImageSection(
                          config: _config,
                          onPickImage: _pickImage,
                          onRemoveImage: _removeImage,
                          onOpacitySelected: (v) => _update(
                            _config.copyWith(backgroundImageOpacity: v),
                            reRender: _config.enabled,
                          ),
                          onBlurSelected: (v) => _update(
                            _config.copyWith(backgroundBlur: v),
                            reRender: _config.enabled,
                          ),
                        ),
                      ),
                      if (Platform.isIOS) ...[
                        const _SectionDivider(),
                        PrimaryButton(
                          text: Strings.wallpaperViewSetupGuide,
                          onPressed: () => WallpaperSetupPage.show(context),
                          backgroundColor: AppColors.bgSoft(context),
                          textColor: AppColors.content(context),
                        ),
                      ],
                      SizedBox(height: Margins.spacingM + MediaQuery.paddingOf(context).bottom),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BackgroundImageSection extends StatelessWidget {
  const _BackgroundImageSection({
    required this.config,
    required this.onPickImage,
    required this.onRemoveImage,
    required this.onOpacitySelected,
    required this.onBlurSelected,
  });

  final WallpaperConfig config;
  final VoidCallback onPickImage;
  final VoidCallback onRemoveImage;
  final ValueChanged<double> onOpacitySelected;
  final ValueChanged<double> onBlurSelected;

  static const _previewSize = 88.0;
  static const _opacityValues = [1.0, 0.75, 0.5];
  static const _opacityLabels = ['100%', '75%', '50%'];
  static const _blurValues = [0.0, 10.0, 20.0];
  static const _blurLabels = ['0', '10', '20'];

  bool get _hasImage {
    final path = config.backgroundImagePath;
    return path != null && File(path).existsSync();
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
                imagePath: config.backgroundImagePath!,
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
              Texts.primaryMedium(Strings.wallpaperImageOpacity),
              const SizedBox(height: Margins.spacingBase),
              SegmentedChipPicker(
                labels: _opacityLabels,
                selectedIndex: _nearestIndex(_opacityValues, config.backgroundImageOpacity),
                onSelected: (index) => onOpacitySelected(_opacityValues[index]),
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
                selectedIndex: _nearestIndex(_blurValues, config.backgroundBlur),
                onSelected: (index) => onBlurSelected(_blurValues[index]),
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

  static int _nearestIndex(List<double> values, double current) {
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
}

class _EmptyImagePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: _BackgroundImageSection._previewSize,
      decoration: BoxDecoration(
        color: AppColors.bgSoft(context),
        borderRadius: BorderRadius.circular(Dimens.radiusBase),
        border: Border.all(color: AppColors.strokeColor(context), width: Dimens.strokeWidthS),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_photo_alternate_outlined, size: Dimens.iconSizeM, color: AppColors.contentSoft(context)),
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
              top: -6,
              right: -6,
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
                    padding: const EdgeInsets.all(4),
                    child: Icon(Icons.close, size: Dimens.iconSizeXs, color: AppColors.bg(context)),
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

class _InstallViewModel {
  const _InstallViewModel({required this.installing, required this.installSucceeded});

  final bool installing;
  final bool? installSucceeded;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _InstallViewModel && installing == other.installing && installSucceeded == other.installSucceeded;

  @override
  int get hashCode => Object.hash(installing, installSucceeded);
}

class _PinnedPreviewPanel extends StatelessWidget {
  const _PinnedPreviewPanel({
    required this.config,
    required this.data,
    required this.tokens,
    required this.gridTokens,
  });

  final WallpaperConfig config;
  final WallpaperGridData data;
  final AppColorTokens tokens;
  final AppColorTokens gridTokens;

  static double _previewHeight(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    return (screenHeight * 0.30);
  }

  @override
  Widget build(BuildContext context) {
    final previewHeight = _previewHeight(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.bg(context),
        border: Border(
          bottom: BorderSide(color: AppColors.strokeColor(context)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Margins.spacingM,
          vertical: Margins.spacingBase,
        ),
        child: Center(
          child: WallpaperPreview(
            config: config,
            data: data,
            tokens: tokens,
            gridTokens: gridTokens,
            maxHeight: previewHeight,
          ),
        ),
      ),
    );
  }
}

class _WallpaperAppBarAction extends StatelessWidget {
  const _WallpaperAppBarAction({
    required this.onPressed,
    required this.isLoading,
  });

  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: Margins.spacingS),
      child: PrimaryButton(
        onPressed: isLoading ? null : onPressed,
        text: Strings.save,
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
