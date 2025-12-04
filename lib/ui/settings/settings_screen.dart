import 'package:flutter/material.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final toggles = [
      ('Dark mode', false),
      ('Auto-save scores', true),
      ('Show advanced stats', true),
    ];
    final items = [
      ('About Khelo', Icons.info_outline),
      ('Privacy policy', Icons.privacy_tip_outlined),
      ('Terms of service', Icons.article_outlined),
      ('Contact support', Icons.support_agent_outlined),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: ListView(
          children: [
            ...toggles.map(
              (toggle) => SwitchListTile(
                value: toggle.$2,
                onChanged: (_) {},
                title: Text(
                  toggle.$1,
                  style: AppTextStyle.body1.copyWith(color: colors.textPrimary),
                ),
              ),
            ),
            const Divider(),
            ...items.map(
              (item) => ListTile(
                leading: Icon(item.$2, color: colors.textPrimary),
                title: Text(
                  item.$1,
                  style: AppTextStyle.body1.copyWith(color: colors.textPrimary),
                ),
                trailing: Icon(Icons.chevron_right, color: colors.textDisabled),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
