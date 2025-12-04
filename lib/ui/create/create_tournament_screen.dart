import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';

class CreateTournamentScreen extends StatelessWidget {
  const CreateTournamentScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    _textField(context, 'Name', 'Gully Premier League'),
                    _textField(context, 'Location', 'Ahmedabad, India'),
                    Row(
                      children: [
                        Expanded(
                          child: _textField(
                            context,
                            'Start date',
                            '20 Jan 2024',
                            icon: 'assets/images/ic_calendar.svg',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _textField(
                            context,
                            'End date',
                            '02 Feb 2024',
                            icon: 'assets/images/ic_calendar.svg',
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
                    _pillRow(context, 'Format', [
                      'Knockout',
                      'League',
                      'Groups',
                    ], 1),
                    _pillRow(context, 'Ball type', ['Leather', 'Tennis'], 0),
                    Row(
                      children: [
                        Expanded(child: _textField(context, 'Teams', '12')),
                        const SizedBox(width: 12),
                        Expanded(child: _textField(context, 'Overs', '20')),
                      ],
                    ),
                    _switchRow(context, 'Allow super over in knockout'),
                    _switchRow(context, 'Enable third umpire review'),
                  ],
                ),
              ),
              _card(
                context,
                'Officials & scorers',
                Column(
                  spacing: 12,
                  children: [
                    _picker(context, 'Organizer', 'Sidharth Sheth'),
                    _picker(context, 'Umpire', 'Assign later'),
                    _picker(context, 'Scorer', 'Invite scorer'),
                  ],
                ),
              ),
              _primaryButton(context, 'Publish tournament'),
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
    BuildContext context,
    String label,
    String hint, {
    String? icon,
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
    int selected,
  ) {
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
            (index) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: index == selected ? colors.primary : colors.containerLow,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: index == selected ? colors.primary : colors.outline,
                ),
              ),
              child: Text(
                pills[index],
                style: AppTextStyle.body2.copyWith(
                  color: index == selected
                      ? colors.onPrimary
                      : colors.textSecondary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _switchRow(BuildContext context, String label) {
    final colors = context.colorScheme;
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      value: true,
      onChanged: (_) {},
      title: Text(
        label,
        style: AppTextStyle.body1.copyWith(color: colors.textPrimary),
      ),
    );
  }

  Widget _picker(BuildContext context, String label, String value) {
    final colors = context.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 6,
      children: [
        Text(
          label,
          style: AppTextStyle.body2.copyWith(color: colors.textSecondary),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.outline),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: AppTextStyle.body1.copyWith(color: colors.textPrimary),
                ),
              ),
              Icon(Icons.chevron_right, color: colors.textDisabled),
            ],
          ),
        ),
      ],
    );
  }

  Widget _primaryButton(BuildContext context, String text) {
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
        onPressed: () {},
        child: Text(text),
      ),
    );
  }
}
