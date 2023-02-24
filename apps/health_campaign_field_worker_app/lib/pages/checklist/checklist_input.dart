import 'package:digit_components/digit_components.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../utils/i18_key_constants.dart' as i18;
import '../../widgets/header/back_navigation_help_header.dart';
import '../../widgets/localized.dart';
import 'checklist_details.dart';
import '../../utils/utils.dart';

class ChecklistInputPage extends LocalizedStatefulWidget {
  final ChecklistType checklistType;


  const ChecklistInputPage({
    required this.checklistType,
    super.key,
    super.appLocalizations,
  });

  @override
  State<ChecklistInputPage> createState() => _WarehouseDetailsPageState();
}

class _WarehouseDetailsPageState extends LocalizedState<ChecklistInputPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: ReactiveFormBuilder(
        form: buildForm,
        builder: (context, form, child) {
          return ScrollableContent(
            header: Column(children: const [
              BackNavigationHelpHeaderWidget(),
            ]),
            footer: SizedBox(
              height: 90,
              child: DigitCard(
                child: DigitElevatedButton(
                  onPressed: () {
                    if (form.valid) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChecklistDetailsPage(
                                checklistType: widget.checklistType,),
                        ),
                      );
                    } else {
                    form.markAllAsTouched();
                    }
                  },
                  child: Center(
                    child: Text(localizations
                        .translate(i18.householdDetails.actionLabel)),
                  ),
                ),
              ),
            ),
            children: [
              DigitCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'hi',
                      style: theme.textTheme.displayMedium,
                    ),
                    Column(children: [
                      DigitDateFormPicker(
                        isEnabled: false,
                        formControlName: 'dateOfReceipt',

                        /// Todo - transalation

                        label: 'Date',
                        isRequired: false,
                      ),
                      DigitTextFormField(
                        formControlName: 'administrativeUnit',

                        /// Todo - transalation
                        label: 'Admin Unit',
                      ),
                    ]),
                    const SizedBox(height: 16),

                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  FormGroup buildForm() =>
      fb.group(<String, Object>{
        'dateOfReceipt': FormControl<DateTime>(value: DateTime.now()),
        'administrativeUnit': FormControl<String>(value: ''),
        'warehouseName': FormControl<String>(value: ''),
      });
}
