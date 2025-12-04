import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';

class MatchScoringScreen extends StatelessWidget {
  final String title;

  const MatchScoringScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              'assets/images/ic_share.svg',
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(
                colors.textPrimary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              _scoreHeader(context),
              _infoRow(context),
              _batterList(context),
              _bowlerList(context),
              _quickActions(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _bottomControls(context),
    );
  }

  Widget _scoreHeader(BuildContext context) {
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 6,
            children: [
              Text(
                'North Blazers',
                style: AppTextStyle.subtitle2.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              Text(
                '64/2',
                style: AppTextStyle.header2.copyWith(color: colors.textPrimary),
              ),
              Text(
                '7.3 overs',
                style: AppTextStyle.body2.copyWith(color: colors.textSecondary),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'Target 142',
                  style: AppTextStyle.subtitle3.copyWith(color: colors.primary),
                ),
                Text(
                  'RR 8.53',
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

  Widget _infoRow(BuildContext context) {
    final colors = context.colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.outline),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _chip(context, 'Leather ball'),
          _chip(context, 'Day • T20'),
          _chip(context, 'Sabarmati Arena'),
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, String label) {
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

  Widget _batterList(BuildContext context) {
    final colors = context.colorScheme;
    final batters = [
      ('Ravi Patel', '26', '14', true),
      ('Harsh Desai', '18', '12', false),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          'Batters',
          style: AppTextStyle.subtitle2.copyWith(color: colors.textPrimary),
        ),
        ...batters.map(
          (batter) => Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.outline),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.sports_cricket,
                  color: batter.$4 ? colors.primary : colors.textSecondary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4,
                    children: [
                      Text(
                        batter.$1,
                        style: AppTextStyle.body1.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                      Text(
                        '${batter.$2} (${batter.$3})',
                        style: AppTextStyle.caption.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.more_horiz, color: colors.textDisabled),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _bowlerList(BuildContext context) {
    final colors = context.colorScheme;
    final bowlers = [
      ('Moin Shaikh', '2/18', '3.0'),
      ('Deep Singh', '0/12', '2.3'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          'Bowlers',
          style: AppTextStyle.subtitle2.copyWith(color: colors.textPrimary),
        ),
        ...bowlers.map(
          (bowler) => Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.outline),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/images/bowler.svg',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    colors.primary,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4,
                    children: [
                      Text(
                        bowler.$1,
                        style: AppTextStyle.body1.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                      Text(
                        '${bowler.$2} in ${bowler.$3} ov',
                        style: AppTextStyle.caption.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.more_horiz, color: colors.textDisabled),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _quickActions(BuildContext context) {
    final colors = context.colorScheme;
    final actions = [
      ('Add ball', Icons.add_circle_outline),
      ('Retire hurt', Icons.personal_injury_outlined),
      ('Swap striker', Icons.swap_horiz_rounded),
      ('End innings', Icons.flag_outlined),
    ];
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: actions
          .map(
            (action) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: colors.containerLow,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.outline),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(action.$2, color: colors.textPrimary),
                  const SizedBox(width: 8),
                  Text(
                    action.$1,
                    style: AppTextStyle.body2.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _bottomControls(BuildContext context) {
    final colors = context.colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: colors.outline),
                ),
                onPressed: () {},
                child: const Text('Pause'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                ),
                onPressed: () {},
                child: const Text('Save over'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
