import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:style/button/action_button.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';

import '../create/create_match_screen.dart';
import '../create/create_team_screen.dart';
import '../create/create_tournament_screen.dart';
import '../leaderboard/leaderboard_screen.dart';
import '../navigation.dart';
import '../sample_data.dart';
import '../search/search_screen.dart';
import '../widgets/action_pill.dart';
import '../widgets/leaderboard_card.dart';
import '../widgets/match_card.dart';
import '../widgets/section_header.dart';
import '../widgets/tournament_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = context.mediaQueryPadding;
    final colors = context.colorScheme;
    return ColoredBox(
      color: colors.surface,
      child: ListView(
        padding: EdgeInsets.only(
          top: padding.top + 16,
          bottom: padding.bottom + 32,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/images/ic_app_logo.svg',
                  width: 28,
                  height: 28,
                  colorFilter: ColorFilter.mode(
                    colors.primary,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Khelo UI',
                  style: AppTextStyle.subtitle2.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                const Spacer(),
                actionButton(
                  context,
                  icon: SvgPicture.asset(
                    'assets/images/ic_search.svg',
                    colorFilter: ColorFilter.mode(
                      colors.textPrimary,
                      BlendMode.srcIn,
                    ),
                  ),
                  onPressed: () => pushScreen(context, const SearchScreen()),
                ),
                actionButton(
                  context,
                  icon: SvgPicture.asset(
                    'assets/images/ic_notification_bell.svg',
                    colorFilter: ColorFilter.mode(
                      colors.textPrimary,
                      BlendMode.srcIn,
                    ),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _actionRow(context),
          const SizedBox(height: 8),
          SectionHeader(title: 'Tournaments', onViewAll: () {}),
          SizedBox(
            height: 170,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: tournaments
                  .map((tournament) => TournamentCard(data: tournament))
                  .toList(),
            ),
          ),
          // SectionHeader(
          //   title: 'Leaderboard',
          //   onViewAll: () => pushScreen(context, const LeaderboardScreen()),
          // ),
          // SizedBox(
          //   height: 190,
          //   child: ListView(
          //     scrollDirection: Axis.horizontal,
          //     padding: const EdgeInsets.symmetric(horizontal: 8),
          //     children: leaderboardGroups
          //         .map((group) => LeaderboardCard(group: group))
          //         .toList(),
          //   ),
          // ),
          ..._matchSections(context),
        ],
      ),
    );
  }

  Widget _actionRow(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: [
          ActionPill(
            title: 'Set up your team',
            subtitle: 'Create team',
            icon: Icons.group_add_outlined,
            onTap: () => pushScreen(context, const CreateTeamScreen()),
          ),
          ActionPill(
            title: 'Set up a match',
            subtitle: 'Create match',
            icon: Icons.sports_cricket_outlined,
            onTap: () => pushScreen(context, const CreateMatchScreen()),
          ),
          ActionPill(
            title: 'Set up tournament',
            subtitle: 'Create tournament',
            icon: Icons.emoji_events_outlined,
            onTap: () => pushScreen(context, const CreateTournamentScreen()),
          ),
        ],
      ),
    );
  }

  List<Widget> _matchSections(BuildContext context) {
    return MatchStatus.values.expand((status) {
      final matches = matchGroups[status] ?? [];
      if (matches.isEmpty) return <Widget>[];

      return [
        SectionHeader(
          title: _statusTitle(status),
          onViewAll: matches.length > 2 ? () {} : null,
        ),
        SizedBox(
          height: 250,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: matches.map((match) => MatchCard(match: match)).toList(),
          ),
        ),
      ];
    }).toList();
  }

  String _statusTitle(MatchStatus status) {
    switch (status) {
      case MatchStatus.live:
        return 'Live matches';
      case MatchStatus.upcoming:
        return 'Upcoming matches';
      case MatchStatus.completed:
        return 'Recent results';
    }
  }
}
