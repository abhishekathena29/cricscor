import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';

import 'provider/create_provider.dart';

class CreateTournamentScreen extends StatefulWidget {
  const CreateTournamentScreen({super.key});

  @override
  State<CreateTournamentScreen> createState() => _CreateTournamentScreenState();
}

class _CreateTournamentScreenState extends State<CreateTournamentScreen> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _teamsController = TextEditingController(text: '12');
  final _oversController = TextEditingController(text: '20');
  final _organizerController = TextEditingController();
  final _umpireController = TextEditingController();
  final _scorerController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  String _format = 'League';
  String _ballType = 'Leather';
  bool _superOver = true;
  bool _thirdUmpire = true;

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _teamsController.dispose();
    _oversController.dispose();
    _organizerController.dispose();
    _umpireController.dispose();
    _scorerController.dispose();
    super.dispose();
  }

  Future<void> _pickStartDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate ?? now,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        _startDate = date;
        _startDateController.text = DateFormat('dd MMM yyyy').format(date);
        if (_endDate != null && _endDate!.isBefore(date)) {
          _endDate = date;
          _endDateController.text = DateFormat('dd MMM yyyy').format(date);
        }
      });
    }
  }

  Future<void> _pickEndDate() async {
    final now = DateTime.now();
    final firstDate = _startDate ?? now;
    final date = await showDatePicker(
      context: context,
      initialDate: _endDate ?? firstDate,
      firstDate: firstDate,
      lastDate: firstDate.add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        _endDate = date;
        _endDateController.text = DateFormat('dd MMM yyyy').format(date);
      });
    }
  }

  Future<void> _saveTournament(CreateProvider provider) async {
    if (_nameController.text.trim().isEmpty) {
      _showSnack('Tournament name is required');
      return;
    }
    if (_locationController.text.trim().isEmpty) {
      _showSnack('Location is required');
      return;
    }
    if (_startDate == null || _endDate == null) {
      _showSnack('Select start and end dates');
      return;
    }
    if (_endDate!.isBefore(_startDate!)) {
      _showSnack('End date cannot be before start date');
      return;
    }
    final teamsCount = int.tryParse(_teamsController.text.trim());
    final overs = int.tryParse(_oversController.text.trim());
    if (teamsCount == null || teamsCount <= 0) {
      _showSnack('Enter a valid number of teams');
      return;
    }
    if (overs == null || overs <= 0) {
      _showSnack('Enter overs for each innings');
      return;
    }

    try {
      await provider.createTournament(
        name: _nameController.text,
        location: _locationController.text,
        startDate: _startDate!,
        endDate: _endDate!,
        format: _format,
        ballType: _ballType,
        teamsCount: teamsCount,
        overs: overs,
        superOver: _superOver,
        thirdUmpire: _thirdUmpire,
        organizer: _organizerController.text,
        umpire: _umpireController.text,
        scorer: _scorerController.text,
      );
      if (!mounted) return;
      _showSnack('Tournament published');
      setState(() {
        _startDate = null;
        _endDate = null;
        _format = 'League';
        _ballType = 'Leather';
        _superOver = true;
        _thirdUmpire = true;
      });
      _nameController.clear();
      _locationController.clear();
      _startDateController.clear();
      _endDateController.clear();
      _teamsController.text = '12';
      _oversController.text = '20';
      _organizerController.clear();
      _umpireController.clear();
      _scorerController.clear();
    } catch (_) {
      if (!mounted) return;
      _showSnack(provider.error ?? 'Failed to publish tournament');
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final createProvider = context.watch<CreateProvider>();
    final colors = context.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Create tournament')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              _card(
                context,
                'Tournament basics',
                Column(
                  children: [
                    _textField(
                      context,
                      controller: _nameController,
                      label: 'Name',
                      hint: 'Gully Premier League',
                    ),
                    _textField(
                      context,
                      controller: _locationController,
                      label: 'Location',
                      hint: 'Ahmedabad, India',
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _textField(
                            context,
                            controller: _startDateController,
                            label: 'Start date',
                            hint: '20 Jan 2024',
                            icon: 'assets/images/ic_calendar.svg',
                            readOnly: true,
                            onTap: _pickStartDate,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _textField(
                            context,
                            controller: _endDateController,
                            label: 'End date',
                            hint: '02 Feb 2024',
                            icon: 'assets/images/ic_calendar.svg',
                            readOnly: true,
                            onTap: _pickEndDate,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _card(
                context,
                'Structure',
                Column(
                  children: [
                    _pillRow(
                      context,
                      'Format',
                      ['Knockout', 'League', 'Groups'],
                      _format,
                      onSelect: (value) => setState(() => _format = value),
                    ),
                    _pillRow(
                      context,
                      'Ball type',
                      ['Leather', 'Tennis'],
                      _ballType,
                      onSelect: (value) => setState(() => _ballType = value),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _textField(
                            context,
                            controller: _teamsController,
                            label: 'Teams',
                            hint: '12',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _textField(
                            context,
                            controller: _oversController,
                            label: 'Overs',
                            hint: '20',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    _switchRow(
                      context,
                      'Allow super over in knockout',
                      value: _superOver,
                      onChanged: (value) => setState(() => _superOver = value),
                    ),
                    _switchRow(
                      context,
                      'Enable third umpire review',
                      value: _thirdUmpire,
                      onChanged: (value) => setState(() => _thirdUmpire = value),
                    ),
                  ],
                ),
              ),
              _card(
                context,
                'Officials & scorers',
                Column(
                  spacing: 12,
                  children: [
                    _pickerField(
                      context,
                      controller: _organizerController,
                      label: 'Organizer',
                      hint: 'Sidharth Sheth',
                    ),
                    _pickerField(
                      context,
                      controller: _umpireController,
                      label: 'Umpire',
                      hint: 'Assign later',
                    ),
                    _pickerField(
                      context,
                      controller: _scorerController,
                      label: 'Scorer',
                      hint: 'Invite scorer',
                    ),
                  ],
                ),
              ),
              _primaryButton(
                context,
                'Publish tournament',
                loading: createProvider.savingTournament,
                onPressed: createProvider.savingTournament
                    ? null
                    : () => _saveTournament(createProvider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card(BuildContext context, String title, Widget child) {
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
    required TextEditingController controller,
    required String label,
    required String hint,
    String? icon,
    bool readOnly = false,
    TextInputType? keyboardType,
    VoidCallback? onTap,
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
        TextField(
          controller: controller,
          readOnly: readOnly || onTap != null,
          onTap: onTap,
          keyboardType: keyboardType,
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
    );
  }

  Widget _pillRow(
    BuildContext context,
    String label,
    List<String> pills,
    String selected, {
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
          children: List.generate(
            pills.length,
            (index) => InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () => onSelect(pills[index]),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: pills[index] == selected
                      ? colors.primary
                      : colors.containerLow,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: pills[index] == selected
                        ? colors.primary
                        : colors.outline,
                  ),
                ),
                child: Text(
                  pills[index],
                  style: AppTextStyle.body2.copyWith(
                    color: pills[index] == selected
                        ? colors.onPrimary
                        : colors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
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

  Widget _pickerField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required String hint,
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
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: Icon(Icons.chevron_right, color: colors.textDisabled),
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
