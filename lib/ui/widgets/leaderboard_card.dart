import 'package:characters/characters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:style/animations/on_tap_scale.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';

import '../sample_data.dart';

class LeaderboardCard extends StatelessWidget {
  final LeaderboardGroup group;

  const LeaderboardCard({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return OnTapScale(
      onTap: () {},
      child: Container(
        width: 320,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 14,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    group.title,
                    style: AppTextStyle.caption.copyWith(
                      color: colors.textDisabled,
                    ),
                  ),
                ),
                SvgPicture.asset(
                  'assets/images/ic_arrow_forward.svg',
                  width: 16,
                  height: 16,
                  colorFilter: ColorFilter.mode(
                    colors.textDisabled,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
            Row(
              spacing: 10,
              children: group.players
                  .map(
                    (player) => Expanded(child: _playerTile(context, player)),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _playerTile(BuildContext context, LeaderboardPlayer player) {
    final colors = context.colorScheme;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colors.containerLow,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.outline),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: colors.primary.withOpacity(0.14),
            child: Text(
              player.name.characters.first.toUpperCase(),
              style: AppTextStyle.subtitle2.copyWith(color: colors.primary),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            player.name,
            style: AppTextStyle.body1.copyWith(color: colors.textPrimary),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            player.role,
            style: AppTextStyle.caption.copyWith(color: colors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            '${player.score} pts',
            style: AppTextStyle.caption.copyWith(color: colors.textPrimary),
          ),
        ],
      ),
    );
  }
}
