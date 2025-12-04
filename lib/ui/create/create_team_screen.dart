import 'package:characters/characters.dart';
import 'package:flutter/material.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';

class CreateTeamScreen extends StatelessWidget {
  const CreateTeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Create team')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              _sectionTitle(context, 'Team details'),
              _textField(context, label: 'Team name', hint: 'Garden XI'),
              _textField(context, label: 'City', hint: 'Ahmedabad'),
              _textField(context, label: 'Ground', hint: 'Navrangpura'),
              _sectionTitle(context, 'Captain & roles'),
              _pill(context, 'Captain', 'Ravi Patel'),
              _pill(context, 'Vice-captain', 'Harsh Desai'),
              _pill(context, 'Scorer', 'Invite scorer'),
              const SizedBox(height: 8),
              _sectionTitle(context, 'Players'),
              _playerList(context),
              const SizedBox(height: 12),
              _primaryButton(context, 'Save team'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String text) => Text(
    text,
    style: AppTextStyle.subtitle2.copyWith(
      color: context.colorScheme.textPrimary,
    ),
  );

  Widget _textField(
    BuildContext context, {
    required String label,
    String? hint,
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

  Widget _pill(BuildContext context, String label, String value) {
    final colors = context.colorScheme;
    return Container(
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
    );
  }

  Widget _playerList(BuildContext context) {
    final colors = context.colorScheme;
    final players = [
      'Ravi Patel',
      'Harsh Desai',
      'Sidharth Sheth',
      'Pranav Modi',
      'Moin Shaikh',
      'Rahul Sharma',
    ];
    return Column(
      children: players
          .map(
            (name) => Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                      style: AppTextStyle.body1.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  Icon(Icons.drag_handle_rounded, color: colors.textDisabled),
                ],
              ),
            ),
          )
          .toList(),
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
