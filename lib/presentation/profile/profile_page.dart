import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:weeksalive/core/l10n/time_utils.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_page.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/profile/pages/edit_profile/edit_profile_form.dart';
import 'package:weeksalive/presentation/profile/pages/notifications_settings/notifications_settings_page.dart';
import 'package:weeksalive/presentation/profile/profile_page_view_model.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
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
    return StoreConnector<AppState, ProfilePageViewModel>(
      converter: (store) => ProfilePageViewModel.create(store, DateTime.now()),
      builder: (context, viewModel) {
        return Scaffold(
          backgroundColor: AppColors.bg(context),
          appBar: PrimaryAppBar(title: Strings.profilePageTitle),
          body: SingleChildScrollView(
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
                ],
              ),
            ),
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
                          value: viewModel.age.toString(),
                        ),
                      ),
                      Container(
                        color: AppColors.strokeColor(context),
                        width: Dimens.strokeWidthS,
                      ),
                      Expanded(
                        child: _VerticalCardSection(
                          title: Strings.profilePageYearsAhead,
                          value: viewModel.yearsAhead.toString(),
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
                  value: TimeUtils.formatDate(context, viewModel.dateOfBirth),
                ),
                const SizedBox(height: Margins.spacingBase),
                const SmallDivider(width: double.infinity),
                const SizedBox(height: Margins.spacingBase),
                _HorizontalCardSection(
                  title: Strings.profilePageLifespan,
                  value: Strings.profilePageLifespanValue(viewModel.lifespan),
                ),
                const SizedBox(height: Margins.spacingBase),
                const SmallDivider(width: double.infinity),
                const SizedBox(height: Margins.spacingBase),
                _HorizontalCardSection(
                  title: Strings.profilePageGender,
                  value: viewModel.gender.titleCase,
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
      color: AppColors.bgSoft(context),
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
            title: Strings.profilePageNotifications,
            value: viewModel.notificationsEnabled
                ? Strings.profilePageNotificationsEnabled
                : Strings.profilePageNotificationsDisabled,
            onTap: () => Navigator.push(context, NotificationsSettingsPage.route()),
            icon: MingCuteIcons.mgc_right_line,
          ),
          const SmallDivider(width: double.infinity),
          _PreferencesButton(
            title: Strings.profilePageWeeklyIntentions,
            value: "EXPLORE, CONNECT", // TODO:
            onTap: () {
              // TODO: Push to weekly intentions page
            },
            icon: MingCuteIcons.mgc_right_line,
          ),
          const SmallDivider(width: double.infinity),
          _PreferencesButton(
            title: Strings.profilePageWeekBegin,
            value: "MONDAY", // TODO:
            onTap: () {
              // TODO: Push to week begin page
            },
            icon: MingCuteIcons.mgc_right_line,
          ),
          const SmallDivider(width: double.infinity),
          _PreferencesButton(
            title: "Replay onboarding",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const OnboardingPage())),
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
                child: Texts.primaryBold(title),
              ),
              if (value != null)
                Texts.primaryXsMedium(
                  value!,
                  color: AppColors.contentSoft(context),
                ),
              const SizedBox(width: Margins.spacingS),
              if (icon != null) Icon(icon),
            ],
          ),
        ),
      ),
    );
  }
}
