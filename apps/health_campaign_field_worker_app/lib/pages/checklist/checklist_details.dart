import 'package:digit_components/digit_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/checklist/checklist_bloc.dart';
import '../../utils/i18_key_constants.dart' as i18;
import '../../utils/utils.dart';
import '../../widgets/header/back_navigation_help_header.dart';
import '../../widgets/localized.dart';

class ChecklistDetailsPage extends LocalizedStatefulWidget {
  final ChecklistType checklistType;

  const ChecklistDetailsPage({
    super.key,
    super.appLocalizations,
    required this.checklistType,
  });

  @override
  State<ChecklistDetailsPage> createState() => _ChecklistDetailsPageState();
}

class _ChecklistDetailsPageState extends LocalizedState<ChecklistDetailsPage> {
  ChecklistBloc bloc = ChecklistBloc();

  @override
  void initState() {
    // bloc =  context.read<ChecklistBloc>();
    super.initState();
  }

  void callback(int index, Options? option, String? reason) {
    var selectedOption = option == Options.yes ? true : false;
    bloc.add(
      UpdateAnswer(index: index, option: selectedOption, reason: reason!),
    );

    print(
      '----- i am being called here -------- with index $index $option $reason',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    List<Widget> children = [];

    return Scaffold(
      body: BlocProvider(
        create: (context) => bloc..add(InitializeChecklist()),
        child: BlocBuilder<ChecklistBloc, ChecklistState>(
          builder: (context, state) {
            if (state is ChecklistLoadedState) {
              final survey = state.survey;
              int i = 0;
              children = [];
              for (final s in survey) {
                children.add(MCQTile(
                  question: s.question,
                  alert: s.alert,
                  index: i,
                  callback: callback,
                ));
                i += 1;
              }
            } else {
              children = [Container()];
            }

            return ScrollableContent(
              header: Column(children: const [
                BackNavigationHelpHeaderWidget(),
              ]),
              children: children,
            );
          },
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 90,
        child: DigitCard(
          child: DigitElevatedButton(
            onPressed: () => DigitDialog.show(
              context,
              options: DigitDialogOptions(
                titleText: localizations
                    .translate(i18.deliverIntervention.dialogTitle),
                contentText: localizations
                    .translate(i18.deliverIntervention.dialogContent),
                primaryAction: DigitDialogActions(
                  label: localizations.translate(i18.common.coreCommonSubmit),
                  action: (context) =>
                      Navigator.of(context, rootNavigator: true).pop(),
                ),
                secondaryAction: DigitDialogActions(
                  label: localizations.translate(i18.common.coreCommonCancel),
                  action: (context) =>
                      Navigator.of(context, rootNavigator: true).pop(),
                ),
              ),
            ),
            child: Center(
              child: Text(
                localizations.translate(i18.common.coreCommonSubmit),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
