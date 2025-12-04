import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TeamOption {
  final String id;
  final String name;
  final String? city;

  TeamOption({
    required this.id,
    required this.name,
    this.city,
  });

  factory TeamOption.fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return TeamOption(
      id: doc.id,
      name: (data['name'] as String?)?.trim() ?? '',
      city: (data['city'] as String?)?.trim(),
    );
  }
}

enum MatchStatus { live, upcoming, completed }

MatchStatus _statusFromString(String? value) {
  switch (value) {
    case 'live':
      return MatchStatus.live;
    case 'completed':
      return MatchStatus.completed;
    default:
      return MatchStatus.upcoming;
  }
}

String _statusToString(MatchStatus status) {
  switch (status) {
    case MatchStatus.live:
      return 'live';
    case MatchStatus.completed:
      return 'completed';
    case MatchStatus.upcoming:
      return 'upcoming';
  }
}

class MatchItem {
  final String id;
  final String title;
  final String ground;
  final DateTime startTime;
  final TeamOption teamA;
  final TeamOption teamB;
  final String ballType;
  final String overs;
  final MatchStatus status;
  final int runs;
  final int wickets;
  final int balls;

  MatchItem({
    required this.id,
    required this.title,
    required this.ground,
    required this.startTime,
    required this.teamA,
    required this.teamB,
    required this.ballType,
    required this.overs,
    required this.status,
    required this.runs,
    required this.wickets,
    required this.balls,
  });

  String get formatLabel => overs;

  String get summary {
    if (runs > 0 || wickets > 0) {
      final oversText = '${balls ~/ 6}.${balls % 6} ov';
      return '$runs/$wickets • $oversText';
    }
    return 'Starts at ${DateFormat('dd MMM, hh:mm a').format(startTime)}';
  }

  factory MatchItem.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    final teamAData = data['teamA'] as Map<String, dynamic>? ?? {};
    final teamBData = data['teamB'] as Map<String, dynamic>? ?? {};
    final score = data['score'] as Map<String, dynamic>? ?? {};
    return MatchItem(
      id: doc.id,
      title: (data['title'] as String?)?.trim() ?? 'Match',
      ground: (data['ground'] as String?)?.trim() ?? '',
      startTime: (data['startTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      teamA: TeamOption(
        id: (teamAData['id'] as String?) ?? '',
        name: (teamAData['name'] as String?) ?? '',
      ),
      teamB: TeamOption(
        id: (teamBData['id'] as String?) ?? '',
        name: (teamBData['name'] as String?) ?? '',
      ),
      ballType: (data['ballType'] as String?) ?? '',
      overs: (data['overs'] as String?) ?? '',
      status: _statusFromString(data['status'] as String?),
      runs: (score['runs'] as num?)?.toInt() ?? 0,
      wickets: (score['wickets'] as num?)?.toInt() ?? 0,
      balls: (score['balls'] as num?)?.toInt() ?? 0,
    );
  }

  MatchItem copyWith({
    MatchStatus? status,
    int? runs,
    int? wickets,
    int? balls,
  }) {
    return MatchItem(
      id: id,
      title: title,
      ground: ground,
      startTime: startTime,
      teamA: teamA,
      teamB: teamB,
      ballType: ballType,
      overs: overs,
      status: status ?? this.status,
      runs: runs ?? this.runs,
      wickets: wickets ?? this.wickets,
      balls: balls ?? this.balls,
    );
  }
}

class TournamentItem {
  final String id;
  final String name;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final String format;
  final String ballType;
  final int teamsCount;
  final int matches;

  TournamentItem({
    required this.id,
    required this.name,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.format,
    required this.ballType,
    required this.teamsCount,
    required this.matches,
  });

  String get dates =>
      '${DateFormat('dd MMM').format(startDate)} - ${DateFormat('dd MMM').format(endDate)}';

  factory TournamentItem.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return TournamentItem(
      id: doc.id,
      name: (data['name'] as String?) ?? '',
      location: (data['location'] as String?) ?? '',
      startDate: (data['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endDate: (data['endDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      format: (data['format'] as String?) ?? '',
      ballType: (data['ballType'] as String?) ?? '',
      teamsCount: (data['teamsCount'] as num?)?.toInt() ?? 0,
      matches: (data['matches'] as num?)?.toInt() ?? 0,
    );
  }
}

class CreateProvider with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  bool _savingTeam = false;
  bool _savingMatch = false;
  bool _savingTournament = false;
  bool _loadingTeams = false;
  String? _error;
  List<TeamOption> _teams = [];

  bool get savingTeam => _savingTeam;
  bool get savingMatch => _savingMatch;
  bool get savingTournament => _savingTournament;
  bool get loadingTeams => _loadingTeams;
  String? get error => _error;
  List<TeamOption> get teams => List.unmodifiable(_teams);

  Future<void> loadTeams() async {
    _loadingTeams = true;
    notifyListeners();
    try {
      final snapshot = await _firestore
          .collection('teams')
          .orderBy('name', descending: false)
          .get();
      _teams = snapshot.docs.map(TeamOption.fromDoc).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loadingTeams = false;
      notifyListeners();
    }
  }

  Future<void> createTeam({
    required String name,
    required List<String> players,
    String? city,
    String? ground,
    String? captain,
    String? viceCaptain,
  }) async {
    _savingTeam = true;
    notifyListeners();
    try {
      final userId = _auth.currentUser?.uid;
      final data = <String, dynamic>{
        'name': name.trim(),
        if (city != null && city.isNotEmpty) 'city': city.trim(),
        if (ground != null && ground.isNotEmpty) 'ground': ground.trim(),
        'players': players,
        if (captain != null) 'captain': captain,
        if (viceCaptain != null) 'vice_captain': viceCaptain,
        if (userId != null) 'scorer': userId,
        'createdBy': userId,
        'createdAt': Timestamp.now(),
      };
      await _firestore.collection('teams').add(data);
      await loadTeams(); // Refresh local cache so new team is selectable.
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _savingTeam = false;
      notifyListeners();
    }
  }

  Future<void> createMatch({
    required String title,
    required String ground,
    required DateTime startTime,
    required TeamOption teamA,
    required TeamOption teamB,
    required String ballType,
    required String overs,
    required bool powerplay,
    required bool freeHit,
    required bool duckworthLewis,
  }) async {
    _savingMatch = true;
    notifyListeners();
    try {
      final userId = _auth.currentUser?.uid;
      await _firestore.collection('matches').add({
        'title': title.trim(),
        'ground': ground.trim(),
        'startTime': Timestamp.fromDate(startTime),
        'teamA': {
          'id': teamA.id,
          'name': teamA.name,
        },
        'teamB': {
          'id': teamB.id,
          'name': teamB.name,
        },
        'ballType': ballType,
        'overs': overs,
        'powerplay': powerplay,
        'freeHit': freeHit,
        'duckworthLewis': duckworthLewis,
        'createdBy': userId,
        'createdAt': Timestamp.now(),
        'status': _statusToString(MatchStatus.upcoming),
        'score': {
          'runs': 0,
          'wickets': 0,
          'balls': 0,
        },
      });
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _savingMatch = false;
      notifyListeners();
    }
  }

  Future<void> createTournament({
    required String name,
    required String location,
    required DateTime startDate,
    required DateTime endDate,
    required String format,
    required String ballType,
    required int teamsCount,
    required int overs,
    required bool superOver,
    required bool thirdUmpire,
    String? organizer,
    String? umpire,
    String? scorer,
  }) async {
    _savingTournament = true;
    notifyListeners();
    try {
      final userId = _auth.currentUser?.uid;
      await _firestore.collection('tournaments').add({
        'name': name.trim(),
        'location': location.trim(),
        'startDate': Timestamp.fromDate(startDate),
        'endDate': Timestamp.fromDate(endDate),
        'format': format,
        'ballType': ballType,
        'teamsCount': teamsCount,
        'overs': overs,
        'superOver': superOver,
        'thirdUmpire': thirdUmpire,
        if (organizer != null && organizer.isNotEmpty)
          'organizer': organizer.trim(),
        if (umpire != null && umpire.isNotEmpty) 'umpire': umpire.trim(),
        if (scorer != null && scorer.isNotEmpty) 'scorer': scorer.trim(),
        'createdBy': userId,
        'createdAt': Timestamp.now(),
        'matches': 0,
      });
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _savingTournament = false;
      notifyListeners();
    }
  }

  Stream<List<MatchItem>> watchMatches() {
    return _firestore
        .collection('matches')
        .orderBy('startTime', descending: false)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map(MatchItem.fromDoc).toList(growable: false),
        );
  }

  Stream<List<TournamentItem>> watchTournaments() {
    return _firestore
        .collection('tournaments')
        .orderBy('startDate', descending: false)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map(TournamentItem.fromDoc).toList(growable: false),
        );
  }

  Stream<MatchItem?> watchMatch(String matchId) {
    return _firestore
        .collection('matches')
        .doc(matchId)
        .snapshots()
        .map((doc) => doc.exists ? MatchItem.fromDoc(doc) : null);
  }

  Future<List<String>> fetchTeamPlayers(String teamId) async {
    if (teamId.isEmpty) return [];
    final doc =
        await _firestore.collection('teams').doc(teamId).get(const GetOptions());
    final data = doc.data() as Map<String, dynamic>?;
    final players = data?['players'] as List<dynamic>? ?? [];
    return players.map((e) => e.toString()).toList();
  }

  Future<void> addBallEvent({
    required MatchItem match,
    required String striker,
    required String nonStriker,
    required String bowler,
    required int runs,
    String? extraType,
    bool wicket = false,
  }) async {
    final matchRef = _firestore.collection('matches').doc(match.id);
    await _firestore.runTransaction((txn) async {
      final snap = await txn.get(matchRef);
      final data = snap.data() as Map<String, dynamic>? ?? {};
      final score = data['score'] as Map<String, dynamic>? ?? {};
      int currentRuns = (score['runs'] as num?)?.toInt() ?? 0;
      int currentWickets = (score['wickets'] as num?)?.toInt() ?? 0;
      int currentBalls = (score['balls'] as num?)?.toInt() ?? 0;

      final isLegal = extraType == null || extraType.isEmpty;
      final updatedRuns = currentRuns + runs;
      final updatedWickets = currentWickets + (wicket ? 1 : 0);
      final updatedBalls = isLegal ? currentBalls + 1 : currentBalls;

      txn.update(matchRef, {
        'score': {
          'runs': updatedRuns,
          'wickets': updatedWickets,
          'balls': updatedBalls,
          'striker': striker,
          'nonStriker': nonStriker,
          'bowler': bowler,
        },
        'status': _statusToString(MatchStatus.live),
      });

      txn.set(matchRef.collection('balls').doc(), {
        'runs': runs,
        'extraType': extraType,
        'wicket': wicket,
        'striker': striker,
        'nonStriker': nonStriker,
        'bowler': bowler,
        'createdAt': Timestamp.now(),
        'isLegal': isLegal,
      });
    });
  }

  Future<void> completeMatch(String matchId) async {
    await _firestore.collection('matches').doc(matchId).update({
      'status': _statusToString(MatchStatus.completed),
    });
  }
}
