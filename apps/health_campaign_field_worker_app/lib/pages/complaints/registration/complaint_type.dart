import 'package:digit_components/digit_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../blocs/app_initialization/app_initialization.dart';
import '../../../blocs/complaints_registration/complaints_registration.dart';
import '../../../router/app_router.dart';
import '../../../utils/i18_key_constants.dart' as i18;
import '../../../widgets/header/back_navigation_help_header.dart';
import '../../../widgets/localized.dart';

class ComplaintTypePage extends LocalizedStatefulWidget {
  const ComplaintTypePage({
    super.key,
    super.appLocalizations,
  });

  @override
  State<ComplaintTypePage> createState() => _ComplaintTypePageState();
}

class _ComplaintTypePageState extends LocalizedState<ComplaintTypePage> {
  static const _complaintType = 'complaintType';
  static const _otherComplaintType = 'otherComplaintType';

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ComplaintsRegistrationBloc>();
    final router = context.router;
    final theme = Theme.of(context);

    return Scaffold(
      body: ReactiveFormBuilder(
        form: () {
          return bloc.state.map(
            create: (value) => buildForm(value),
            persisted: (value) {
              throw const InvalidComplaintsRegistrationStateException();
            },
          );
        },
        builder: (context, form, child) => BlocBuilder<
            ComplaintsRegistrationBloc, ComplaintsRegistrationState>(
          builder: (context, state) {
            return ScrollableContent(
              header: Column(children: const [
                BackNavigationHelpHeaderWidget(),
              ]),
              footer: SizedBox(
                height: 85,
                child: DigitCard(
                  margin: const EdgeInsets.only(left: 0, right: 0, top: 10),
                  child: DigitElevatedButton(
                    onPressed: () async {
                      form.markAllAsTouched();

                      var complaintType = form.control(_complaintType).value;
                      var otherComplaintTypeValue =
                          form.control(_otherComplaintType).value;

                      if (!form.valid) return;

                      if (complaintType == "Other") {
                        if (otherComplaintTypeValue == null) return;

                        form.control(_complaintType).value =
                            otherComplaintTypeValue;
                      }

                      state.whenOrNull(
                        create: (
                          loading,
                          complaintType,
                          addressModel,
                          complaintsDetailsModel,
                        ) {
                          bloc.add(
                            ComplaintsRegistrationEvent.saveComplaintType(
                              complaintType: form.control(_complaintType).value,
                            ),
                          );
                        },
                      );

                      router.push(ComplaintsLocationRoute());
                    },
                    child: Center(
                      child: Text(
                        localizations.translate(i18.complaints.actionLabel),
                      ),
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
                        localizations.translate(
                          i18.complaints.complaintsTypeHeading,
                        ),
                        style: theme.textTheme.displayMedium,
                      ),
                      LabeledField(
                        label: localizations.translate(
                          i18.complaints.complaintsTypeLabel,
                        ),
                        child: BlocBuilder<AppInitializationBloc,
                            AppInitializationState>(
                          builder: (context, state) {
                            return state.maybeWhen(
                              orElse: () => const Offstage(),
                              initialized:
                                  (appConfiguration, serviceRegistryList) {
                                var complaintTypes = appConfiguration
                                    .complaintTypes
                                    ?.map((e) => e.name)
                                    .toList();
                                complaintTypes?.add("Other");

                                return RadioGroup<String>.builder(
                                  groupValue:
                                      form.control(_complaintType).value ?? "",
                                  onChanged: (changedValue) {
                                    setState(() {
                                      form.control(_complaintType).value =
                                          changedValue;
                                    });
                                  },
                                  items: complaintTypes ?? [],
                                  itemBuilder: (item) => RadioButtonBuilder(
                                    item.trim(),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      if (form.control(_complaintType).value == "Other") ...[
                        const DigitTextFormField(
                          formControlName: _otherComplaintType,
                          label: "",
                          maxLength: 100,
                        ),
                      ],
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  FormGroup buildForm(ComplaintsRegistrationCreateState state) {
    return fb.group(<String, Object>{
      _complaintType: FormControl<String>(
        validators: [Validators.required],
        value: state.complaintType,
      ),
      _otherComplaintType: FormControl<String>(
        validators: [],
        value: state.complaintType,
      ),
    });
  }
}
