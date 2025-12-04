import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';

import 'provider/profile_provider.dart';

class EditProfileScreen extends StatefulWidget {
  final UserProfile profile;

  const EditProfileScreen({super.key, required this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _name;
  late TextEditingController _city;
  late TextEditingController _role;
  late TextEditingController _battingStyle;
  late TextEditingController _bowlingStyle;
  late TextEditingController _experience;
  late TextEditingController _bio;
  bool _availableForHire = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.profile.username);
    _city = TextEditingController(text: widget.profile.city ?? '');
    _role = TextEditingController(text: widget.profile.role ?? '');
    _battingStyle = TextEditingController(text: widget.profile.battingStyle ?? '');
    _bowlingStyle = TextEditingController(text: widget.profile.bowlingStyle ?? '');
    _experience = TextEditingController(text: widget.profile.experience ?? '');
    _bio = TextEditingController(text: widget.profile.bio ?? '');
    _availableForHire = widget.profile.availableForHire ?? false;
  }

  @override
  void dispose() {
    _name.dispose();
    _city.dispose();
    _role.dispose();
    _battingStyle.dispose();
    _bowlingStyle.dispose();
    _experience.dispose();
    _bio.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final provider = context.read<ProfileProvider>();
    final updates = <String, dynamic>{
      'username': _name.text.trim(),
      'city': _city.text.trim(),
      'role': _role.text.trim(),
      'bio': _bio.text.trim(),
      'availableForHire': _availableForHire,
    };
    if (widget.profile.userType == 'player') {
      updates['battingStyle'] = _battingStyle.text.trim();
      updates['bowlingStyle'] = _bowlingStyle.text.trim();
    } else {
      updates['experience'] = _experience.text.trim();
    }
    try {
      await provider.updateProfile(updates);
      if (!mounted) return;
      Navigator.pop(context);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(provider.error ?? 'Failed to update')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final provider = context.watch<ProfileProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Edit profile')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              _textField(context, controller: _name, label: 'Name', hint: 'Your name'),
              _textField(context, controller: _city, label: 'City', hint: 'Home city'),
              _textField(
                context,
                controller: _role,
                label: widget.profile.userType == 'player' ? 'Playing role' : 'Role',
                hint: widget.profile.userType == 'player'
                    ? 'Opener / All-rounder'
                    : 'Official scorer',
              ),
              if (widget.profile.userType == 'player') ...[
                _textField(
                  context,
                  controller: _battingStyle,
                  label: 'Batting style',
                  hint: 'Right-hand bat',
                ),
                _textField(
                  context,
                  controller: _bowlingStyle,
                  label: 'Bowling style',
                  hint: 'Right arm off spin',
                ),
              ] else ...[
                _textField(
                  context,
                  controller: _experience,
                  label: 'Experience',
                  hint: 'E.g. 3 years in club cricket',
                ),
                SwitchListTile(
                  value: _availableForHire,
                  onChanged: (val) => setState(() => _availableForHire = val),
                  title: Text(
                    'Available for hire',
                    style: AppTextStyle.body1.copyWith(color: colors.textPrimary),
                  ),
                ),
              ],
              _textField(
                context,
                controller: _bio,
                label: 'Bio',
                hint: 'Short intro',
                maxLines: 3,
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: provider.saving ? null : _save,
                  child: provider.saving
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    final colors = context.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 6,
      children: [
        Text(label, style: AppTextStyle.body2.copyWith(color: colors.textSecondary)),
        TextField(
          controller: controller,
          maxLines: maxLines,
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }
}
