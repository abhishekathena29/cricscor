import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:style/button/action_button.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';

import '../create/create_match_screen.dart';
import '../create/create_team_screen.dart';
import '../create/create_tournament_screen.dart';
import '../create/provider/create_provider.dart';
import '../navigation.dart';
import '../search/search_screen.dart';
import '../widgets/action_pill.dart';
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
                Image.asset(
                  'assets/images/ic_app_logo.png',
                  width: 28,
                  height: 28,
                ),
                const SizedBox(width: 5),
                Text(
                  'CricScor',
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
          _tournamentCarousel(context),
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
          _matchStreamSection(context),
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
            onTap: () => pushScreen(context, CreateTeamScreen()),
          ),
          ActionPill(
            title: 'Set up a match',
            subtitle: 'Create match',
            icon: Icons.sports_cricket_outlined,
            onTap: () => pushScreen(context, CreateMatchScreen()),
          ),
          ActionPill(
            title: 'Set up tournament',
            subtitle: 'Create tournament',
            icon: Icons.emoji_events_outlined,
            onTap: () => pushScreen(context, CreateTournamentScreen()),
          ),
        ],
      ),
    );
  }

  Widget _tournamentCarousel(BuildContext context) {
    final provider = context.read<CreateProvider>();
    return StreamBuilder<List<TournamentItem>>(
      stream: provider.watchTournaments(),
      builder: (context, snapshot) {
        final items = snapshot.data ?? [];
        if (items.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: _emptyCard(
              context,
              title: 'No tournaments yet',
              subtitle: 'Create a tournament to see it here.',
              actionLabel: 'Create tournament',
              onTap: () => pushScreen(context, const CreateTournamentScreen()),
            ),
          );
        }
        return SizedBox(
          height: 170,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: items
                .map((tournament) => TournamentCard(data: tournament))
                .toList(),
          ),
        );
      },
    );
  }

  Widget _matchStreamSection(BuildContext context) {
    final provider = context.read<CreateProvider>();
    return StreamBuilder<List<MatchItem>>(
      stream: provider.watchMatches(),
      builder: (context, snapshot) {
        final matches = snapshot.data ?? [];
        if (matches.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: _emptyCard(
              context,
              title: 'No matches scheduled',
              subtitle: 'Set up your first match to see it here.',
              actionLabel: 'Create match',
              onTap: () => pushScreen(context, const CreateMatchScreen()),
            ),
          );
        }
        final grouped = {
          MatchStatus.live: matches
              .where((m) => m.status == MatchStatus.live)
              .toList(),
          MatchStatus.upcoming: matches
              .where((m) => m.status == MatchStatus.upcoming)
              .toList(),
          MatchStatus.completed: matches
              .where((m) => m.status == MatchStatus.completed)
              .toList(),
        };

        return Column(
          children: grouped.entries.expand((entry) {
            final list = entry.value;
            if (list.isEmpty) return <Widget>[];
            return [
              SectionHeader(
                title: _statusTitle(entry.key),
                onViewAll: list.length > 2 ? () {} : null,
              ),
              SizedBox(
                height: 250,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  children: list
                      .map((match) => MatchCard(match: match))
                      .toList(),
                ),
              ),
            ];
          }).toList(),
        );
      },
    );
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

  Widget _emptyCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String actionLabel,
    required VoidCallback onTap,
  }) {
    final colors = context.colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outline),
        color: colors.containerLow,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 6,
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
              ],
            ),
          ),
          const SizedBox(width: 12),
          OutlinedButton(onPressed: onTap, child: Text(actionLabel)),
        ],
      ),
    );
  }
}
