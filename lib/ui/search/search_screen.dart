import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final history = ['River Riders', 'North Blazers', 'Winter Cup 2024'];
    final suggestions = ['Scores', 'Teams', 'Tournaments', 'Players'];
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search teams, matches, tournaments',
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset(
                    'assets/images/ic_search.svg',
                    colorFilter: ColorFilter.mode(
                      colors.textDisabled,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                filled: true,
                fillColor: colors.surface,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colors.outline),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colors.primary),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Recent searches',
              style: AppTextStyle.subtitle2.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: history
                  .map(
                    (item) => Chip(
                      label: Text(item),
                      backgroundColor: colors.containerLow,
                      shape: StadiumBorder(
                        side: BorderSide(color: colors.outline),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            Text(
              'Browse',
              style: AppTextStyle.subtitle2.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: 8),
            ...suggestions.map(
              (item) => ListTile(
                title: Text(
                  item,
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
