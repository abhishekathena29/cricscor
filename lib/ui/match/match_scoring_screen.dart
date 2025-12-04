import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';

import '../create/provider/create_provider.dart';

class MatchScoringScreen extends StatefulWidget {
  final String matchId;
  final String title;

  const MatchScoringScreen({
    super.key,
    required this.matchId,
    required this.title,
  });

  @override
  State<MatchScoringScreen> createState() => _MatchScoringScreenState();
}

class _MatchScoringScreenState extends State<MatchScoringScreen> {
  String? _striker;
  String? _nonStriker;
  String? _bowler;
  String? _teamAId;
  String? _teamBId;
  List<String> _teamAPlayers = [];
  List<String> _teamBPlayers = [];
  bool _loadingPlayers = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CreateProvider>();
    return StreamBuilder<MatchItem?>(
      stream: provider.watchMatch(widget.matchId),
      builder: (context, snapshot) {
        final match = snapshot.data;
        if (match == null) {
          return Scaffold(
            appBar: AppBar(title: Text(widget.title)),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _maybeLoadPlayers(match);
        });
        final colors = context.colorScheme;
        final currentStriker =
            _striker ?? (_teamAPlayers.isNotEmpty ? _teamAPlayers.first : null);
        final currentNonStriker =
            _nonStriker ?? (_teamAPlayers.length > 1 ? _teamAPlayers[1] : null);
        final currentBowler =
            _bowler ?? (_teamBPlayers.isNotEmpty ? _teamBPlayers.first : null);

        return Scaffold(
          appBar: AppBar(
            title: Text('${match.teamA.name} vs ${match.teamB.name}'),
            actions: [
              IconButton(
                onPressed: () => provider.completeMatch(match.id),
                icon: const Icon(Icons.check_circle_outline),
                tooltip: 'Mark completed',
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
                  _scoreHeader(context, match),
                  _infoRow(context, match),
                  _playerSelectors(
                    context,
                    match,
                    currentStriker,
                    currentNonStriker,
                    currentBowler,
                  ),
                  if (_loadingPlayers)
                    const LinearProgressIndicator(minHeight: 2),
                  _quickActions(
                    context,
                    match,
                    currentStriker,
                    currentNonStriker,
                    currentBowler,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _maybeLoadPlayers(MatchItem match) async {
    if (_loadingPlayers) return;
    if (match.teamA.id == _teamAId && match.teamB.id == _teamBId) return;
    if (mounted) {
      setState(() {
        _loadingPlayers = true;
      });
    }
    try {
      final provider = context.read<CreateProvider>();
      final teamAPlayers = await provider.fetchTeamPlayers(match.teamA.id);
      final teamBPlayers = await provider.fetchTeamPlayers(match.teamB.id);
      if (!mounted) return;
      setState(() {
        _teamAId = match.teamA.id;
        _teamBId = match.teamB.id;
        _teamAPlayers = teamAPlayers;
        _teamBPlayers = teamBPlayers;
        _striker = teamAPlayers.isNotEmpty ? teamAPlayers.first : null;
        _nonStriker = teamAPlayers.length > 1 ? teamAPlayers[1] : _striker;
        _bowler = teamBPlayers.isNotEmpty ? teamBPlayers.first : null;
      });
    } finally {
      if (mounted) {
        setState(() {
          _loadingPlayers = false;
        });
      }
    }
  }

  Widget _scoreHeader(BuildContext context, MatchItem match) {
    final colors = context.colorScheme;
    final overs = '${match.balls ~/ 6}.${match.balls % 6} ov';
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
                match.teamA.name,
                style: AppTextStyle.subtitle2.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              Text(
                '${match.runs}/${match.wickets}',
                style: AppTextStyle.header2.copyWith(color: colors.textPrimary),
              ),
              Text(
                overs,
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
                  match.status == MatchStatus.completed
                      ? 'Completed'
                      : DateFormat('hh:mm a').format(match.startTime),
                  style: AppTextStyle.subtitle3.copyWith(color: colors.primary),
                ),
                Text(
                  match.ballType,
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

  Widget _infoRow(BuildContext context, MatchItem match) {
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
          _chip(context, match.ballType),
          _chip(context, '${match.overs} • ${match.status.name}'),
          _chip(context, match.ground),
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

  Widget _playerSelectors(
    BuildContext context,
    MatchItem match,
    String? striker,
    String? nonStriker,
    String? bowler,
  ) {
    final colors = context.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        Text(
          'Players',
          style: AppTextStyle.subtitle2.copyWith(color: colors.textPrimary),
        ),
        Row(
          children: [
            Expanded(
              child: _dropdown(
                context,
                label: 'Striker',
                value: striker,
                options: _teamAPlayers,
                onChanged: (value) => setState(() => _striker = value),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _dropdown(
                context,
                label: 'Non-striker',
                value: nonStriker,
                options: _teamAPlayers,
                onChanged: (value) => setState(() => _nonStriker = value),
              ),
            ),
          ],
        ),
        _dropdown(
          context,
          label: 'Bowler',
          value: bowler,
          options: _teamBPlayers,
          onChanged: (value) => setState(() => _bowler = value),
        ),
      ],
    );
  }

  Widget _dropdown(
    BuildContext context, {
    required String label,
    required String? value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    final colors = context.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 6,
      children: [
        Text(
          label,
          style: AppTextStyle.body2.copyWith(color: colors.textSecondary),
        ),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          items: options
              .map(
                (player) => DropdownMenuItem(
                  value: player,
                  child: Text(
                    player,
                    style: AppTextStyle.body1.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: colors.surface,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colors.outline),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colors.primary),
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
          ),
        ),
      ],
    );
  }

  Widget _quickActions(
    BuildContext context,
    MatchItem match,
    String? striker,
    String? nonStriker,
    String? bowler,
  ) {
    final colors = context.colorScheme;
    final buttons = [0, 1, 2, 3, 4, 6];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        Text(
          'Ball update',
          style: AppTextStyle.subtitle2.copyWith(color: colors.textPrimary),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: buttons
              .map(
                (run) => _pillButton(
                  context,
                  label: '$run',
                  onTap: () => _addBall(
                    match,
                    striker,
                    nonStriker,
                    bowler,
                    run,
                    null,
                    false,
                  ),
                ),
              )
              .toList(),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _pillButton(
              context,
              label: 'Wide +1',
              onTap: () => _addBall(
                match,
                striker,
                nonStriker,
                bowler,
                1,
                'wide',
                false,
              ),
            ),
            _pillButton(
              context,
              label: 'No ball +1',
              onTap: () => _addBall(
                match,
                striker,
                nonStriker,
                bowler,
                1,
                'noBall',
                false,
              ),
            ),
            _pillButton(
              context,
              label: 'Wicket',
              onTap: () =>
                  _addBall(match, striker, nonStriker, bowler, 0, null, true),
            ),
          ],
        ),
      ],
    );
  }

  Widget _pillButton(
    BuildContext context, {
    required String label,
    required VoidCallback onTap,
  }) {
    final colors = context.colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: colors.containerLow,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: colors.outline),
        ),
        child: Text(
          label,
          style: AppTextStyle.body1.copyWith(color: colors.textPrimary),
        ),
      ),
    );
  }

  Future<void> _addBall(
    MatchItem match,
    String? striker,
    String? nonStriker,
    String? bowler,
    int runs,
    String? extraType,
    bool wicket,
  ) async {
    if (striker == null || nonStriker == null || bowler == null) {
      _showSnack('Select striker, non-striker and bowler first');
      return;
    }
    try {
      final provider = context.read<CreateProvider>();
      await provider.addBallEvent(
        match: match,
        striker: striker,
        nonStriker: nonStriker,
        bowler: bowler,
        runs: runs,
        extraType: extraType,
        wicket: wicket,
      );
      if (!mounted) return;
      if (extraType == null && runs.isOdd) {
        setState(() {
          final temp = _striker;
          _striker = _nonStriker;
          _nonStriker = temp;
        });
      }
      _showSnack('Ball saved');
    } catch (e) {
      if (!mounted) return;
      _showSnack('Failed to save ball');
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
