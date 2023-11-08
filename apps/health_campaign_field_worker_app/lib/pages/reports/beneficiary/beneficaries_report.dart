import 'package:digit_components/digit_components.dart';
import 'package:digit_components/widgets/scrollable_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../router/app_router.dart';
import '../../../utils/i18_key_constants.dart' as i18;
import '../../../blocs/search_households/project_beneficiaries_downsync.dart';
import '../../../models/entities/downsync.dart';
import '../../../utils/extensions/extensions.dart';
import '../../../widgets/header/back_navigation_help_header.dart';
import '../../../widgets/localized.dart';

class BeneficariesReportPage extends LocalizedStatefulWidget {
  const BeneficariesReportPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return BeneficariesReportState();
  }
}

class BeneficariesReportState extends LocalizedState<BeneficariesReportPage> {
  List<DownsyncModel> downsyncList = [];
  @override
  void initState() {
    final bloc = context.read<BeneficiaryDownSyncBloc>();
    bloc.add(
      const BeneficiaryDownSyncEvent.downSyncReport(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // TODO [Need to add the i18 keys]

    return Scaffold(
      body: ScrollableContent(
        footer: SizedBox(
          height: 100,
          child: DigitCard(
            margin: const EdgeInsets.all(kPadding),
            child: DigitElevatedButton(
              onPressed: () {
                context.router.replace(HomeRoute());
              },
              child: const Text('Go To Home Screen'),
            ),
          ),
        ),
        header: const BackNavigationHelpHeaderWidget(),
        children: [
          BlocListener<BeneficiaryDownSyncBloc, BeneficiaryDownSyncState>(
            listener: (ctx, state) {
              state.maybeWhen(
                orElse: () => const Text(''),
                report: (downsyncCriteriaList) {
                  setState(() {
                    downsyncList = downsyncCriteriaList;
                  });
                },
              );
            },
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(kPadding),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    localizations.translate('Data Download Report'),
                    style: theme.textTheme.displayMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              ...downsyncList
                  .map(
                    (e) => DigitCard(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Boundary:',
                                style: theme.textTheme.headlineMedium,
                              ),
                              Text(
                                e.locality!,
                                style: theme.textTheme.headlineMedium,
                              ),
                              DigitOutLineButton(
                                label: 'Download',
                                onPressed: () {
                                  context.read<BeneficiaryDownSyncBloc>().add(
                                        DownSyncCheckTotalCountEvent(
                                          projectId: context.projectId,
                                          boundaryCode: e.locality!,
                                        ),
                                      );
                                },
                              ),
                            ],
                          ),
                          DigitTableCard(
                            element: {
                              'Status : ': e.offset! < e.totalCount!
                                  ? 'Partial Downloaded'
                                  : 'Downloaded Completely',
                              'Download Time : ': e.lastSyncedTime.toString(),
                              'Total Records Downloaded : ':
                                  '${e.totalCount}/${e.offset}',
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ]),
          ),
        ],
      ),
    );
  }
}
