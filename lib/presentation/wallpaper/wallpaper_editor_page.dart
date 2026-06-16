import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/styles/themes/app_theme.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_background_mode.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_config.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_grid_data.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_grid_type.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/user/user_state.dart';
import 'package:weeksalive/presentation/redux/wallpaper/wallpaper_actions.dart';
import 'package:weeksalive/presentation/wallpaper/wallpaper_setup_page.dart';
import 'package:weeksalive/presentation/wallpaper/widgets/wallpaper_ios_help_sheet.dart';
import 'package:weeksalive/presentation/wallpaper/widgets/wallpaper_preview.dart';
import 'package:weeksalive/presentation/widgets/primary_appbar.dart';
import 'package:weeksalive/presentation/widgets/primary_button.dart';
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
  late WallpaperConfig _config;
  bool _pendingIosHelpSheet = false;

  @override
  void initState() {
    super.initState();
    _config = StoreProvider.of<AppState>(context, listen: false).state.wallpaperState.config;
  }

  void _update(WallpaperConfig next, {bool persist = true, bool reRender = false}) {
    setState(() => _config = next);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg(context),
      appBar: PrimaryAppBar(title: Strings.wallpaperPageTitle),
      body: StoreConnector<AppState, _InstallViewModel>(
        converter: (store) => _InstallViewModel(
          installing: store.state.wallpaperState.installing,
          installSucceeded: store.state.wallpaperState.installSucceeded,
        ),
        onWillChange: (previous, current) => previous != current,
        onDidChange: _onInstallStateChanged,
        builder: (context, vm) {
          final installing = vm.installing;
          final store = StoreProvider.of<AppState>(context, listen: false);
          final tokens = AppThemes.resolveTokens(
            store.state.themeState.selectedTheme,
            _config.dark ? Brightness.dark : Brightness.light,
          );
          final data = WallpaperGridData.build(
            gridType: _config.gridType,
            user: store.state.userState.userOrNull,
            entries: store.state.dayState.entries.values,
            at: DateTime.now(),
          );

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: Margins.spacingBase),
                      Center(child: WallpaperPreview(config: _config, data: data, tokens: tokens)),
                      const SizedBox(height: Margins.spacingM),
                      _SectionTitle(Strings.wallpaperGridSectionTitle),
                      const SizedBox(height: Margins.spacingBase),
                      _SegmentedRow(
                        options: [
                          (Strings.wallpaperGridLife, _config.gridType == WallpaperGridType.life),
                          (Strings.wallpaperGridYear, _config.gridType == WallpaperGridType.year),
                        ],
                        onSelected: (index) => _update(
                          _config.copyWith(
                            gridType: index == 0 ? WallpaperGridType.life : WallpaperGridType.year,
                          ),
                          reRender: _config.enabled,
                        ),
                      ),
                      const SizedBox(height: Margins.spacingM),
                      _SectionTitle(Strings.wallpaperAppearanceSectionTitle),
                      const SizedBox(height: Margins.spacingBase),
                      _LabeledRow(
                        label: Strings.wallpaperBrightness,
                        child: _SegmentedRow(
                          compact: true,
                          options: [
                            (Strings.wallpaperBrightnessLight, !_config.dark),
                            (Strings.wallpaperBrightnessDark, _config.dark),
                          ],
                          onSelected: (index) => _update(
                            _config.copyWith(dark: index == 1),
                            reRender: _config.enabled,
                          ),
                        ),
                      ),
                      const SizedBox(height: Margins.spacingM),
                      _SectionTitle(Strings.wallpaperBackgroundSectionTitle),
                      const SizedBox(height: Margins.spacingBase),
                      _SegmentedRow(
                        options: [
                          (Strings.wallpaperBackgroundSolid, _config.backgroundMode == WallpaperBackgroundMode.solid),
                          (
                            Strings.wallpaperBackgroundGradient,
                            _config.backgroundMode == WallpaperBackgroundMode.gradient,
                          ),
                          (Strings.wallpaperBackgroundImage, _config.backgroundMode == WallpaperBackgroundMode.image),
                        ],
                        onSelected: (index) {
                          final mode = switch (index) {
                            0 => WallpaperBackgroundMode.solid,
                            1 => WallpaperBackgroundMode.gradient,
                            _ => WallpaperBackgroundMode.image,
                          };
                          if (mode == WallpaperBackgroundMode.image && _config.backgroundImagePath == null) {
                            _update(_config.copyWith(backgroundMode: mode), reRender: _config.enabled);
                            _pickImage();
                          } else {
                            _update(_config.copyWith(backgroundMode: mode), reRender: _config.enabled);
                          }
                        },
                      ),
                      if (_config.backgroundMode == WallpaperBackgroundMode.image) ...[
                        const SizedBox(height: Margins.spacingBase),
                        PrimaryButton(
                          text: _config.backgroundImagePath == null
                              ? Strings.wallpaperPickImage
                              : Strings.wallpaperChangeImage,
                          onPressed: _pickImage,
                          backgroundColor: AppColors.bgSoft(context),
                          textColor: AppColors.content(context),
                        ),
                        const SizedBox(height: Margins.spacingBase),
                        _SliderRow(
                          label: Strings.wallpaperImageOpacity,
                          value: _config.backgroundImageOpacity,
                          onChanged: (v) => _update(_config.copyWith(backgroundImageOpacity: v), persist: false),
                          onChangeEnd: (v) => _update(
                            _config.copyWith(backgroundImageOpacity: v),
                            reRender: _config.enabled,
                          ),
                        ),
                        _SliderRow(
                          label: Strings.wallpaperImageBlur,
                          value: _config.backgroundBlur,
                          max: 20,
                          onChanged: (v) => _update(_config.copyWith(backgroundBlur: v), persist: false),
                          onChangeEnd: (v) => _update(
                            _config.copyWith(backgroundBlur: v),
                            reRender: _config.enabled,
                          ),
                        ),
                      ],
                      const SizedBox(height: Margins.spacingM),
                      _SectionTitle(Strings.wallpaperGridColor),
                      const SizedBox(height: Margins.spacingBase),
                      _ColorSwatchRow(
                        selectedArgb: _config.gridColorArgb,
                        onSelected: (argb) => _update(
                          _config.copyWith(gridColorArgb: () => argb),
                          reRender: _config.enabled,
                        ),
                      ),
                      const SizedBox(height: Margins.spacingL),
                      if (Platform.isIOS) ...[
                        PrimaryButton(
                          text: Strings.wallpaperViewSetupGuide,
                          onPressed: () => WallpaperSetupPage.show(context),
                          backgroundColor: AppColors.bgSoft(context),
                          textColor: AppColors.content(context),
                        ),
                        const SizedBox(height: Margins.spacingL),
                      ],
                    ],
                  ),
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Margins.spacingM,
                    Margins.spacingBase,
                    Margins.spacingM,
                    Margins.spacingBase,
                  ),
                  child: PrimaryButton(
                    text: _config.enabled ? Strings.wallpaperUpdate : Strings.wallpaperInstall,
                    onPressed: installing ? null : _install,
                  ),
                ),
              ),
            ],
          );
        },
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
      other is _InstallViewModel &&
          installing == other.installing &&
          installSucceeded == other.installSucceeded;

  @override
  int get hashCode => Object.hash(installing, installSucceeded);
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Texts.primaryRegularMedium(title, color: AppColors.contentSoft(context));
  }
}

class _LabeledRow extends StatelessWidget {
  const _LabeledRow({required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Texts.primaryBold(label)),
        child,
      ],
    );
  }
}

class _SegmentedRow extends StatelessWidget {
  const _SegmentedRow({required this.options, required this.onSelected, this.compact = false});

  final List<(String, bool)> options;
  final ValueChanged<int> onSelected;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < options.length; i++) {
      final (label, selected) = options[i];
      children.add(
        Expanded(
          child: GestureDetector(
            onTap: () => onSelected(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: Margins.spacingS),
              decoration: BoxDecoration(
                color: selected ? AppColors.content(context) : Colors.transparent,
                borderRadius: BorderRadius.circular(Dimens.radiusS),
              ),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyles.primaryRegularBold.copyWith(
                  color: selected ? AppColors.bg(context) : AppColors.contentSoft(context),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Container(
      width: compact ? 200 : double.infinity,
      padding: const EdgeInsets.all(Margins.spacingXs),
      decoration: BoxDecoration(
        color: AppColors.bgSoft(context),
        borderRadius: BorderRadius.circular(Dimens.radiusBase),
      ),
      child: Row(children: children),
    );
  }
}

class _SliderRow extends StatelessWidget {
  const _SliderRow({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.onChangeEnd,
    this.max = 1.0,
  });

  final String label;
  final double value;
  final double max;
  final ValueChanged<double> onChanged;
  final ValueChanged<double> onChangeEnd;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 110, child: Texts.primaryRegularMedium(label)),
        Expanded(
          child: Slider(
            value: value.clamp(0, max),
            max: max,
            activeColor: AppColors.content(context),
            inactiveColor: AppColors.bgSoft(context),
            onChanged: onChanged,
            onChangeEnd: onChangeEnd,
          ),
        ),
      ],
    );
  }
}

class _ColorSwatchRow extends StatelessWidget {
  const _ColorSwatchRow({required this.selectedArgb, required this.onSelected});

  final int? selectedArgb;
  final ValueChanged<int?> onSelected;

  static const _palette = <int?>[
    null,
    0xFFFFFFFF,
    0xFF000000,
    0xFFE8A0B0,
    0xFF5A8A68,
    0xFFA87ED4,
    0xFFC4614A,
    0xFF4A7090,
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: Margins.spacingBase,
      runSpacing: Margins.spacingBase,
      children: _palette.map((argb) {
        final selected = argb == selectedArgb;
        final isThemeDefault = argb == null;
        return GestureDetector(
          onTap: () => onSelected(argb),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isThemeDefault ? AppColors.content(context) : Color(argb),
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? AppColors.accentOrange(context) : AppColors.strokeColor(context),
                width: selected ? Dimens.strokeWidthBase : Dimens.strokeWidthS,
              ),
            ),
            child: isThemeDefault
                ? Icon(Icons.auto_awesome, size: Dimens.iconSizeXs, color: AppColors.bg(context))
                : null,
          ),
        );
      }).toList(),
    );
  }
}
