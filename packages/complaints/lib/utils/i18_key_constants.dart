const common = Common();
const complaintTypeShowcase = ComplaintTypeShowcase();
const complaintsDetailsShowcase = ComplaintsDetailsShowcase();
const complaintsDetailsViewShowcase = ComplaintsDetailsViewShowcase();
const complaintsInboxShowcase = ComplaintsInboxShowcase();

class Common {
  const Common();

  String get coreCommonContinue => 'CORE_COMMON_CONTINUE';

  String get coreCommonAge => 'CORE_COMMON_AGE';

  String get coreCommonName => 'CORE_COMMON_NAME';

  String get coreCommonEmailId => 'CORE_COMMON_EMAIL_ID';

  String get coreCommonGender => 'CORE_COMMON_GENDER';

  String get coreCommonMobileNumber => 'CORE_COMMON_MOBILE_NUMBER';

  String get coreCommonSubmit => 'CORE_COMMON_SUBMIT';

  String get coreCommonSave => 'CORE_COMMON_SAVE';

  String get coreCommonCancel => 'CORE_COMMON_CANCEL';

  String get corecommonRequired => 'CORE_COMMON_REQUIRED';

  String get coreCommonReasonRequired => 'CORE_COMMON_REASON_REQUIRED';

  String get corecommonclose => 'CORE_COMMON_CLOSE';

  String get coreCommonOk => 'CORE_COMMON_OK';

  String get coreCommonNA => 'CORE_COMMON_NA';

  String get coreCommonProfile => 'CORE_COMMON_PROFILE';

  String get coreCommonLogout => 'CORE_COMMON_LOGOUT';

  String get coreCommonBack => 'CORE_COMMON_BACK';

  String get coreCommonHelp => 'CORE_COMMON_HELP';

  String get coreCommonHome => 'CORE_COMMON_HOME';

  String get coreCommonViewDownloadedData => 'CORE_COMMON_VIEW_DOWNLOADED_DATA';

  String get coreCommonlanguage => 'CORE_COMMON_LANGUAGE';

  String get coreCommonSyncProgress => 'CORE_COMMON_SYNC_PROGRESS';

  String get coreCommonDataSynced => 'CORE_COMMON_DATA_SYNCED';

  String get coreCommonDataSyncFailed => 'CORE_COMMON_DATA_SYNC_FAILED';

  String get coreCommonDataSyncRetry => 'CORE_COMMON_DATA_SYNC_RETRY';

  String get connectionLabel => 'CORE_COMMON_CONNECTION_LABEL';

  String get connectionContent => 'CORE_COMMON_CONNECTION_CONTENT';

  String get coreCommonSkip => 'CORE_COMMON_SKIP';

  String get coreCommonNext => 'CORE_COMMON_NEXT';

  String get coreCommonYes => 'CORE_COMMON_YES';

  String get coreCommonNo => 'CORE_COMMON_NO';
  String get coreCommonGoback => 'CORE_COMMON_GO_BACK';

  String get coreCommonRequiredItems => 'CORE_COMMON_REQUIRED_ITEMS';

  String get min2CharsRequired => 'MIN_2_CHARS_REQUIRED';

  String get maxCharsRequired => 'MAX_CHARS_ALLOWED';

  String get maxValue => 'MAX_VALUE_ALLOWED';
  String get minValue => 'MIN_VALUE_ALLOWED';

  String get noResultsFound => 'NO_RESULTS_FOUND';

  String get coreCommonSyncInProgress => 'CORE_COMMON_SYNC_IN_PROGRESS';

  String get facilitySearchHeaderLabel => 'FACILITY_SEARCH_HEADER_LABEL';
  String get projectFacilitySearchHeaderLabel =>
      'PROJECT_FACILITY_SEARCH_HEADER_LABEL';

  String get coreCommonDownload => 'CORE_COMMON_DOWNLOAD';

  String get coreCommonDownloadFailed => 'CORE_COMMON_DOWNLOAD_FAILED';

  String get noMatchFound => 'CORE_COMMON_NO_MATCH_FOUND';

  String get scanBales => 'CORE_COMMON_SCAN_BALES';
  String get ageInMonths => 'AGE_IN_MONTHS_LABEL';

  String get profileUpdateSuccess => 'PROFILE_UPDATE_SUCCESS';
}

class ComplaintTypeShowcase {
  const ComplaintTypeShowcase();

  String get complaintType {
    return 'COMPLAINT_TYPE_SHOWCASE_COMPLAINT_TYPE';
  }

  String get complaintTypeNext {
    return 'COMPLAINT_TYPE_SHOWCASE_COMPLAINT_TYPE_NEXT';
  }
}

class ComplaintsDetailsShowcase {
  const ComplaintsDetailsShowcase();

  String get complaintDate {
    return 'COMPLAINT_DETAILS_SHOWCASE_DATE';
  }

  String get complaintOrganizationUnit {
    return 'COMPLAINT_DETAILS_SHOWCASE_ORGANIZATION_UNIT';
  }

  String get complaintSelfOrOther {
    return 'COMPLAINT_DETAILS_SHOWCASE_SELF_OR_OTHER';
  }

  String get complaintName {
    return 'COMPLAINT_DETAILS_SHOWCASE_NAME';
  }

  String get complaintContact {
    return 'COMPLAINT_DETAILS_SHOWCASE_CONTACT';
  }

  String get complaintSupervisorName {
    return 'COMPLAINT_DETAILS_SHOWCASE_SUPERVISOR_NAME';
  }

  String get complaintSupervisorContact {
    return 'COMPLAINT_DETAILS_SHOWCASE_SUPERVISOR_CONTACT';
  }

  String get complaintDescription {
    return 'COMPLAINT_DETAILS_SHOWCASE_DESCRIPTION';
  }

  String get complaintSubmit {
    return 'COMPLAINT_DETAILS_SHOWCASE_SUBMIT';
  }
}

class ComplaintsDetailsViewShowcase {
  const ComplaintsDetailsViewShowcase();

  String get complaintNumber {
    return 'COMPLAINT_DETAILS_VIEW_SHOWCASE_NUMBER';
  }

  String get complaintType {
    return 'COMPLAINT_DETAILS_VIEW_SHOWCASE_TYPE';
  }

  String get complaintDate {
    return 'COMPLAINT_DETAILS_VIEW_SHOWCASE_DATE';
  }

  String get complaintName {
    return 'COMPLAINT_DETAILS_VIEW_SHOWCASE_NAME';
  }

  String get complaintArea {
    return 'COMPLAINT_DETAILS_VIEW_SHOWCASE_AREA';
  }

  String get complaintContact {
    return 'COMPLAINT_DETAILS_VIEW_CONTACT';
  }

  String get complaintStatus {
    return 'COMPLAINT_DETAILS_VIEW_SHOWCASE_STATUS';
  }

  String get complaintDescription {
    return 'COMPLAINT_DETAILS_VIEW_SHOWCASE_DESCRIPTION';
  }

  String get complaintClose {
    return 'COMPLAINT_DETAILS_VIEW_SHOWCASE_CLOSE';
  }
}

class ComplaintsInboxShowcase {
  const ComplaintsInboxShowcase();

  String get complaintSearch {
    return 'COMPLAINT_INBOX_SHOWCASE_SEARCH';
  }

  String get complaintFilter {
    return 'COMPLAINT_INBOX_SHOWCASE_FILTER';
  }

  String get complaintSort {
    return 'COMPLAINT_INBOX_SHOWCASE_SORT';
  }

  String get complaintNumber {
    return 'COMPLAINT_INBOX_SHOWCASE_NUMBER';
  }

  String get complaintType {
    return 'COMPLAINT_INBOX_SHOWCASE_TYPE';
  }

  String get complaintDate {
    return 'COMPLAINT_INBOX_SHOWCASE_DATE';
  }

  String get complaintArea {
    return 'COMPLAINT_INBOX_SHOWCASE_AREA';
  }

  String get complaintStatus {
    return 'COMPLAINT_INBOX_SHOWCASE_STATUS';
  }

  String get complaintOpen {
    return 'COMPLAINT_INBOX_SHOWCASE_OPEN';
  }

  String get complaintCreate {
    return 'COMPLAINT_INBOX_SHOWCASE_CREATE';
  }
}
