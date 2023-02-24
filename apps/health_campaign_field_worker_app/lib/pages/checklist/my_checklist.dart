import 'package:digit_components/digit_components.dart';
import 'package:flutter/material.dart';

import '../../utils/i18_key_constants.dart' as i18;
import '../../widgets/action_card/action_card.dart';
import '../../widgets/header/back_navigation_help_header.dart';
import '../../widgets/localized.dart';
import 'checklist_details.dart';
import 'checklist_input.dart';
import '../../utils/utils.dart';

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
                  onPressed: () => onPressed(ChecklistType.fieldTeamFormation),
                ),
                DigitListView(
                  title: 'Warehouses',
                  description:
                      'Use this checklist to supervise district warehouses',
                  prefixIcon: Icons.store,
                  sufixIcon: Icons.arrow_circle_right,
                  onPressed: () => onPressed(ChecklistType.warehouseInspection),
                ),
                DigitListView(
                  title: 'Registration & Distribution',
                  description:
                      'Use this checklist to supervise registration & distribution activities',
                  prefixIcon: Icons.login,
                  sufixIcon: Icons.arrow_circle_right,
                  onPressed: () =>
                      onPressed(ChecklistType.registrationAndDistribution),
                ),
              ]),
              const SizedBox(height: 16),
            ],
          ),
        ],
      ),
    );
  }

  void onPressed(ChecklistType checklistType) {
    DigitActionDialog.show(
      context,
      widget: ActionCard(
        items: [
          ActionCardModel(
            icon: Icons.edit,
            label: localizations.translate(
              i18.householdOverView.householdOverViewEditLabel,
            ),
            action: () {
              Navigator.of(context, rootNavigator: true).pop('dialog');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChecklistInputPage(
                    checklistType: checklistType,
                  ),
                ),
              );
            },
          ),
          ActionCardModel(
            icon: Icons.delete,
            label: localizations
                .translate(i18.householdOverView.householdOverViewDeleteLabel),
            action: () => DigitDialog.show(
              context,
              options: DigitDialogOptions(
                titleText: localizations.translate(
                  i18.householdOverView.householdOverViewActionCardTitle,
                ),
                primaryAction: DigitDialogActions(
                  label: localizations.translate(i18
                      .householdOverView.householdOverViewPrimaryActionLabel),
                  action: (context) {
                    Navigator.of(context, rootNavigator: true).pop();
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
                secondaryAction: DigitDialogActions(
                  label: localizations.translate(i18
                      .householdOverView.householdOverViewSecondaryActionLabel),
                  action: (context) {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
