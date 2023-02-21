import 'package:digit_components/digit_components.dart';
import 'package:flutter/material.dart';

import '../widgets/header/back_navigation_help_header.dart';
import '../widgets/localized.dart';

enum MyChecklistPage { received, issued, returned, damaged, lost }

class ManageStocksPage extends LocalizedStatefulWidget {
  const ManageStocksPage({
    super.key,
    super.appLocalizations,
  });

  @override
  State<ManageStocksPage> createState() => _ManageStocksPageState();
}

class _ManageStocksPageState extends LocalizedState<ManageStocksPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: ScrollableContent(
        header: Column(children: const [
          BackNavigationHelpHeaderWidget(),
        ]),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    localizations.translate('My Checklists'),
                    style: theme.textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Column(children: [
                DigitListView(
                  title: 'Field team formation',
                  description:
                      'Use this checklist to supervise the team formation for Registration & Distribution',
                  prefixIcon: Icons.article,
                  sufixIcon: Icons.arrow_circle_right,
                  onPressed: () {},
                ),
                DigitListView(
                  title: 'Warehouses',
                  description:
                      'Use this checklist to supervise district warehouses',
                  prefixIcon: Icons.store,
                  sufixIcon: Icons.arrow_circle_right,
                  onPressed: () {},
                ),
                DigitListView(
                  title: 'Registration & Distribution',
                  description:
                      'Use this checklist to supervise registration & distribution activities',
                  prefixIcon: Icons.login,
                  sufixIcon: Icons.arrow_circle_right,
                  onPressed: () {},
                ),
              ]),
              const SizedBox(height: 16),
            ],
          ),
        ],
      ),
    );
  }
}
