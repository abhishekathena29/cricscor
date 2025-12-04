import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:style/animations/on_tap_scale.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';

import '../create/provider/create_provider.dart';

class TournamentCard extends StatelessWidget {
  final TournamentItem data;

  const TournamentCard({super.key, required this.data});

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
          color: colors.containerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SvgPicture.asset(
                    'assets/images/ic_tournaments.svg',
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      colors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.name,
                        style: AppTextStyle.subtitle2.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                      Text(
                        data.dates,
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
                    data.location,
                    style: AppTextStyle.body2.copyWith(
                      color: colors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Divider(height: 1),
            Row(
              children: [
                _pill(context, '${data.teamsCount} Teams'),
                const SizedBox(width: 8),
                _pill(context, '${data.matches} Matches'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _pill(BuildContext context, String label) {
    final colors = context.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colors.containerLow,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: colors.outline),
      ),
      child: Text(
        label,
        style: AppTextStyle.caption.copyWith(color: colors.textSecondary),
      ),
    );
  }
}
