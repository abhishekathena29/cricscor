import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';

import '../sample_data.dart';
import '../widgets/section_header.dart';
import '../widgets/stat_tile.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = context.mediaQueryPadding;
    final colors = context.colorScheme;
    return ColoredBox(
      color: colors.surface,
      child: ListView(
        padding: EdgeInsets.only(
          top: padding.top + 12,
          bottom: padding.bottom + 28,
          left: 16,
          right: 16,
        ),
        children: [
          Row(
            children: [
              Text(
                'Stats',
                style: AppTextStyle.header3.copyWith(color: colors.textPrimary),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.ios_share_rounded),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _overviewCard(context),
          const SectionHeader(title: 'Your numbers'),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemCount: statTiles.length,
            itemBuilder: (context, index) => StatTile(stat: statTiles[index]),
          ),
          const SectionHeader(title: 'Recent highlights'),
          ..._highlights(context),
        ],
      ),
    );
  }

  Widget _overviewCard(BuildContext context) {
    final colors = context.colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.containerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outline),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: colors.primary.withOpacity(0.14),
            child: SvgPicture.asset(
              'assets/images/ic_profile_thin.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(colors.primary, BlendMode.srcIn),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(
                  'Siddharth Sheth',
                  style: AppTextStyle.subtitle2.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                Text(
                  'All-rounder • Right arm medium',
                  style: AppTextStyle.body2.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                Text(
                  'Playing since 2019',
                  style: AppTextStyle.caption.copyWith(
                    color: colors.textDisabled,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '7.8',
                  style: AppTextStyle.header3.copyWith(color: colors.primary),
                ),
                Text(
                  'Form index',
                  style: AppTextStyle.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _highlights(BuildContext context) {
    final colors = context.colorScheme;
    final items = [
      (
        'Player of the match',
        '126* (62) vs Metro Titans',
        'assets/images/ic_star.svg',
      ),
      ('Best bowling', '4/12 vs River Riders', 'assets/images/ic_referee.svg'),
      ('Winning streak', '4 matches • Jan 2024', 'assets/images/ic_flash.svg'),
    ];
    return items
        .map(
          (item) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.containerLow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.outline),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  item.$3,
                  width: 22,
                  height: 22,
                  colorFilter: ColorFilter.mode(
                    colors.primary,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 2,
                    children: [
                      Text(
                        item.$1,
                        style: AppTextStyle.subtitle3.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                      Text(
                        item.$2,
                        style: AppTextStyle.body2.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        )
        .toList();
  }
}
