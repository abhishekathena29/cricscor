import 'package:flutter/material.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';

import '../sample_data.dart';
import '../widgets/leaderboard_card.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'See who is leading this season across batting, bowling and all-round stats.',
              style: AppTextStyle.body1.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: 12),
            ...leaderboardGroups
                .map(
                  (group) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: LeaderboardCard(group: group),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}
