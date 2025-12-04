import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:style/animations/on_tap_scale.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';

import '../create/provider/create_provider.dart';
import '../match/match_scoring_screen.dart';
import '../navigation.dart';

class MatchCard extends StatelessWidget {
  final MatchItem match;

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

  String _timeLabel() {
    if (match.status == MatchStatus.live && (match.runs > 0 || match.balls > 0)) {
      return match.summary;
    }
    if (match.status == MatchStatus.completed && (match.runs > 0 || match.balls > 0)) {
      return match.summary;
    }
    return DateFormat('dd MMM • hh:mm a').format(match.startTime);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return OnTapScale(
      onTap: () => pushScreen(
        context,
        MatchScoringScreen(
          matchId: match.id,
          title: '${match.teamA.name} vs ${match.teamB.name}',
        ),
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
                  match.formatLabel,
                  style: AppTextStyle.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
            Text(
              '${match.teamA.name} vs ${match.teamB.name}',
              style: AppTextStyle.subtitle2.copyWith(color: colors.textPrimary),
            ),
            Text(
              _timeLabel(),
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
                  DateFormat('EEE, dd MMM • hh:mm a').format(match.startTime),
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
