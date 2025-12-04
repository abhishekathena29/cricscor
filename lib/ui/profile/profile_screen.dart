import 'package:cricscor/ui/auth/login.dart';
import 'package:cricscor/ui/auth/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:style/animations/on_tap_scale.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';

import '../navigation.dart';
import '../sample_data.dart';
import '../widgets/section_header.dart';
import '../notifications/notifications_screen.dart';
import '../settings/settings_screen.dart';
import 'edit_profile_screen.dart';
import 'provider/profile_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = context.mediaQueryPadding;
    final colors = context.colorScheme;
    return ColoredBox(
      color: colors.surface,
      child: StreamBuilder<UserProfile?>(
        stream: context.read<ProfileProvider>().watchProfile(),
        builder: (context, snapshot) {
          final profile = snapshot.data;
          return ListView(
            padding: EdgeInsets.only(
              top: padding.top + 12,
              bottom: padding.bottom + 28,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Profile',
                  style: AppTextStyle.header3.copyWith(color: colors.textPrimary),
                ),
              ),
              const SizedBox(height: 12),
              _profileCard(context, profile),
              const SectionHeader(title: 'Quick actions'),
              _quickActions(context, profile),
              const SectionHeader(title: 'Settings'),
              ...profileActions.map((action) => _actionTile(context, action)),
              Consumer<AuthenProvider>(
                builder: (context, provider, _) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        side: BorderSide(color: colors.outline),
                        foregroundColor: colors.alert,
                      ),
                      onPressed: () async {
                        await provider.signOut();

                        if (context.mounted) {
                          pushAndRemoveuntilScreen(context, MinimalLoginPage());
                        }
                      },
                      icon: SvgPicture.asset(
                        'assets/images/ic_sign_out.svg',
                        width: 18,
                        height: 18,
                        colorFilter: ColorFilter.mode(
                          colors.alert,
                          BlendMode.srcIn,
                        ),
                      ),
                      label: const Text('Sign out'),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _profileCard(BuildContext context, UserProfile? profile) {
    final colors = context.colorScheme;
    final title = profile?.username ?? 'Loading user';
    final subtitle = profile == null
        ? 'Fetching profile...'
        : '${profile.userType.toUpperCase()} • ${profile.city ?? 'Unknown'}';
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.containerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outline),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: colors.primary.withOpacity(0.14),
                child: SvgPicture.asset(
                  'assets/images/ic_profile.svg',
                  width: 28,
                  height: 28,
                  colorFilter: ColorFilter.mode(
                    colors.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    Text(
                      title,
                      style: AppTextStyle.subtitle2.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: AppTextStyle.body2.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    Text(
                      profile?.email ?? '',
                      style: AppTextStyle.caption.copyWith(
                        color: colors.textDisabled,
                      ),
                    ),
                  ],
                ),
              ),
              if (profile != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: colors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    profile.userType.toUpperCase(),
                    style: AppTextStyle.caption.copyWith(
                      color: colors.primary,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _statChip(context, '164', 'Matches'),
              const SizedBox(width: 8),
              _statChip(context, '2.3K', 'Runs'),
              const SizedBox(width: 8),
              _statChip(context, '118', 'Wickets'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statChip(BuildContext context, String value, String label) {
    final colors = context.colorScheme;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: colors.containerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.outline),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppTextStyle.subtitle2.copyWith(color: colors.textPrimary),
            ),
            Text(
              label,
              style: AppTextStyle.caption.copyWith(color: colors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickActions(BuildContext context, UserProfile? profile) {
    final colors = context.colorScheme;
    final items = [
      ('Edit profile', 'assets/images/ic_edit.svg'),
      ('Share profile', 'assets/images/ic_share.svg'),
      ('Show QR code', 'assets/images/ic_qr_code.svg'),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: items
            .map(
              (item) => Expanded(
                child: OnTapScale(
                  onTap: () {
                    if (item.$1 == 'Edit profile' && profile != null) {
                      pushScreen(
                        context,
                        EditProfileScreen(profile: profile),
                      );
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: colors.containerLow,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors.outline),
                    ),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          item.$2,
                          width: 20,
                          height: 20,
                          colorFilter: ColorFilter.mode(
                            colors.primary,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.$1,
                          textAlign: TextAlign.center,
                          style: AppTextStyle.body2.copyWith(
                            color: colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _actionTile(BuildContext context, ProfileAction action) {
    final colors = context.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListTile(
        leading: SvgPicture.asset(
          action.iconPath,
          width: 22,
          height: 22,
          colorFilter: ColorFilter.mode(colors.textPrimary, BlendMode.srcIn),
        ),
        title: Text(
          action.title,
          style: AppTextStyle.body1.copyWith(color: colors.textPrimary),
        ),
        trailing: Icon(Icons.chevron_right, color: colors.textDisabled),
        onTap: () {
          if (action.title == 'Notifications') {
            pushScreen(context, const NotificationsScreen());
          } else {
            pushScreen(context, const SettingsScreen());
          }
        },
      ),
    );
  }
}
