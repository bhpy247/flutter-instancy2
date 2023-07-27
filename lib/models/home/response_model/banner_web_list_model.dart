import '../../../utils/parsing_helper.dart';

class BannerWebListModel {
  List<WebList>? webList;

  BannerWebListModel({this.webList});

  BannerWebListModel.fromJson(Map<String, dynamic> json) {
    if (json['WebList'] != null) {
      webList = <WebList>[];
      json['WebList'].forEach((v) {
        webList!.add(WebList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (webList != null) {
      data['WebList'] = webList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WebList {
  String webpageTitle = "";
  String imageWithLink = "";
  String shortDesc = "";
  String titleWithLink = "";
  String moreLink = "";
  String itemMoreLink = "";
  String titleWithURL = "";
  String topNews = "";
  String daysFromDate = "";
  String actionRead = "";
  String newsTitleWithLink = "";
  String contentID = "";
  String siteId = "";
  String siteUserID = "";
  int scoID = 0;
  String? thumbnailImagePath = "";
  String? previewPath = "";
  String? compInsID = "";
  String? detailsLink = "";
  String? objectTypeID = "";

  WebList(
      {this.webpageTitle = "",
        this.imageWithLink = "",
        this.shortDesc = "",
        this.titleWithLink = "",
        this.moreLink = "",
        this.itemMoreLink = "",
        this.titleWithURL = "",
        this.topNews = "",
        this.daysFromDate = "",
        this.actionRead = "",
        this.newsTitleWithLink = "",
        this.contentID = "",
        this.siteId = "",
        this.siteUserID = "",
        this.scoID = 0,
        this.thumbnailImagePath = "",
        this.previewPath = "",
        this.compInsID = "",
        this.detailsLink = "",
        this.objectTypeID = ""});

  WebList.fromJson(Map<String, dynamic> json) {
    webpageTitle = ParsingHelper.parseStringMethod(json['WebpageTitle']??"");
    imageWithLink = ParsingHelper.parseStringMethod(json['ImageWithLink']??"");
    shortDesc = ParsingHelper.parseStringMethod(json['shortDesc']??"");
    titleWithLink = ParsingHelper.parseStringMethod(json['TitleWithLink']??"");
    moreLink = ParsingHelper.parseStringMethod(json['MoreLink']??"");
    itemMoreLink = ParsingHelper.parseStringMethod(json['ItemMoreLink']??"");
    titleWithURL = ParsingHelper.parseStringMethod(json['TitleWithURL']??"");
    topNews = ParsingHelper.parseStringMethod(json['TopNews']??"");
    daysFromDate = ParsingHelper.parseStringMethod(json['DaysFromDate']??"");
    actionRead = ParsingHelper.parseStringMethod(json['actionRead']??"");
    newsTitleWithLink = ParsingHelper.parseStringMethod(json['NewsTitleWithLink']??"");
    contentID = ParsingHelper.parseStringMethod(json['ContentID']??"");
    siteId = ParsingHelper.parseStringMethod(json['SiteId']??"");
    siteUserID = ParsingHelper.parseStringMethod(json['SiteUserID']??"");
    scoID = ParsingHelper.parseIntMethod(json['ScoID']??0);
    thumbnailImagePath = ParsingHelper.parseStringMethod(json['ThumbnailImagePath']??"");
    previewPath = ParsingHelper.parseStringMethod(json['PreviewPath']??"");
    compInsID = ParsingHelper.parseStringMethod(json['CompInsID']??"");
    detailsLink = ParsingHelper.parseStringMethod(json['DetailsLink']??"");
    objectTypeID = ParsingHelper.parseStringMethod(json['ObjectTypeID']??"");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['WebpageTitle'] = webpageTitle;
    data['ImageWithLink'] = imageWithLink;
    data['shortDesc'] = shortDesc;
    data['TitleWithLink'] = titleWithLink;
    data['MoreLink'] = moreLink;
    data['ItemMoreLink'] = itemMoreLink;
    data['TitleWithURL'] = titleWithURL;
    data['TopNews'] = topNews;
    data['DaysFromDate'] = daysFromDate;
    data['actionRead'] = actionRead;
    data['NewsTitleWithLink'] = newsTitleWithLink;
    data['ContentID'] = contentID;
    data['SiteId'] = siteId;
    data['SiteUserID'] = siteUserID;
    data['ScoID'] = scoID;
    data['ThumbnailImagePath'] = thumbnailImagePath;
    data['PreviewPath'] = previewPath;
    data['CompInsID'] = compInsID;
    data['DetailsLink'] = detailsLink;
    data['ObjectTypeID'] = objectTypeID;
    return data;
  }
}
