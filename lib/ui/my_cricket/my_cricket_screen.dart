import 'package:characters/characters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:style/button/action_button.dart';
import 'package:style/button/tab_button.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';

import '../create/create_match_screen.dart';
import '../create/create_team_screen.dart';
import '../create/create_tournament_screen.dart';
import '../navigation.dart';
import '../sample_data.dart';
import '../widgets/match_card.dart';
import '../widgets/section_header.dart';
import '../widgets/tournament_card.dart';

class MyCricketScreen extends StatefulWidget {
  const MyCricketScreen({super.key});

  @override
  State<MyCricketScreen> createState() => _MyCricketScreenState();
}

class _MyCricketScreenState extends State<MyCricketScreen> {
  late PageController _controller;
  int _selectedTab = 0;

  final _teams = const [
    ('Old Monks', '12 players', 'Navrangpura'),
    ('Garden XI', '15 players', 'Science City'),
    ('Street Hawks', '11 players', 'Naroda'),
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: _selectedTab);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = context.mediaQueryPadding;
    final colors = context.colorScheme;
    return ColoredBox(
      color: colors.surface,
      child: Column(
        children: [
          SizedBox(height: padding.top + 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'My Cricket',
                  style: AppTextStyle.header3.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                const Spacer(),
                actionButton(
                  context,
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final targets = [
                      const CreateMatchScreen(),
                      const CreateTeamScreen(),
                      const CreateTournamentScreen(),
                    ];
                    pushScreen(context, targets[_selectedTab]);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _tabBar(context),
          Expanded(
            child: PageView(
              controller: _controller,
              pageSnapping: false,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (tab) => setState(() => _selectedTab = tab),
              children: [
                _matchesTab(context),
                _teamTab(context),
                _tournamentTab(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabBar(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          const SizedBox(width: 4),
          TabButton(
            'Matches',
            selected: _selectedTab == 0,
            onTap: () => _controller.jumpToPage(0),
          ),
          const SizedBox(width: 8),
          TabButton(
            'Teams',
            selected: _selectedTab == 1,
            onTap: () => _controller.jumpToPage(1),
          ),
          const SizedBox(width: 8),
          TabButton(
            'Tournaments',
            selected: _selectedTab == 2,
            onTap: () => _controller.jumpToPage(2),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }

  Widget _matchesTab(BuildContext context) {
    final allMatches = matchGroups.values.expand((list) => list).toList();
    final colors = context.colorScheme;
    return ListView(
      padding: EdgeInsets.only(
        top: 12,
        bottom: 24 + context.mediaQueryPadding.bottom,
      ),
      children: [
        const SectionHeader(title: 'All matches'),
        SizedBox(
          height: 250,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: allMatches
                .map((match) => MatchCard(match: match))
                .toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: colors.containerLow,
              border: Border.all(color: colors.outline),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/images/ic_group.svg',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    colors.primary,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Invite scorers and captains to keep your games updated.',
                    style: AppTextStyle.body1.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: colors.textDisabled,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _teamTab(BuildContext context) {
    final colors = context.colorScheme;
    return ListView.separated(
      padding: EdgeInsets.only(
        top: 12,
        left: 16,
        right: 16,
        bottom: 24 + context.mediaQueryPadding.bottom,
      ),
      itemBuilder: (context, index) {
        final team = _teams[index];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colors.containerLow,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.outline),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: colors.primary.withOpacity(0.14),
                child: Text(
                  team.$1.characters.first.toUpperCase(),
                  style: AppTextStyle.subtitle2.copyWith(color: colors.primary),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(
                      team.$1,
                      style: AppTextStyle.subtitle2.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    Text(
                      '${team.$2} • ${team.$3}',
                      style: AppTextStyle.body2.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              actionButton(
                context,
                shrinkWrap: true,
                icon: const Icon(Icons.more_horiz),
                onPressed: () {},
              ),
            ],
          ),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: _teams.length,
    );
  }

  Widget _tournamentTab(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(
        top: 12,
        bottom: 24 + context.mediaQueryPadding.bottom,
      ),
      itemCount: tournaments.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const SectionHeader(title: 'Saved tournaments');
        }
        final data = tournaments[index - 1];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: TournamentCard(data: data),
        );
      },
    );
  }
}
