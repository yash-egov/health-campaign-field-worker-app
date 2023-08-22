import 'package:digit_components/digit_components.dart';
import 'package:digit_components/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/component_wrapper/product_variant_bloc_wrapper.dart';
import 'package:intl/intl.dart';
import 'package:recase/recase.dart';
import '../../models/entities/beneficiary_type.dart';
import '../../utils/extensions/extensions.dart';
import '../../utils/i18_key_constants.dart' as i18;
import '../../blocs/household_overview/household_overview.dart';
import '../../widgets/header/back_navigation_help_header.dart';
import '../../widgets/localized.dart';
import 'config/cycle.dart';

class BeneficiaryViewPage extends LocalizedStatefulWidget {
  const BeneficiaryViewPage({super.key, super.appLocalizations});

  @override
  State<BeneficiaryViewPage> createState() => _BeneficiaryViewPageState();
}

class _BeneficiaryViewPageState extends LocalizedState<BeneficiaryViewPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ProductVariantBlocWrapper(
      child: BlocBuilder<HouseholdOverviewBloc, HouseholdOverviewState>(
        builder: (context, state) {
          final householdMemberWrapper = state.householdMemberWrapper;

          final projectBeneficiary =
              context.beneficiaryType != BeneficiaryType.individual
                  ? [householdMemberWrapper.projectBeneficiaries.first]
                  : householdMemberWrapper.projectBeneficiaries
                      .where(
                        (element) =>
                            element.beneficiaryClientReferenceId ==
                            state.selectedIndividual?.clientReferenceId,
                      )
                      .toList();

          return BlocBuilder<HouseholdOverviewBloc, HouseholdOverviewState>(
            builder: (ctx, state) {
              return Scaffold(
                bottomNavigationBar: SizedBox(
                  height: 85,
                  child: Column(
                    children: [
                      DigitCard(
                        margin:
                            const EdgeInsets.only(left: 0, right: 0, top: 10),
                        child: DigitElevatedButton(
                          onPressed: () {},
                          child: Center(
                            child: Text(localizations.translate(
                              i18.searchBeneficiary.beneficiaryAddActionLabel,
                            )),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => DigitDialog.show(
                          context,
                          options: DigitDialogOptions(
                            titleText: localizations.translate(
                              i18.forgotPassword.labelText,
                            ),
                            contentText: localizations.translate(
                              i18.forgotPassword.contentText,
                            ),
                            primaryAction: DigitDialogActions(
                              label: localizations.translate(
                                i18.forgotPassword.primaryActionLabel,
                              ),
                              action: (ctx) =>
                                  Navigator.of(context, rootNavigator: true)
                                      .pop(),
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            localizations.translate(
                              i18.forgotPassword.actionLabel,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                body: ScrollableContent(
                  header: const Column(children: [
                    BackNavigationHelpHeaderWidget(),
                  ]),
                  children: [
                    Column(
                      children: [
                        DigitCard(
                          child: DigitTableCard(
                            // [TODO Need to replace with localization code]
                            headerName: 'Beneficiary Details',
                            element: {
                              localizations.translate(i18.deliverIntervention
                                  .dateOfRegistrationLabel): () {
                                final date =
                                    projectBeneficiary.first.dateOfRegistration;

                                final registrationDate =
                                    DateTime.fromMillisecondsSinceEpoch(
                                  date,
                                );

                                return DateFormat('dd MMMM yyyy')
                                    .format(registrationDate);
                              }(),
                              localizations.translate(
                                i18.deliverIntervention.memberCountText,
                              ): householdMemberWrapper.household.memberCount ??
                                  householdMemberWrapper.members.length,
                              localizations.translate(i18.householdOverView
                                      .householdOverViewHouseholdHeadLabel):
                                  householdMemberWrapper
                                          .headOfHousehold.name?.givenName ??
                                      '',
                              localizations.translate(
                                i18.deliverIntervention.idTypeText,
                              ): () {
                                final identifiers = householdMemberWrapper
                                    .headOfHousehold.identifiers;
                                if (identifiers == null ||
                                    identifiers.isEmpty) {
                                  return '';
                                }

                                return identifiers.first.identifierType ?? '';
                              }(),
                              localizations.translate(
                                i18.deliverIntervention.idNumberText,
                              ): () {
                                final identifiers = householdMemberWrapper
                                    .headOfHousehold.identifiers;
                                if (identifiers == null ||
                                    identifiers.isEmpty) {
                                  return '';
                                }

                                return identifiers.first.identifierId ?? '';
                              }(),
                              localizations.translate(
                                i18.common.coreCommonAge,
                              ): () {
                                final dob = householdMemberWrapper
                                    .headOfHousehold.dateOfBirth;
                                if (dob == null || dob.isEmpty) {
                                  return '';
                                }

                                final int years = DigitDateUtils.calculateAge(
                                  DigitDateUtils.getFormattedDateToDateTime(
                                        dob,
                                      ) ??
                                      DateTime.now(),
                                ).years;
                                final int months = DigitDateUtils.calculateAge(
                                  DigitDateUtils.getFormattedDateToDateTime(
                                        dob,
                                      ) ??
                                      DateTime.now(),
                                ).months;

                                return "$years ${localizations.translate(i18.memberCard.deliverDetailsYearText)} $months ${localizations.translate(i18.memberCard.deliverDetailsMonthsText)}";
                              }(),
                              localizations.translate(
                                i18.common.coreCommonGender,
                              ): householdMemberWrapper.headOfHousehold.gender
                                      ?.name.sentenceCase ??
                                  '',
                              localizations.translate(
                                i18.common.coreCommonMobileNumber,
                              ): householdMemberWrapper
                                      .headOfHousehold.mobileNumber ??
                                  '',
                            },
                          ),
                          // const DigitDivider(),
                        ),
                        DigitCard(
                          child: DigitTable(
                            headerName: 'Cycle 1',
                            height: 5 * 12,
                            headerList: cycleheaderList,
                            leftColumnWidth: 130,
                            rightColumnWidth: cycleheaderList.length * 17 * 6,
                            tableData: [],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
