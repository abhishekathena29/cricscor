import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';

import 'provider/create_provider.dart';

class CreateMatchScreen extends StatefulWidget {
  const CreateMatchScreen({super.key});

  @override
  State<CreateMatchScreen> createState() => _CreateMatchScreenState();
}

class _CreateMatchScreenState extends State<CreateMatchScreen> {
  final _titleController = TextEditingController();
  final _groundController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _ballType = 'Leather';
  String _overs = 'T20';
  bool _powerplay = true;
  bool _freeHit = true;
  bool _duckworth = false;

  TeamOption? _teamA;
  TeamOption? _teamB;
  bool _requestedTeams = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_requestedTeams) {
      _requestedTeams = true;
      context.read<CreateProvider>().loadTeams();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _groundController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
        _dateController.text = DateFormat('dd MMM, yyyy').format(date);
      });
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        _selectedTime = time;
        final dt = DateTime(0, 0, 0, time.hour, time.minute);
        _timeController.text = DateFormat('hh:mm a').format(dt);
      });
    }
  }

  TeamOption? _findTeam(String? id, List<TeamOption> teams) {
    if (id == null) return null;
    for (final team in teams) {
      if (team.id == id) return team;
    }
    return null;
  }

  Future<void> _saveMatch(CreateProvider provider) async {
    if (_titleController.text.trim().isEmpty) {
      _showSnack('Match title is required');
      return;
    }
    if (_groundController.text.trim().isEmpty) {
      _showSnack('Ground is required');
      return;
    }
    if (_selectedDate == null || _selectedTime == null) {
      _showSnack('Pick a date and time');
      return;
    }
    if (_teamA == null || _teamB == null) {
      _showSnack('Select both teams');
      return;
    }
    if (_teamA!.id == _teamB!.id) {
      _showSnack('Team A and Team B must be different');
      return;
    }

    final start = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    try {
      await provider.createMatch(
        title: _titleController.text,
        ground: _groundController.text,
        startTime: start,
        teamA: _teamA!,
        teamB: _teamB!,
        ballType: _ballType,
        overs: _overs,
        powerplay: _powerplay,
        freeHit: _freeHit,
        duckworthLewis: _duckworth,
      );
      if (!mounted) return;
      _showSnack('Match created');
      setState(() {
        _teamA = null;
        _teamB = null;
        _selectedDate = null;
        _selectedTime = null;
        _ballType = 'Leather';
        _overs = 'T20';
        _powerplay = true;
        _freeHit = true;
        _duckworth = false;
        _dateController.clear();
        _timeController.clear();
      });
      _titleController.clear();
      _groundController.clear();
    } catch (_) {
      if (!mounted) return;
      _showSnack(provider.error ?? 'Failed to create match');
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final createProvider = context.watch<CreateProvider>();
    final teams = createProvider.teams;
    final loadingTeams = createProvider.loadingTeams;

    return Scaffold(
      appBar: AppBar(title: const Text('Create match')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              _card(
                context,
                title: 'Match info',
                child: Column(
                  children: [
                    _textField(
                      context,
                      controller: _titleController,
                      label: 'Match title',
                      hint: 'Sunday smashers',
                    ),
                    _textField(
                      context,
                      controller: _groundController,
                      label: 'Ground',
                      hint: 'Sabarmati Riverfront',
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _textField(
                            context,
                            controller: _dateController,
                            label: 'Date',
                            hint: '12 Jan, 2024',
                            icon: 'assets/images/ic_calendar.svg',
                            readOnly: true,
                            onTap: _pickDate,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _textField(
                            context,
                            controller: _timeController,
                            label: 'Time',
                            hint: '4:00 PM',
                            icon: 'assets/images/ic_time.svg',
                            readOnly: true,
                            onTap: _pickTime,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _card(
                context,
                title: 'Teams',
                child: Column(
                  children: [
                    _teamPicker(
                      context,
                      label: 'Team A',
                      value: _teamA,
                      teams: teams,
                      loading: loadingTeams,
                      onChanged: (team) => setState(() => _teamA = team),
                    ),
                    _teamPicker(
                      context,
                      label: 'Team B',
                      value: _teamB,
                      teams: teams,
                      loading: loadingTeams,
                      onChanged: (team) => setState(() => _teamB = team),
                    ),
                    if (!loadingTeams && teams.isEmpty)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            'No teams found. Please create a team first.',
                            style: AppTextStyle.body2.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    if (loadingTeams)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: LinearProgressIndicator(minHeight: 3),
                      ),
                    _pillRow(
                      context,
                      'Ball type',
                      ['Leather', 'Tennis', 'Other'],
                      selected: _ballType,
                      onSelect: (value) => setState(() => _ballType = value),
                    ),
                  ],
                ),
              ),
              _card(
                context,
                title: 'Format',
                child: Column(
                  children: [
                    _pillRow(
                      context,
                      'Overs',
                      ['T10', 'T20', 'OD'],
                      selected: _overs,
                      onSelect: (value) => setState(() => _overs = value),
                    ),
                    const SizedBox(height: 8),
                    _switchRow(
                      context,
                      'Powerplay enabled',
                      value: _powerplay,
                      onChanged: (value) => setState(() => _powerplay = value),
                    ),
                    _switchRow(
                      context,
                      'Enable free hit after no ball',
                      value: _freeHit,
                      onChanged: (value) => setState(() => _freeHit = value),
                    ),
                    _switchRow(
                      context,
                      'Use D/L method for rain',
                      value: _duckworth,
                      onChanged: (value) => setState(() => _duckworth = value),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              _primaryButton(
                context,
                'Create match',
                loading: createProvider.savingMatch,
                onPressed: createProvider.savingMatch
                    ? null
                    : () => _saveMatch(createProvider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    final colors = context.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outline),
        color: colors.containerLow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Text(
            title,
            style: AppTextStyle.subtitle2.copyWith(color: colors.textPrimary),
          ),
          child,
        ],
      ),
    );
  }

  Widget _textField(
    BuildContext context, {
    required String label,
    TextEditingController? controller,
    String? hint,
    String? icon,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    final colors = context.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6,
        children: [
          Text(
            label,
            style: AppTextStyle.body2.copyWith(color: colors.textSecondary),
          ),
          TextField(
            controller: controller,
            readOnly: readOnly || onTap != null,
            onTap: onTap,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: icon == null
                  ? null
                  : Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset(
                        icon,
                        colorFilter: ColorFilter.mode(
                          colors.textDisabled,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
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
      ),
    );
  }

  Widget _teamPicker(
    BuildContext context, {
    required String label,
    required TeamOption? value,
    required List<TeamOption> teams,
    required ValueChanged<TeamOption?> onChanged,
    required bool loading,
  }) {
    final colors = context.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6,
        children: [
          Text(
            label,
            style: AppTextStyle.body2.copyWith(color: colors.textSecondary),
          ),
          DropdownButtonFormField<String>(
            value: value?.id,
            isExpanded: true,
            items: teams
                .map(
                  (team) => DropdownMenuItem(
                    value: team.id,
                    child: Text(
                      team.name,
                      style: AppTextStyle.body1.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: loading
                ? null
                : (id) => onChanged(_findTeam(id, teams)),
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
                vertical: 4,
              ),
            ),
            hint: Text(
              'Select team',
              style: AppTextStyle.body1.copyWith(color: colors.textSecondary),
            ),
            icon: Icon(Icons.expand_more, color: colors.textDisabled),
          ),
        ],
      ),
    );
  }

  Widget _pillRow(
    BuildContext context,
    String label,
    List<String> pills, {
    required String selected,
    required ValueChanged<String> onSelect,
  }) {
    final colors = context.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          label,
          style: AppTextStyle.body2.copyWith(color: colors.textSecondary),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final pill in pills)
              InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () => onSelect(pill),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color:
                        pill == selected ? colors.primary : colors.containerLow,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color:
                          pill == selected ? colors.primary : colors.outline,
                    ),
                  ),
                  child: Text(
                    pill,
                    style: AppTextStyle.body2.copyWith(
                      color: pill == selected
                          ? colors.onPrimary
                          : colors.textSecondary,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _switchRow(
    BuildContext context,
    String label, {
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final colors = context.colorScheme;
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      value: value,
      onChanged: onChanged,
      title: Text(
        label,
        style: AppTextStyle.body1.copyWith(color: colors.textPrimary),
      ),
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
