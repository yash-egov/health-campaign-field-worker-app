import 'package:digit_components/digit_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/checklist/checklist_bloc.dart';
import '../widgets/header/back_navigation_help_header.dart';
import '../widgets/localized.dart';
import 'checklist_details.dart';

class MyChecklistPage extends LocalizedStatefulWidget {
  const MyChecklistPage({
    super.key,
    super.appLocalizations,
  });

  @override
  State<MyChecklistPage> createState() => _MyChecklistPageState();
}

class _MyChecklistPageState extends LocalizedState<MyChecklistPage> {
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
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChecklistDetailsPage(),
                    ),
                  ),
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
