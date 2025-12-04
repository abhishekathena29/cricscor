import 'package:flutter/material.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final items = [
      ('Match updates', true),
      ('Score reminders', true),
      ('Tournament news', false),
      ('Followed players', true),
      ('Product announcements', false),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: SafeArea(
        child: ListView(
          children: items
              .map(
                (item) => SwitchListTile(
                  value: item.$2,
                  onChanged: (_) {},
                  title: Text(
                    item.$1,
                    style: AppTextStyle.body1.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    'Push & email',
                    style: AppTextStyle.caption.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
