import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';

class CreateMatchScreen extends StatelessWidget {
  const CreateMatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
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
                      label: 'Match title',
                      hint: 'Sunday smashers',
                    ),
                    _textField(
                      context,
                      label: 'Ground',
                      hint: 'Sabarmati Riverfront',
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _textField(
                            context,
                            label: 'Date',
                            hint: '12 Jan, 2024',
                            icon: 'assets/images/ic_calendar.svg',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _textField(
                            context,
                            label: 'Time',
                            hint: '4:00 PM',
                            icon: 'assets/images/ic_time.svg',
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
                    _picker(context, label: 'Team A', value: 'North Blazers'),
                    _picker(context, label: 'Team B', value: 'Downtown Kings'),
                    _pillRow(context, 'Ball type', [
                      'Leather',
                      'Tennis',
                      'Other',
                    ], selected: 0),
                  ],
                ),
              ),
              _card(
                context,
                title: 'Format',
                child: Column(
                  children: [
                    _pillRow(context, 'Overs', [
                      'T10',
                      'T20',
                      'OD',
                    ], selected: 1),
                    const SizedBox(height: 8),
                    _switchRow(context, 'Powerplay enabled'),
                    _switchRow(context, 'Enable free hit after no ball'),
                    _switchRow(context, 'Use D/L method for rain'),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              _primaryButton(context, 'Create match'),
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
    String? hint,
    String? icon,
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

  Widget _picker(
    BuildContext context, {
    required String label,
    required String value,
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.outline),
              color: colors.surface,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: AppTextStyle.body1.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: colors.textDisabled),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pillRow(
    BuildContext context,
    String label,
    List<String> pills, {
    required int selected,
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
            for (int i = 0; i < pills.length; i++)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: i == selected ? colors.primary : colors.containerLow,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: i == selected ? colors.primary : colors.outline,
                  ),
                ),
                child: Text(
                  pills[i],
                  style: AppTextStyle.body2.copyWith(
                    color: i == selected
                        ? colors.onPrimary
                        : colors.textSecondary,
                  ),
                ),
              ),
          ],
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
