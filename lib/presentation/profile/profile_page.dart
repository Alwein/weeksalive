import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/texts/app_links.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/core/utils/mail_handler.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_page.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/profile/pages/edit_profile/edit_profile_form.dart';
import 'package:weeksalive/presentation/profile/pages/notifications_settings/notifications_settings_page.dart';
import 'package:weeksalive/presentation/profile/pages/theme_picker/theme_picker_page.dart';
import 'package:weeksalive/presentation/profile/pages/week_begin/week_begin_page.dart';
import 'package:weeksalive/presentation/profile/profile_page_view_model.dart';
import 'package:weeksalive/presentation/wallpaper/wallpaper_editor_page.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/weekly_intent/widgets/edit_weekly_intent_bottom_sheet.dart';
import 'package:weeksalive/presentation/widgets/primary_appbar.dart';
import 'package:weeksalive/presentation/widgets/secondary_button.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (context) => const ProfilePage());
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    return StoreConnector<AppState, ProfilePageViewModel>(
      converter: (store) => ProfilePageViewModel.create(store, DateTime.now(), locale: locale),
      builder: (context, viewModel) {
        return Scaffold(
          backgroundColor: AppColors.bg(context),
          appBar: PrimaryAppBar(title: Strings.profilePageTitle),
          body: FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, data) {
              final version = data.data?.version ?? 'x.x.x';
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsetsGeometry.symmetric(horizontal: Margins.spacingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: Margins.spacingBase),
                      _ProfileCard(viewModel: viewModel),
                      const SizedBox(height: Margins.spacingM),
                      Texts.primaryRegularMedium(Strings.profilePagePreferences, color: AppColors.contentSoft(context)),
                      const SizedBox(height: Margins.spacingBase),
                      _PreferencesCard(viewModel: viewModel),
                      const SizedBox(height: Margins.spacingM),
                      Texts.primaryRegularMedium(Strings.profilePageGetInTouch, color: AppColors.contentSoft(context)),
                      const SizedBox(height: Margins.spacingBase),
                      _GetInTouchCard(viewModel: viewModel, version: version),
                      const SizedBox(height: Margins.spacingM),
                      Texts.primaryRegularMedium(Strings.profilePageApplication, color: AppColors.contentSoft(context)),
                      const SizedBox(height: Margins.spacingBase),
                      _ApplicationCard(viewModel: viewModel),
                      const SizedBox(height: Margins.spacingL),
                      _VersionNumber(version: version),
                      const SizedBox(height: Margins.spacingL),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.viewModel});
  final ProfilePageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return _ProfileCardContainer(
      child: Column(
        children: [
          _ProfileCardHeader(userName: viewModel.userName),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Margins.spacingBase),
            child: Column(
              children: [
                const SizedBox(height: Margins.spacingBase),
                IntrinsicHeight(
                  child: Row(
                    spacing: Margins.spacingBase,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: _VerticalCardSection(
                          title: Strings.profilePageAge,
                          value: viewModel.age,
                        ),
                      ),
                      Container(
                        color: AppColors.strokeColor(context),
                        width: Dimens.strokeWidthS,
                      ),
                      Expanded(
                        child: _VerticalCardSection(
                          title: Strings.profilePageYearsAhead,
                          value: viewModel.yearsAhead,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Margins.spacingBase),
                const SmallDivider(width: double.infinity),
                const SizedBox(height: Margins.spacingBase),
                _HorizontalCardSection(
                  title: Strings.profilePageBorn,
                  value: viewModel.dateOfBirth,
                ),
                const SizedBox(height: Margins.spacingBase),
                const SmallDivider(width: double.infinity),
                const SizedBox(height: Margins.spacingBase),
                _HorizontalCardSection(
                  title: Strings.profilePageLifespan,
                  value: viewModel.lifespan,
                ),
                const SizedBox(height: Margins.spacingBase),
                const SmallDivider(width: double.infinity),
                const SizedBox(height: Margins.spacingBase),
                _HorizontalCardSection(
                  title: Strings.profilePageGender,
                  value: viewModel.gender,
                ),
                const SizedBox(height: Margins.spacingBase),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HorizontalCardSection extends StatelessWidget {
  const _HorizontalCardSection({required this.title, required this.value});
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Texts.primaryRegularMedium(
            title,
            color: AppColors.contentSoft(context),
          ),
        ),
        Text(
          value,
          style: TextStyles.primaryRegularBold.copyWith(color: AppColors.content(context)),
        ),
      ],
    );
  }
}

class _VerticalCardSection extends StatelessWidget {
  const _VerticalCardSection({required this.title, required this.value});
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Texts.primaryRegularMedium(
          title,
          color: AppColors.contentSoft(context),
        ),
        const SizedBox(height: Margins.spacingS),
        Text(
          value,
          style: TextStyles.primaryXlBold.copyWith(color: AppColors.content(context)),
        ),
      ],
    );
  }
}

class _ProfileCardHeader extends StatelessWidget {
  const _ProfileCardHeader({required this.userName});
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingBase, vertical: Margins.spacingS),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(Dimens.radiusL - Dimens.strokeWidthS),
          topRight: Radius.circular(Dimens.radiusL - Dimens.strokeWidthS),
        ),
        color: AppColors.bgSoft(context),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Texts.primaryLargeBold(userName),
          ),
          const SizedBox(width: Margins.spacingBase),
          SecondaryButton(
            backgroundColor: AppColors.bg(context),
            text: Strings.edit,
            icon: MingCuteIcons.mgc_pencil_line,
            onPressed: () => Navigator.push(context, EditProfilePage.route()),
          ),
        ],
      ),
    );
  }
}

class _ProfileCardContainer extends StatelessWidget {
  const _ProfileCardContainer({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimens.radiusL),
        border: Border.all(color: AppColors.strokeColor(context), width: Dimens.strokeWidthS),
      ),
      clipBehavior: Clip.hardEdge,
      child: child,
    );
  }
}

class _PreferencesCard extends StatelessWidget {
  const _PreferencesCard({required this.viewModel});
  final ProfilePageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return _ProfileCardContainer(
      child: Column(
        children: [
          _PreferencesButton(
            title: Strings.profilePageWeekBegin,
            value: viewModel.weekStartDay,
            onTap: () => Navigator.push(context, WeekBeginPage.route()),
            icon: MingCuteIcons.mgc_right_line,
          ),
          const SmallDivider(width: double.infinity),
          _PreferencesButton(
            title: Strings.profilePageWeeklyIntentions,
            value: viewModel.weeklyIntents,
            onTap: () => EditWeeklyIntentBottomSheet.show(context),
            icon: MingCuteIcons.mgc_right_line,
          ),
          const SmallDivider(width: double.infinity),
          _PreferencesButton(
            title: Strings.profilePageNotifications,
            value: viewModel.notificationsEnabled,
            onTap: () => Navigator.push(context, NotificationsSettingsPage.route()),
            icon: MingCuteIcons.mgc_right_line,
          ),
          const SmallDivider(width: double.infinity),
          _PreferencesButton(
            title: Strings.profilePageTheme,
            value: viewModel.theme,
            onTap: () => ThemePickerPage.show(context),
            icon: MingCuteIcons.mgc_right_line,
          ),
          const SmallDivider(width: double.infinity),
          _PreferencesButton(
            title: Strings.profilePageWallpaper,
            value: viewModel.wallpaperStatus,
            onTap: () => WallpaperEditorPage.show(context),
            icon: MingCuteIcons.mgc_right_line,
          ),
        ],
      ),
    );
  }
}

class _PreferencesButton extends StatelessWidget {
  const _PreferencesButton({required this.title, this.value, required this.onTap, this.icon});
  final String title;
  final String? value;
  final VoidCallback? onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(Dimens.radiusL),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(Margins.spacingBase),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Texts.primaryBold(title),
              ),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (value != null)
                      Flexible(
                        child: Texts.primaryXsMedium(
                          value!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          color: AppColors.contentSoft(context),
                        ),
                      ),
                    const SizedBox(width: Margins.spacingS),
                    if (icon != null) Icon(icon, color: AppColors.content(context), size: Dimens.iconSizeS),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GetInTouchCard extends StatelessWidget {
  const _GetInTouchCard({required this.viewModel, required this.version});
  final ProfilePageViewModel viewModel;
  final String version;

  @override
  Widget build(BuildContext context) {
    return _ProfileCardContainer(
      child: Column(
        children: [
          _PreferencesButton(
            title: Strings.profilePageRateTheApp,
            onTap: () {
              final url = switch (defaultTargetPlatform) {
                TargetPlatform.iOS => AppLinks.iosAppStoreUrlReview,
                TargetPlatform.android => AppLinks.androidAppStoreUrlReview,
                _ => throw UnsupportedError('Unsupported platform'),
              };
              launchUrl(Uri.parse(url));
            },
            icon: MingCuteIcons.mgc_external_link_line,
          ),
          const SmallDivider(width: double.infinity),
          _PreferencesButton(
            title: Strings.profilePageSuggestAFeature,
            onTap: () => MailHandler.sendEmail(
              email: AppLinks.featureRequestEmail,
              subject: "${Strings.suggestAFeatureSubject} $version",
              body: Strings.suggestAFeatureBody,
            ),
            icon: MingCuteIcons.mgc_mail_line,
          ),
          const SmallDivider(width: double.infinity),
          _PreferencesButton(
            title: Strings.profilePageReportABug,
            onTap: () => MailHandler.sendEmail(
              email: AppLinks.supportEmail,
              subject: "${Strings.reportABugSubject} $version",
              body: Strings.reportABugBody,
            ),
            icon: MingCuteIcons.mgc_mail_line,
          ),
        ],
      ),
    );
  }
}

class _ApplicationCard extends StatelessWidget {
  const _ApplicationCard({required this.viewModel});
  final ProfilePageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return _ProfileCardContainer(
      child: Column(
        children: [
          _PreferencesButton(
            title: Strings.profilePageTermsOfService,
            onTap: () => launchUrl(Uri.parse(AppLinks.terms)),
            icon: MingCuteIcons.mgc_external_link_line,
          ),
          const SmallDivider(width: double.infinity),
          _PreferencesButton(
            title: Strings.profilePagePrivacyPolicy,
            onTap: () => launchUrl(Uri.parse(AppLinks.privacy)),
            icon: MingCuteIcons.mgc_external_link_line,
          ),
          if (kDebugMode || 1 == 1) ...[
            const SmallDivider(width: double.infinity),
            _PreferencesButton(
              title: "Show onboarding",
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const OnboardingPage())),
              icon: MingCuteIcons.mgc_right_line,
            ),
          ],
        ],
      ),
    );
  }
}

class _VersionNumber extends StatelessWidget {
  const _VersionNumber({required this.version});
  final String version;

  @override
  Widget build(BuildContext context) {
    return Texts.primaryRegularMedium(
      version,
      color: AppColors.contentSoft(context),
      textAlign: TextAlign.center,
    );
  }
}
