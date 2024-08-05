import 'package:auto_route/auto_route.dart';
import 'package:digit_components/blocs/location/location.dart';
import 'package:digit_components/models/digit_table_model.dart';
import 'package:digit_components/theme/digit_theme.dart';
import 'package:digit_components/widgets/atoms/digit_radio_button_list.dart';
import 'package:digit_components/widgets/digit_card.dart';
import 'package:digit_components/widgets/digit_elevated_button.dart';
import 'package:digit_components/widgets/molecules/digit_table.dart';
import 'package:digit_components/widgets/molecules/digit_table_card.dart';
import 'package:digit_components/widgets/scrollable_content.dart';
import 'package:digit_data_model/data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:registration_delivery/blocs/app_localization.dart';
import 'package:registration_delivery/utils/extensions/extensions.dart';

import '../../../utils/i18_key_constants.dart' as i18;
import '../../blocs/delivery_intervention/deliver_intervention.dart';
import '../../blocs/household_overview/household_overview.dart';
import '../../models/entities/additional_fields_type.dart';
import '../../models/entities/status.dart';
import '../../models/entities/task.dart';
import '../../models/entities/task_resource.dart';
import '../../router/registration_delivery_router.gm.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../../widgets/back_navigation_help_header.dart';
import '../../widgets/component_wrapper/product_variant_bloc_wrapper.dart';
import '../../widgets/localized.dart';

@RoutePage()
class DoseAdministeredPage extends LocalizedStatefulWidget {
  const DoseAdministeredPage({
    super.key,
    super.appLocalizations,
  });

  @override
  State<DoseAdministeredPage> createState() => _DoseAdministeredPageState();
}

class _DoseAdministeredPageState extends LocalizedState<DoseAdministeredPage> {
  static const _doseAdministeredKey = 'doseAdministered';
  bool doseAdministered = false;
  bool formSubmitted = false;

  final clickedStatus = ValueNotifier<bool>(false);

  @override
  void dispose() {
    clickedStatus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = RegistrationDeliveryLocalization.of(context);
    final overViewBloc = context.read<HouseholdOverviewBloc>().state;
    // Define a list of TableHeader objects for the header of a table
    final headerListResource = [
      TableHeader(
        localizations.translate(i18.beneficiaryDetails.beneficiaryDose),
        cellKey: 'dose',
      ),
      TableHeader(
        localizations.translate(i18.beneficiaryDetails.beneficiaryResources),
        cellKey: 'resources',
      ),
    ];

    return ProductVariantBlocWrapper(
      child: PopScope(
        canPop: false,
        child: Scaffold(
          body: BlocBuilder<LocationBloc, LocationState>(
            builder: (context, locationState) {
              return ReactiveFormBuilder(
                form: () => buildForm(context),
                builder: (context, form, child) => ScrollableContent(
                  enableFixedButton: true,
                  header: const Column(children: [
                    BackNavigationHelpHeaderWidget(
                      showBackNavigation: false,
                      showHelp: false,
                    ),
                  ]),
                  footer: DigitCard(
                    margin: const EdgeInsets.fromLTRB(0, kPadding, 0, 0),
                    padding:
                        const EdgeInsets.fromLTRB(kPadding, 0, kPadding, 0),
                    child: ValueListenableBuilder(
                      valueListenable: clickedStatus,
                      builder: (context, bool isClicked, _) {
                        return DigitElevatedButton(
                          onPressed: isClicked
                              ? null
                              : () {
                                  if (form
                                          .control(_doseAdministeredKey)
                                          .value ==
                                      null) {
                                    clickedStatus.value = false;
                                    form
                                        .control(_doseAdministeredKey)
                                        .setErrors({'': true});
                                  }
                                  form.markAllAsTouched();

                                  if (!form.valid) {
                                    return;
                                  } else {
                                    final doseAdministered = form
                                        .control(_doseAdministeredKey)
                                        .value as KeyValue;
                                    final lat = locationState.latitude;
                                    final long = locationState.longitude;
                                    clickedStatus.value = true;
                                    final bloc = context
                                        .read<DeliverInterventionBloc>()
                                        .state;
                                    final event =
                                        context.read<DeliverInterventionBloc>();

                                    if (doseAdministered.key == true &&
                                        context.mounted) {
                                      // Iterate through future deliveries

                                      for (var e in bloc.futureDeliveries!) {
                                        int doseIndex = e.id;
                                        final clientReferenceId =
                                            IdGen.i.identifier;
                                        final address = bloc.oldTask?.address;
                                        // Create and dispatch a DeliverInterventionSubmitEvent with a new TaskModel
                                        event
                                            .add(DeliverInterventionSubmitEvent(
                                          task: TaskModel(
                                            projectId:
                                                RegistrationDeliverySingleton()
                                                    .projectId,
                                            address: address?.copyWith(
                                              relatedClientReferenceId:
                                                  clientReferenceId,
                                              id: null,
                                            ),
                                            status: Status.delivered.toValue(),
                                            clientReferenceId:
                                                clientReferenceId,
                                            projectBeneficiaryClientReferenceId:
                                                bloc.oldTask
                                                    ?.projectBeneficiaryClientReferenceId,
                                            tenantId:
                                                RegistrationDeliverySingleton()
                                                    .tenantId,
                                            rowVersion: 1,
                                            auditDetails: AuditDetails(
                                              createdBy:
                                                  RegistrationDeliverySingleton()
                                                      .loggedInUserUuid!,
                                              createdTime: context
                                                  .millisecondsSinceEpoch(),
                                            ),
                                            clientAuditDetails:
                                                ClientAuditDetails(
                                              createdBy:
                                                  RegistrationDeliverySingleton()
                                                      .loggedInUserUuid!,
                                              createdTime: context
                                                  .millisecondsSinceEpoch(),
                                            ),
                                            resources: fetchProductVariant(
                                              e,
                                              overViewBloc.selectedIndividual,
                                            )
                                                ?.productVariants
                                                ?.map((variant) =>
                                                    TaskResourceModel(
                                                      clientReferenceId:
                                                          IdGen.i.identifier,
                                                      tenantId:
                                                          RegistrationDeliverySingleton()
                                                              .tenantId,
                                                      taskclientReferenceId:
                                                          clientReferenceId,
                                                      quantity: variant.quantity
                                                          .toString(),
                                                      productVariantId: variant
                                                          .productVariantId,
                                                      isDelivered: true,
                                                      auditDetails:
                                                          AuditDetails(
                                                        createdBy:
                                                            RegistrationDeliverySingleton()
                                                                .loggedInUserUuid!,
                                                        createdTime: context
                                                            .millisecondsSinceEpoch(),
                                                      ),
                                                      clientAuditDetails:
                                                          ClientAuditDetails(
                                                        createdBy:
                                                            RegistrationDeliverySingleton()
                                                                .loggedInUserUuid!,
                                                        createdTime: context
                                                            .millisecondsSinceEpoch(),
                                                      ),
                                                    ))
                                                .toList(),
                                            additionalFields:
                                                TaskAdditionalFields(
                                              version: 1,
                                              fields: [
                                                AdditionalField(
                                                  AdditionalFieldsType
                                                      .dateOfDelivery
                                                      .toValue(),
                                                  DateTime.now()
                                                      .millisecondsSinceEpoch
                                                      .toString(),
                                                ),
                                                AdditionalField(
                                                  AdditionalFieldsType
                                                      .dateOfAdministration
                                                      .toValue(),
                                                  DateTime.now()
                                                      .millisecondsSinceEpoch
                                                      .toString(),
                                                ),
                                                AdditionalField(
                                                  AdditionalFieldsType
                                                      .dateOfVerification
                                                      .toValue(),
                                                  DateTime.now()
                                                      .millisecondsSinceEpoch
                                                      .toString(),
                                                ),
                                                AdditionalField(
                                                  AdditionalFieldsType
                                                      .cycleIndex
                                                      .toValue(),
                                                  "0${bloc.cycle}",
                                                ),
                                                AdditionalField(
                                                  AdditionalFieldsType.doseIndex
                                                      .toValue(),
                                                  "0$doseIndex",
                                                ),
                                                AdditionalField(
                                                  AdditionalFieldsType
                                                      .deliveryStrategy
                                                      .toValue(),
                                                  e.deliveryStrategy,
                                                ),
                                                if (lat != null)
                                                  AdditionalField(
                                                    AdditionalFieldsType
                                                        .latitude
                                                        .toValue(),
                                                    lat,
                                                  ),
                                                if (long != null)
                                                  AdditionalField(
                                                    AdditionalFieldsType
                                                        .longitude
                                                        .toValue(),
                                                    long,
                                                  ),
                                              ],
                                            ),
                                          ),
                                          isEditing: false,
                                          boundaryModel:
                                              RegistrationDeliverySingleton()
                                                  .boundary!,
                                        ));
                                      }
                                    }

                                    final reloadState =
                                        context.read<HouseholdOverviewBloc>();

                                    Future.delayed(
                                      const Duration(milliseconds: 1000),
                                      () {
                                        reloadState
                                            .add(HouseholdOverviewReloadEvent(
                                          projectId:
                                              RegistrationDeliverySingleton()
                                                  .projectId!,
                                          projectBeneficiaryType:
                                              RegistrationDeliverySingleton()
                                                  .beneficiaryType!,
                                        ));
                                      },
                                    ).then((value) => context.router.popAndPush(
                                          HouseholdAcknowledgementRoute(
                                            enableViewHousehold: true,
                                          ),
                                        ));
                                  }
                                },
                          child: Center(
                            child: Text(
                              localizations
                                  .translate(i18.common.coreCommonNext),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  children: [
                    DigitCard(
                      child: Column(
                        children: [
                          Text(
                            localizations.translate(
                              i18.deliverIntervention.wasTheDoseAdministered,
                            ),
                            style: theme.textTheme.displayMedium,
                          ),
                          DigitRadioButtonList<KeyValue>(
                            contentPadding: EdgeInsets.zero,
                            labelStyle: DigitTheme
                                .instance.mobileTheme.textTheme.headlineSmall,
                            formControlName: _doseAdministeredKey,
                            valueMapper: (val) =>
                                localizations.translate(val.label),
                            options: Constants.yesNo,
                            isRequired: true,
                            errorMessage: localizations.translate(
                              i18.common.corecommonRequired,
                            ),
                            onValueChange: (val) {
                              setState(() {
                                doseAdministered = val
                                    .key; // Update doseAdministered with setState
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    BlocBuilder<ProductVariantBloc, ProductVariantState>(
                      builder: (context, productState) {
                        return productState.maybeWhen(
                          orElse: () => const Offstage(),
                          fetched: (productVariantsValue) {
                            final variant = productState.whenOrNull(
                              fetched: (productVariants) {
                                return productVariants;
                              },
                            );

                            return DigitCard(
                              child: BlocBuilder<DeliverInterventionBloc,
                                  DeliverInterventionState>(
                                builder: (context, deliveryState) {
                                  List<TableDataRow> tableDataRows =
                                      deliveryState.futureDeliveries!.map((e) {
                                    int doseIndex = deliveryState
                                            .futureDeliveries!
                                            .indexOf(e) +
                                        deliveryState.dose +
                                        1;
                                    List<String> skus = fetchProductVariant(
                                      e,
                                      overViewBloc.selectedIndividual,
                                    )!
                                        .productVariants!
                                        .map((ele) {
                                      final pv = variant!.firstWhere(
                                        (element) =>
                                            element.id == ele.productVariantId,
                                      );

                                      return '${ele.quantity} - ${pv.sku.toString()}';
                                    }).toList();

                                    return TableDataRow([
                                      TableData(
                                        'Dose $doseIndex',
                                        cellKey: 'dose',
                                      ),
                                      TableData(
                                        skus.join(' + '),
                                        cellKey: 'resources',
                                      ),
                                    ]);
                                  }).toList();

                                  return Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: kPadding * 2,
                                          ),
                                          child: Text(
                                            localizations.translate(
                                              i18.beneficiaryDetails
                                                  .resourcesTobeProvided,
                                            ),
                                            style:
                                                theme.textTheme.displayMedium,
                                          ),
                                        ),
                                      ),
                                      DigitTableCard(
                                        padding:
                                            const EdgeInsets.only(bottom: 4.0),
                                        topPadding:
                                            const EdgeInsets.only(top: 4.0),
                                        element: {
                                          localizations.translate(
                                            i18.beneficiaryDetails
                                                .beneficiaryAge,
                                          ): localizations
                                              .translate(fetchProductVariant(
                                            deliveryState
                                                .futureDeliveries?.first,
                                            overViewBloc.selectedIndividual,
                                          )!
                                                  .condition!),
                                        },
                                      ),
                                      const Divider(
                                        thickness: 2.0,
                                      ),
                                      DigitTable(
                                        headerList: headerListResource,
                                        tableData: tableDataRows,
                                        columnWidth:
                                            MediaQuery.of(context).size.width /
                                                2.18,
                                        height:
                                            (tableDataRows.length + 1) * 57.5,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  FormGroup buildForm(BuildContext context) {
    return fb.group(<String, Object>{
      _doseAdministeredKey: FormControl<KeyValue>(
        value: null,
      ),
    });
  }
}
