import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';

import '../sample_data.dart';

class StatTile extends StatelessWidget {
  final StatTileData stat;

  const StatTile({super.key, required this.stat});

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.containerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                stat.iconPath,
                width: 22,
                height: 22,
                colorFilter: ColorFilter.mode(colors.primary, BlendMode.srcIn),
              ),
              Icon(Icons.more_horiz, color: colors.textDisabled),
            ],
          ),
          Text(
            stat.value,
            style: AppTextStyle.header3.copyWith(color: colors.textPrimary),
          ),
          Text(
            stat.label,
            style: AppTextStyle.body2.copyWith(color: colors.textSecondary),
          ),
          Text(
            stat.helper,
            style: AppTextStyle.caption.copyWith(color: colors.textDisabled),
          ),
        ],
      ),
    );
  }
}
