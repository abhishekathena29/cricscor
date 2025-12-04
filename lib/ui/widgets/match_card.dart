import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:style/animations/on_tap_scale.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';

import '../sample_data.dart';
import '../match/match_scoring_screen.dart';
import '../navigation.dart';

class MatchCard extends StatelessWidget {
  final MatchCardData match;

  const MatchCard({super.key, required this.match});

  Color _statusColor(BuildContext context) {
    final colors = context.colorScheme;
    switch (match.status) {
      case MatchStatus.live:
        return colors.alert;
      case MatchStatus.upcoming:
        return colors.info;
      case MatchStatus.completed:
        return colors.positive;
    }
  }

  String _statusLabel() {
    switch (match.status) {
      case MatchStatus.live:
        return 'Live';
      case MatchStatus.upcoming:
        return 'Upcoming';
      case MatchStatus.completed:
        return 'Completed';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return OnTapScale(
      onTap: () => pushScreen(
        context,
        MatchScoringScreen(title: '${match.teamA} vs ${match.teamB}'),
      ),
      child: Container(
        width: 280,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.containerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor(context).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    _statusLabel(),
                    style: AppTextStyle.caption.copyWith(
                      color: _statusColor(context),
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  match.format,
                  style: AppTextStyle.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
            Text(
              '${match.teamA} vs ${match.teamB}',
              style: AppTextStyle.subtitle2.copyWith(color: colors.textPrimary),
            ),
            Text(
              match.summary,
              style: AppTextStyle.body2.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/images/ic_location.svg',
                  width: 16,
                  height: 16,
                  colorFilter: ColorFilter.mode(
                    colors.textDisabled,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    match.ground,
                    style: AppTextStyle.body2.copyWith(
                      color: colors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/images/ic_calendar.svg',
                  width: 16,
                  height: 16,
                  colorFilter: ColorFilter.mode(
                    colors.textDisabled,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  match.time,
                  style: AppTextStyle.body2.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
