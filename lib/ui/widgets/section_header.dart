import 'package:flutter/material.dart';
import 'package:style/animations/on_tap_scale.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;

  const SectionHeader({super.key, required this.title, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTextStyle.header3.copyWith(color: colors.textPrimary),
            ),
          ),
          if (onViewAll != null)
            OnTapScale(
              onTap: onViewAll,
              child: Text(
                'View all',
                style: AppTextStyle.button.copyWith(color: colors.primary),
              ),
            ),
        ],
      ),
    );
  }
}
