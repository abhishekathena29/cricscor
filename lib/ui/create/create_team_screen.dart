import 'package:characters/characters.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';

import 'provider/create_provider.dart';

class CreateTeamScreen extends StatefulWidget {
  const CreateTeamScreen({super.key});

  @override
  State<CreateTeamScreen> createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {
  final teamName = TextEditingController();
  final cityName = TextEditingController();
  final groundName = TextEditingController();
  final _playerController = TextEditingController();

  List<String> _players = [];
  String? _captain;
  String? _viceCaptain;

  @override
  void dispose() {
    teamName.dispose();
    cityName.dispose();
    groundName.dispose();
    _playerController.dispose();
    super.dispose();
  }

  void _addPlayer() {
    final playerName = _playerController.text.trim();
    if (playerName.isNotEmpty) {
      if (!_players.contains(playerName)) {
        setState(() {
          _players.add(playerName);
          _playerController.clear();
        });
      } else {
        _showSnack('$playerName is already in the team');
      }
    }
  }

  void _removePlayer(int index) {
    setState(() {
      final playerName = _players.removeAt(index);
      if (_captain == playerName) _captain = null;
      if (_viceCaptain == playerName) _viceCaptain = null;
    });
  }

  Future<void> _showPlayerSelectionDialog(String role) async {
    final colors = context.colorScheme;

    final selectedPlayer = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(
            'Select $role',
            style: AppTextStyle.subtitle1.copyWith(color: colors.textPrimary),
          ),
          children: [
            // Option to clear the role
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Clear Role');
              },
              child: Row(
                children: [
                  Icon(Icons.person_off),
                  const SizedBox(width: 8),
                  Text('Clear $role', style: AppTextStyle.body1.copyWith()),
                ],
              ),
            ),
            // Options for each player
            ..._players.map((player) {
              return SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, player);
                },
                child: Text(
                  player,
                  style: AppTextStyle.body1.copyWith(color: colors.textPrimary),
                ),
              );
            }),
          ],
        );
      },
    );

    if (selectedPlayer != null) {
      setState(() {
        if (selectedPlayer == 'Clear Role') {
          if (role == 'Captain') _captain = null;
          if (role == 'Vice-captain') _viceCaptain = null;
        } else {
          if (role == 'Captain') _captain = selectedPlayer;
          if (role == 'Vice-captain') _viceCaptain = selectedPlayer;
        }
      });
    }
  }

  void _handleRoleSelection(String role) {
    if (_players.isEmpty) {
      _showSnack('Please add players first to select $role.');
      return;
    }
    _showPlayerSelectionDialog(role);
  }

  Future<void> _saveTeam() async {
    final provider = context.read<CreateProvider>();
    if (teamName.text.trim().isEmpty) {
      _showSnack('Team name is required');
      return;
    }
    if (_players.isEmpty) {
      _showSnack('Add at least one player');
      return;
    }
    try {
      await provider.createTeam(
        name: teamName.text,
        city: cityName.text,
        ground: groundName.text,
        players: _players,
        captain: _captain,
        viceCaptain: _viceCaptain,
      );
      if (!mounted) return;
      _showSnack('Team saved');
      setState(() {
        _players = [];
        _captain = null;
        _viceCaptain = null;
      });
      teamName.clear();
      cityName.clear();
      groundName.clear();
      _playerController.clear();
    } catch (_) {
      if (!mounted) return;
      _showSnack(provider.error ?? 'Failed to save team');
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final createProvider = context.watch<CreateProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Create team')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // Use spacing property instead of manual SizedBox for Column/Row where available (not directly supported in standard Column, so we use manual spacing)
            children: [
              _sectionTitle(context, 'Team details'),
              const SizedBox(height: 16),
              _textField(
                teamName,
                context,
                label: 'Team name',
                hint: 'Garden XI',
              ),
              const SizedBox(height: 16),
              _textField(cityName, context, label: 'City', hint: 'Ahmedabad'),
              const SizedBox(height: 16),
              _textField(
                groundName,
                context,
                label: 'Ground',
                hint: 'Navrangpura',
              ),
              const SizedBox(height: 24),
              // New Player Input Section
              _sectionTitle(context, 'Add Player'),
              const SizedBox(height: 8),
              _playerInputWidget(context),
              const SizedBox(height: 24),

              // Dynamic Player List
              if (_players.isNotEmpty) ...[
                _sectionTitle(context, 'Players (${_players.length})'),
                const SizedBox(height: 8),
                _playerList(context),
                const SizedBox(height: 24),
              ],

              // Captain & Roles Section (Moved to the end and conditional)
              if (_players.isNotEmpty) ...[
                _sectionTitle(context, 'Captain & Roles'),
                const SizedBox(height: 8),
                _pill(
                  context,
                  'Captain',
                  _captain ?? 'Select Captain',
                  onTap: () => _handleRoleSelection('Captain'),
                ),
                _pill(
                  context,
                  'Vice-captain',
                  _viceCaptain ?? 'Select Vice-Captain',
                  onTap: () => _handleRoleSelection('Vice-captain'),
                ),
                const SizedBox(height: 16),
              ],

              _primaryButton(
                context,
                'Save team',
                loading: createProvider.savingTeam,
                onPressed: createProvider.savingTeam ? null : _saveTeam,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets (now methods on the State class) ---

  Widget _sectionTitle(BuildContext context, String text) => Text(
    text,
    style: AppTextStyle.subtitle2.copyWith(
      color: context.colorScheme.textPrimary,
    ),
  );

  Widget _textField(
    TextEditingController controller,
    BuildContext context, {
    required String label,
    String? hint,
  }) {
    final colors = context.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.body2.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
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
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  // New: Widget for adding players
  Widget _playerInputWidget(BuildContext context) {
    final colors = context.colorScheme;
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _playerController,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: 'Enter player name',
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
                vertical: 14,
              ),
            ),
            onSubmitted: (value) => _addPlayer(),
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: _addPlayer,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.primary,
            ),
            child: Icon(Icons.add, color: colors.onPrimary, size: 24),
          ),
        ),
      ],
    );
  }

  // Updated: Pill with onTap for selection
  Widget _pill(
    BuildContext context,
    String label,
    String value, {
    required VoidCallback onTap,
  }) {
    final colors = context.colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.outline),
          color: colors.containerLow,
        ),
        child: Row(
          children: [
            Text(
              label,
              style: AppTextStyle.body1.copyWith(color: colors.textPrimary),
            ),
            const Spacer(),
            Text(
              value,
              style: AppTextStyle.body2.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(width: 6),
            Icon(Icons.chevron_right, color: colors.textDisabled),
          ],
        ),
      ),
    );
  }

  // Updated: Player list uses state and allows removal
  Widget _playerList(BuildContext context) {
    final colors = context.colorScheme;
    return Column(
      children: List.generate(_players.length, (index) {
        final name = _players[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.outline),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: colors.primary.withOpacity(0.12),
                child: Text(
                  name.characters.first.toUpperCase(),
                  style: AppTextStyle.body1.copyWith(color: colors.primary),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  name,
                  style: AppTextStyle.body1.copyWith(color: colors.textPrimary),
                ),
              ),
              // Icon to remove player
              IconButton(
                icon: Icon(Icons.close, color: colors.textDisabled, size: 20),
                onPressed: () => _removePlayer(index),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _primaryButton(
    BuildContext context,
    String text, {
    required VoidCallback? onPressed,
    bool loading = false,
  }) {
    final colors = context.colorScheme;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: onPressed,
        child: loading
            ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(text),
      ),
    );
  }
}
