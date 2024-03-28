import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/profile/profile_provider.dart';
import 'package:flutter_instancy_2/configs/app_configurations.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/app_ststem_configurations.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/site_configuration_model.dart';
import 'package:flutter_instancy_2/utils/date_representation.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';
import 'package:html/dom.dart' as html_dom;
import 'package:html/parser.dart' as html_parser;

import '../../models/profile/data_model/user_privilege_model.dart';
import '../../utils/my_print.dart';
import '../ui_actions/my_learning/my_learning_ui_action_configs.dart';

class AppConfigurationOperations {
  late AppProvider appProvider;

  AppConfigurationOperations({required AppProvider? appProvider}) {
    this.appProvider = appProvider ?? AppProvider();
  }

  static bool isValidHexColorString(String color) {
    RegExp exp = RegExp(r"#?([\da-fA-F]{2})([\da-fA-F]{2})([\da-fA-F]{2})");

    return exp.hasMatch(color);
  }

  static bool isValidEmailString(String email) {
    //if (email == '') { alert('Email ID cannot be empty'); return false; }
    if (email == '') {
      return false;
    }

    var invalidChars = '\/\'\\ ";:?!()[]\{\}^|';
    for (int i = 0; i < invalidChars.length; i++) {
      if (email.contains(invalidChars[i])) {
        return false;
      }
    }
    List<int> codeUnits = email.codeUnits;
    for (int i = 0; i < codeUnits.length; i++) {
      if (codeUnits[i] > 127) {
        return false;
      }
    }
    int atPos = email.indexOf('@', 0);
    if (atPos == -1) return false;
    if (atPos == 0) return false;
    if (email.indexOf('@', atPos + 1) > -1) return false;
    if (email.indexOf('.', atPos) == -1) return false;
    if (email.contains('@.')) return false;
    if (email.contains('.@')) return false;
    if (email.contains('..')) return false;
    String suffix = email.substring(email.lastIndexOf('.') + 1);
    if (suffix.length != 2 &&
        suffix != 'com' &&
        suffix != 'net' &&
        suffix != 'org' &&
        suffix != 'edu' &&
        suffix != 'int' &&
        suffix != 'mil' &&
        suffix != 'gov' &&
        suffix != 'arpa' &&
        suffix != 'biz' &&
        suffix != 'aero' &&
        suffix != 'name' &&
        suffix != 'coop' &&
        suffix != 'info' &&
        suffix != 'pro' &&
        suffix != 'museum') {
      return false;
    }
    return true;
  }

  String getInstancyImageUrlFromImagePath({required String imagePath}) {
    if (imagePath.isEmpty || imagePath.startsWith("http://") || imagePath.startsWith("https://")) return imagePath;

    String newImageUrl = '';

    //To Remove First Slash from Path because AzureRootPath and Site Url will have / at the end
    if (imagePath.startsWith("/")) imagePath = imagePath.replaceFirst("/", "");

    SiteUrlConfigurationModel siteUrlConfigurationModel = appProvider.siteConfigurations;
    AppSystemConfigurationModel appSystemConfigurationModel = appProvider.appSystemConfigurationModel;

    // MyPrint.printOnConsole("appSystemConfigurationModel.isCloudStorageEnabled:${appSystemConfigurationModel.isCloudStorageEnabled}");
    // MyPrint.printOnConsole("siteUrlConfigurationModel.siteLMSUrl:'${siteUrlConfigurationModel.siteLMSUrl}'");
    if (appSystemConfigurationModel.isCloudStorageEnabled) {
      newImageUrl = "${appSystemConfigurationModel.azureRootPath}$imagePath";
      // newImageUrl = newImageUrl.toLowerCase();
    } else {
      newImageUrl = '${siteUrlConfigurationModel.siteLMSUrl}$imagePath';
    }

    return newImageUrl;
  }

  String getARContentUrl({required String url}) {
    if (url.startsWith("http")) {
      return url;
    }

    if (url.startsWith("assets/")) {
      url = "${appProvider.siteConfigurations.siteLMSUrl}/ARVREditor/$url";
    } else if (url.startsWith("../content/media/")) {
      SiteUrlConfigurationModel siteUrlConfigurationModel = appProvider.siteConfigurations;
      // AppSystemConfigurationModel appSystemConfigurationModel = appProvider.appSystemConfigurationModel;

      url = '${siteUrlConfigurationModel.siteLMSUrl}${url.replaceFirst("../content/media/", "/Content/Instancy V2 Folders/")}';
    }

    // url = Uri.encodeFull(url);
    return url;
  }

  static Map<String, String> getConditionsMapFromConditionsString({
    required String conditionsString,
    String conditionSeparator1 = AppConfigurations.conditionSeparator1,
    String conditionSeparator2 = AppConfigurations.conditionSeparator2,
  }) {
    Map<String, String> map = <String, String>{};

    if (conditionSeparator1.isEmpty || conditionSeparator2.isEmpty) return map;

    List<String> conditionsList1 = getListFromSeparatorJoinedString(parameterString: conditionsString, separator: conditionSeparator1);
    for (String condition in conditionsList1) {
      List<String> conditionsList2 = getListFromSeparatorJoinedString(parameterString: condition, separator: conditionSeparator2);

      if (conditionsList2.length == 2) {
        map[conditionsList2[0]] = conditionsList2[1];
      }
    }
    return map;
  }

  static String getConditionsStringFromConditionsMap({
    required Map<String, dynamic> conditionsMap,
    String conditionSeparator1 = AppConfigurations.conditionSeparator1,
    String conditionSeparator2 = AppConfigurations.conditionSeparator2,
  }) {
    String conditionsString = "";

    if (conditionSeparator1.isEmpty || conditionSeparator2.isEmpty) return conditionsString;

    List<String> conditionStringsList = <String>[];
    conditionsMap.forEach((String key, dynamic value) {
      String string = "$key$conditionSeparator2${ParsingHelper.parseStringMethod(value)}";
      conditionStringsList.add(string);
    });

    conditionsString = conditionStringsList.join(conditionSeparator1);

    return conditionsString;
  }

  static List<String> getListFromSeparatorJoinedString({required String parameterString, String separator = ","}) {
    List<String> list = [];

    if (parameterString.isEmpty) return list;

    list = parameterString.split(separator);

    return list;
  }

  static String getSeparatorJoinedStringFromStringList({required List<String> list, String separator = ","}) {
    String parameterString = "";

    parameterString = list.join(separator);

    return parameterString;
  }

  static bool isValidString(String val) {
    val = val.replaceAll(" ", "");
    if (val.isEmpty || val == 'null' || val == "undefined") {
      return false;
    } else {
      return true;
    }
  }

  bool? isEventCompleted(String eventDate, {String dateFormat = ""}) {
    // MyPrint.printOnConsole("AppConfigurationOperations().isEventCompleted() called with eventDate:'$eventDate', dateFormat:'$dateFormat'");

    if (!isValidString(eventDate)) return null;

    DateTime? fromDate = dateFormat.isNotEmpty ? getEventDateTime(eventDate: eventDate, dateFormat: dateFormat) : null;
    if (fromDate == null) {
      dateFormat = "yyyy-MM-ddTHH:mm:ss";
      fromDate = ParsingHelper.parseDateTimeMethod(eventDate, dateFormat: dateFormat);

      if (fromDate == null) {
        return null;
      }
    }

    final date2 = DateTime.now();

    if (DatePresentation.isSameDay(fromDate, date2) || fromDate.isAfter(date2)) {
      return false;
    } else {
      return true;
    }
  }

  DateTime? getEventDateTime({required String eventDate, String dateFormat = ""}) {
    if (dateFormat.isEmpty) {
      dateFormat = appProvider.appSystemConfigurationModel.eventDateTimeFormat;
    }

    DateTime? fromDate = ParsingHelper.parseDateTimeMethod(eventDate, dateFormat: dateFormat);

    return fromDate;
  }

  String getConvertedEventDateTimeString({required String eventDate, String sourceDateFormat = "", String destinationDateFormat = ""}) {
    if (destinationDateFormat.isEmpty) {
      return "";
    }

    if (sourceDateFormat.isEmpty) {
      sourceDateFormat = appProvider.appSystemConfigurationModel.eventDateTimeFormat;
    }

    // MyPrint.printOnConsole("eventDate:'$eventDate'");
    // MyPrint.printOnConsole("sourceDateFormat:'$sourceDateFormat'");
    DateTime? fromDate = ParsingHelper.parseDateTimeMethod(eventDate, dateFormat: sourceDateFormat);

    return DatePresentation.getFormattedDate(dateFormat: destinationDateFormat, dateTime: fromDate) ?? "";
  }

  static String getStringRemovingAllHtmlTags(String htmlText) {
    String parsedString = "";

    html_dom.Document document = html_parser.parse(htmlText);
    parsedString = html_parser.parse(document.body?.text ?? "").documentElement?.text ?? "";

    return parsedString;
  }

  static bool isARContent({required int contentTypeId, required int mediaTypeId}) {
    bool isArContent = contentTypeId == InstancyObjectTypes.arModule ||
        contentTypeId == InstancyObjectTypes.vrModule ||
        mediaTypeId == InstancyMediaTypes.threeDObject ||
        mediaTypeId == InstancyMediaTypes.threeDAvatar;

    return isArContent;
  }

  bool checkComponentConsolidated({required String conditionsString}) {
    Map<String, String> conditionsMap = getConditionsMapFromConditionsString(conditionsString: conditionsString);

    return conditionsMap['Type']?.toLowerCase() == "consolidate";
  }

  bool checkCatalogConsolidated() {
    return checkComponentConsolidated(conditionsString: appProvider.menuComponentsMap[InstancyComponents.Catalog]?.conditions ?? "");
  }

  bool checkEventsConsolidated() {
    return checkComponentConsolidated(conditionsString: appProvider.menuComponentsMap[InstancyComponents.Events]?.conditions ?? "");
  }

  bool checkProfileConsolidated() {
    return checkComponentConsolidated(conditionsString: appProvider.menuComponentsMap[InstancyComponents.MyProfile]?.conditions ?? "");
  }

  bool checkProgressReportConsolidated() {
    return checkComponentConsolidated(conditionsString: appProvider.menuComponentsMap[InstancyComponents.ProgressReport]?.conditions ?? "");
  }

  static bool hasPrerequisiteContents(String AddLink) {
    List<String> list = AddLink.split("\$");
    if (list.firstElement == ContentAddLinkOperations.addrecommenedrelatedcontent && (list.length > 1 && ParsingHelper.parseIntMethod(list[1]) > 0)) {
      return true;
    } else {
      return false;
    }
  }

  bool showReviewAndRatingSection({required double averageRating}) {
    // MinimimRatingRequiredToShowRating (appSystemConfigurationModel.minimumRatingRequiredToShowRating)
    // NumberOfRatingsRequiredToShowRating (appSystemConfigurationModel.numberOfRatingsRequiredToShowRating)

    if (averageRating > 0 && averageRating < appProvider.appSystemConfigurationModel.minimumRatingRequiredToShowRating) {
      return false;
    }

    return true;
  }

  bool allowUserToRateCourse({required String actualContentStatus}) {
    // Content Status: passed, failed, completed, attended

    if (![ContentStatusTypes.completed, ContentStatusTypes.passed, ContentStatusTypes.failed, ContentStatusTypes.attended].contains(actualContentStatus)) {
      return false;
    }

    return true;
  }

  bool checkMenuAvailable({required int menuId}) {
    return [17, 2, 62].contains(menuId);
  }

  bool isShowSetComplete({required int objectTypeId, required int mediaTypeId, required String actualContentStatus, required ProfileProvider profileProvider, required String jwVideoKey}) {
    bool isShowSetComplete = false;
    bool isHavingPrivilegeForSetComplete = false;
    bool isValidContentTypeForSetComplete = false;
    bool isContentStatusValid = false;

    //region Check showSetCompletedlink present in userprivileges or not
    {
      try {
        List<UserPrivilegeModel> userPrivileges =
            profileProvider.userPrivilegeData.getList(isNewInstance: false).where((element) => element.privilegeid == MyCatalogPrivileges.showSetCompletedlink).toList();
        isHavingPrivilegeForSetComplete = userPrivileges.isNotEmpty;
      } catch (e, s) {
        MyPrint.printOnConsole("Error in Checking Autocompletenontrackablecontent in AppConfigurations.isShowSetComplete():$e");
        MyPrint.printOnConsole(s);
      }

      MyPrint.printOnConsole("isHavingPrivilegeForSetComplete:$isHavingPrivilegeForSetComplete");
    }
    //endregion

    //region Check Content Type Enable for SetComplete
    isValidContentTypeForSetComplete = MyLearningUIActionConfigs.isNonTrackableContent(
      objectTypeId: objectTypeId,
      mediaTypeId: mediaTypeId,
    );
    MyPrint.printOnConsole("isValidContentTypeForSetComplete:$isValidContentTypeForSetComplete");
    //endregion

    //region Check Content Status is valid or Not
    {
      MyPrint.printOnConsole("actualContentStatus:$actualContentStatus");

      //Possible status types: notAttempted, incomplete, completed
      if ([ContentStatusTypes.notAttempted, ContentStatusTypes.incomplete].contains(actualContentStatus)) {
        isContentStatusValid = true;

        if (appProvider.appSystemConfigurationModel.setcompletehidefornotstarted && actualContentStatus == ContentStatusTypes.notAttempted) {
          isContentStatusValid = false;
        } else if (jwVideoKey.isNotEmpty) {
          isContentStatusValid = false;
        }
      }

      MyPrint.printOnConsole("isContentStatusValid:$isContentStatusValid");
    }
    //endregion

    isShowSetComplete = isHavingPrivilegeForSetComplete && isValidContentTypeForSetComplete && isContentStatusValid;

    return isShowSetComplete;
  }
}
