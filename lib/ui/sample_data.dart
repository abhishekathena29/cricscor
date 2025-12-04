enum MatchStatus { live, upcoming, completed }

class MatchCardData {
  final String teamA;
  final String teamB;
  final String ground;
  final String time;
  final MatchStatus status;
  final String summary;
  final String format;

  const MatchCardData({
    required this.teamA,
    required this.teamB,
    required this.ground,
    required this.time,
    required this.status,
    required this.summary,
    required this.format,
  });
}

class TournamentCardData {
  final String name;
  final String location;
  final String dates;
  final int teams;
  final int matches;

  const TournamentCardData({
    required this.name,
    required this.location,
    required this.dates,
    required this.teams,
    required this.matches,
  });
}

class LeaderboardPlayer {
  final String name;
  final String role;
  final int score;

  const LeaderboardPlayer({
    required this.name,
    required this.role,
    required this.score,
  });
}

class LeaderboardGroup {
  final String title;
  final List<LeaderboardPlayer> players;

  const LeaderboardGroup({required this.title, required this.players});
}

class StatTileData {
  final String label;
  final String value;
  final String helper;
  final String iconPath;

  const StatTileData({
    required this.label,
    required this.value,
    required this.helper,
    required this.iconPath,
  });
}

class ProfileAction {
  final String title;
  final String iconPath;

  const ProfileAction({required this.title, required this.iconPath});
}

const tournaments = [
  TournamentCardData(
    name: 'Gully Premier League',
    location: 'Ahmedabad, India',
    dates: 'Jan 20 - Feb 02',
    teams: 12,
    matches: 30,
  ),
  TournamentCardData(
    name: 'Winter Cup 2024',
    location: 'Surat',
    dates: 'Feb 10 - Mar 05',
    teams: 8,
    matches: 20,
  ),
];

const leaderboardGroups = [
  LeaderboardGroup(
    title: 'Top Batters',
    players: [
      LeaderboardPlayer(name: 'Ravi Patel', role: 'Opener', score: 412),
      LeaderboardPlayer(name: 'Harsh Desai', role: 'No.3', score: 388),
      LeaderboardPlayer(name: 'S. Kulkarni', role: 'Finisher', score: 355),
    ],
  ),
  LeaderboardGroup(
    title: 'Top Bowlers',
    players: [
      LeaderboardPlayer(name: 'Moin Shaikh', role: 'Left-arm Fast', score: 22),
      LeaderboardPlayer(name: 'Deep Singh', role: 'Off Spin', score: 18),
      LeaderboardPlayer(name: 'Pranav Modi', role: 'Leg Spin', score: 16),
    ],
  ),
];

const matchGroups = {
  MatchStatus.live: [
    MatchCardData(
      teamA: 'North Blazers',
      teamB: 'Downtown Kings',
      ground: 'Sabarmati Arena',
      time: 'Live - 7.3 ov',
      status: MatchStatus.live,
      summary: 'NB 64/2 • Target 142',
      format: 'T20',
    ),
  ],
  MatchStatus.upcoming: [
    MatchCardData(
      teamA: 'Red Falcons',
      teamB: 'Blue Warriors',
      ground: 'Narol Ground',
      time: 'Today • 4:00 PM',
      status: MatchStatus.upcoming,
      summary: 'Knockout • Leather ball',
      format: 'T20',
    ),
    MatchCardData(
      teamA: 'River Riders',
      teamB: 'Metro Titans',
      ground: 'Riverfront',
      time: 'Tomorrow • 8:00 AM',
      status: MatchStatus.upcoming,
      summary: 'League • Tennis ball',
      format: 'T10',
    ),
  ],
  MatchStatus.completed: [
    MatchCardData(
      teamA: 'Skyline CC',
      teamB: 'Royal Strikers',
      ground: 'Sardar Patel Stadium',
      time: 'Yesterday',
      status: MatchStatus.completed,
      summary: 'Skyline won by 6 runs',
      format: 'OD',
    ),
  ],
};

const statTiles = [
  StatTileData(
    label: 'Runs',
    value: '2,310',
    helper: 'Career total',
    iconPath: 'assets/images/ic_bat_selected.svg',
  ),
  StatTileData(
    label: 'Wickets',
    value: '118',
    helper: 'Across formats',
    iconPath: 'assets/images/ic_umpire.svg',
  ),
  StatTileData(
    label: 'Matches',
    value: '164',
    helper: 'Recorded in Khelo',
    iconPath: 'assets/images/ic_tournaments.svg',
  ),
  StatTileData(
    label: 'Best Score',
    value: '126*',
    helper: 'vs Metro Titans',
    iconPath: 'assets/images/ic_star.svg',
  ),
];

const profileActions = [
  ProfileAction(
    title: 'Notifications',
    iconPath: 'assets/images/ic_notification_bell.svg',
  ),
  ProfileAction(
    title: 'Privacy Policy',
    iconPath: 'assets/images/ic_privacy_policy.svg',
  ),
  ProfileAction(
    title: 'Terms & Conditions',
    iconPath: 'assets/images/ic_terms_conditions.svg',
  ),
  ProfileAction(
    title: 'Contact Support',
    iconPath: 'assets/images/ic_contact_support.svg',
  ),
  ProfileAction(title: 'About', iconPath: 'assets/images/ic_about_us.svg'),
];
