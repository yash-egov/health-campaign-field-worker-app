import 'package:flutter/material.dart';

import '../../utils/i18_key_constants.dart' as i18;

class HomeShowcaseData {
  static final HomeShowcaseData _instance = HomeShowcaseData._();

  HomeShowcaseData._();

  factory HomeShowcaseData() => _instance;

  final List<ShowcaseItemData> showcaseData = [
    ShowcaseItemData(
      name: i18.home.beneficiaryLabel,
      key: GlobalKey(debugLabel: i18.home.beneficiaryLabel),
      messageLocalizationKey: '${i18.home.beneficiaryLabel}_HELP',
    ),
    ShowcaseItemData(
      name: i18.home.manageStockLabel,
      key: GlobalKey(debugLabel: i18.home.manageStockLabel),
      messageLocalizationKey: '${i18.home.manageStockLabel}_HELP',
    ),
    ShowcaseItemData(
      name: i18.home.stockReconciliationLabel,
      key: GlobalKey(debugLabel: i18.home.stockReconciliationLabel),
      messageLocalizationKey: '${i18.home.stockReconciliationLabel}_HELP',
    ),
    ShowcaseItemData(
      name: i18.home.viewReportsLabel,
      key: GlobalKey(debugLabel: i18.home.viewReportsLabel),
      messageLocalizationKey: '${i18.home.viewReportsLabel}_HELP',
    ),
    ShowcaseItemData(
      name: i18.home.myCheckList,
      key: GlobalKey(debugLabel: i18.home.myCheckList),
      messageLocalizationKey: '${i18.home.myCheckList}_HELP',
    ),
    ShowcaseItemData(
      name: i18.home.syncDataLabel,
      key: GlobalKey(debugLabel: i18.home.syncDataLabel),
      messageLocalizationKey: '${i18.home.syncDataLabel}_HELP',
    ),
    ShowcaseItemData(
      name: i18.home.callbackLabel,
      key: GlobalKey(debugLabel: i18.home.callbackLabel),
      messageLocalizationKey: '${i18.home.callbackLabel}_HELP',
    ),
  ];
}

class SearchBeneficiaryShowcaseData {
  static final SearchBeneficiaryShowcaseData _instance =
      SearchBeneficiaryShowcaseData._();

  SearchBeneficiaryShowcaseData._();

  factory SearchBeneficiaryShowcaseData() => _instance;

  final List<ShowcaseItemData> showcaseData = [
    ShowcaseItemData(
      name: i18.searchBeneficiary.beneficiarySearchHintText,
      key: GlobalKey(
        debugLabel: i18.searchBeneficiary.beneficiarySearchHintText,
      ),
      messageLocalizationKey:
          '${i18.searchBeneficiary.beneficiarySearchHintText}_HELP',
    ),
    ShowcaseItemData(
      name: i18.searchBeneficiary.beneficiaryAddActionLabel,
      key: GlobalKey(
        debugLabel: i18.searchBeneficiary.beneficiaryAddActionLabel,
      ),
      messageLocalizationKey:
          '${i18.searchBeneficiary.beneficiarySearchHintText}_HELP',
    ),
  ];
}

final class ShowcaseItemData {
  final String name;
  final GlobalKey key;
  final String messageLocalizationKey;

  const ShowcaseItemData({
    required this.name,
    required this.key,
    required this.messageLocalizationKey,
  });
}
