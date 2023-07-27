import 'package:flutter_instancy_2/utils/my_utils.dart';

class SiteUrlConfigurationModel {
  int _siteId = 374;
  String _siteName = "", _siteUrl = "", _siteApiUrl = "", _siteLMSUrl = "";

  int get siteId => _siteId;

  set siteId(int value) {
    _siteId = value;
  }

  String get siteName => _siteName;

  set siteName(String value) {
    _siteName = value;
  }

  String get siteUrl => _siteUrl;

  set siteUrl(value) {
    _siteUrl = value;
  }

  String get siteApiUrl => _siteApiUrl;

  set siteApiUrl(String value) {
    _siteApiUrl = value;
  }

  String get siteLMSUrl => _siteLMSUrl;

  set siteLMSUrl(String value) {
    _siteLMSUrl = value;
  }

  @override
  String toString() {
    return MyUtils.encodeJson({
      "siteId" : siteId,
      "siteName" : siteName,
      "siteUrl" : siteUrl,
      "siteApiUrl" : siteApiUrl,
      "siteLMSUrl" : siteLMSUrl,
    });
  }
}