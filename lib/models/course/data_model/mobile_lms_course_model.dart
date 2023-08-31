import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';
import '../../classroom_events/data_model/event_recodting_mobile_lms_data_model.dart';

class MobileLmsCourseModel {
  String sitename = "";
  String objectid = "";
  String medianame = "";
  String description = "";
  String contenttype = "";
  String iconpath = "";
  String contenttypethumbnail = "";
  String contentid = "";
  String instanceparentcontentid = "";
  String name = "";
  String language = "";
  String shortdescription = "";
  String startpage = "";
  String createddate = "";
  String keywords = "";
  String publisheddate = "";
  String status = "";
  String longdescription = "";
  String thumbnailimagepath = "";
  String folderpath = "";
  String modifieddate = "";
  String windowproperties = "";
  String certificateid = "";
  String participanturl = "";
  String eventstartdatetime = "";
  String eventenddatetime = "";
  String eventpercentage = "";
  String backgroundcolor = "";
  String fontcolor = "";
  String timezone = "";
  String certificatepercentage = "";
  String activityid = "";
  String contentauthordisplayname = "";
  String recordingurl = "";
  String startdate = "";
  String datecompleted = "";
  String totalsessiontime = "";
  String corelessonstatus = "";
  String groupdisplayname = "";
  String corelessonlocation = "";
  String actualstatus = "";
  String dateassigned = "";
  String percentcompleted = "";
  String usercertificateid = "";
  String certificatepage = "";
  String locationname = "";
  String buildingname = "";
  String authordisplayname = "";
  String recordingurl1 = "";
  String siteurl = "";
  String progress = "";
  String jwstartpage = "";
  String certificateaction = "";
  String qrcodeimagepath = "";
  String qrimagename = "";
  String headerlocationname = "";
  String suggesttoconnlink = "";
  String suggestwithfriendlink = "";
  String imageData = "";
  String author = "";
  String parentid = "";
  String blockName = "";
  String actionwaitlist = "";
  String ShareContentwithUser = "";
  String datefilter = "";
  String wstatus = "";
  String contentstatus = "";
  String duration = "";
  String presenter = "";
  String availableseats = "";
  String currency = "";
  String saleprice = "";
  String actionviewqrcode = "";
  double ratingid = 0;
  int objecttypeid = 0;
  int filterid = 0;
  int siteid = 0;
  int usersiteid = 0;
  int createduserid = 0;
  int cmsgroupid = 0;
  int mediatypeid = 0;
  int ecommbussinessrule = 0;
  int modifieduserid = 0;
  int viewtype = 0;
  int ciid = 0;
  int noofusersenrolled = 0;
  int noofuserscompleted = 0;
  int eventtype = 0;
  int devicetypeid = 0;
  int typeofevent = 0;
  int webinartool = 0;
  int totalattempts = 0;
  int accessperiodtype = 0;
  int eventscheduletype = 0;
  int scoid = 0;
  int accessednumber = 0;
  int noofattempts = 0;
  int groupdisplayorder = 0;
  int scoreraw = 0;
  int assignedby = 0;
  int accessperiodunit = 0;
  int xHide = 0;
  int required = 0;
  int schedulestatus = 0;
  int waitlistenrolls = 0;
  int relatedconentcount = 0;
  int totalratings = 0;
  int commentscount = 0;
  int isaddedtomylearning = 0;
  bool iscontent = false;
  bool downloadable = false;
  bool active = false;
  bool bit4 = false;
  bool bit5 = false;
  bool eventrecording = false;
  bool assignedbyadmin = false;
  bool isarchived = false;
  bool isdownloaded = false;
  bool eventrecording1 = false;
  bool removelink = false;
  bool isbadcancellationenabled = false;
  bool isenrollfutureinstance = false;
  bool isviewreview = false;
  bool isDownloading = false;
  bool allowednavigation = true;
  dynamic version;
  dynamic checkedoutto;
  dynamic owner;
  dynamic publicationdate;
  dynamic activatedate;
  dynamic expirydate;
  dynamic downloadfile;
  dynamic listprice;
  dynamic skinid;
  dynamic folderid;
  dynamic launchwindowmode;
  dynamic hardwaretype;
  dynamic enrollmentlimit;
  dynamic presenterurl;
  dynamic presenterid;
  dynamic location;
  dynamic conferencenumbers;
  dynamic directionurl;
  dynamic starttime;
  dynamic personalizediconid1;
  dynamic personalizediconid2;
  dynamic eventkey;
  dynamic nvarchar2;
  dynamic nvarchar3;
  dynamic audience;
  dynamic searchreferencenumber;
  dynamic nvarchar4;
  dynamic bit3;
  dynamic webinarpassword;
  dynamic bit2;
  dynamic seotitle;
  dynamic seometadescription;
  dynamic seokeywords;
  dynamic waitlistlimit;
  dynamic itunesproductid;
  dynamic googleproductid;
  dynamic decimal2;
  dynamic budgetprice;
  dynamic budgetcurrency;
  dynamic eventresourcedisplayoption;
  dynamic bigint4;
  dynamic offeringstartdate;
  dynamic offeringenddate;
  dynamic registrationurl;
  dynamic videointroduction;
  dynamic noofmodules;
  dynamic learningobjectives;
  dynamic tableofcontent;
  dynamic tagname;
  dynamic credittypes;
  dynamic eventcategories;
  dynamic recordingmsg;
  dynamic recordingcontentid;
  dynamic corechildren;
  dynamic coreentry;
  dynamic corecredit;
  dynamic scorechildren;
  dynamic scoremin;
  dynamic scoremax;
  dynamic launchdata;
  dynamic userid;
  dynamic targetdate;
  dynamic ismandatory;
  dynamic durationenddate;
  dynamic usercontentstatus;
  dynamic attemptsleft;
  dynamic accessperiod;
  dynamic purchaseddate;
  dynamic joinurl;
  dynamic confirmationurl;
  dynamic schedulereserveddatetime;
  dynamic invitationurl;
  dynamic link;
  dynamic pareportlink;
  dynamic dareportlink;
  dynamic jwvideokey;
  dynamic cloudmediaplayerkey;
  dynamic dtfcontent;
  dynamic recordingmsg1;
  dynamic recordingcontentid1;
  dynamic eventstartdatedisplay;
  dynamic eventenddatedisplay;
  dynamic timezoneabbreviation;
  dynamic reschduleparentid;
  dynamic viewprerequisitecontentstatus;
  dynamic iswishlistcontent;
  EventRecordingMobileLMSDataModel? recordingModel;

  MobileLmsCourseModel({
    this.sitename = "",
    this.objectid = "",
    this.medianame = "",
    this.description = "",
    this.contenttype = "",
    this.iconpath = "",
    this.contenttypethumbnail = "",
    this.contentid = "",
    this.instanceparentcontentid = "",
    this.name = "",
    this.language = "",
    this.shortdescription = "",
    this.startpage = "",
    this.createddate = "",
    this.keywords = "",
    this.publisheddate = "",
    this.status = "",
    this.longdescription = "",
    this.thumbnailimagepath = "",
    this.folderpath = "",
    this.modifieddate = "",
    this.windowproperties = "",
    this.certificateid = "",
    this.participanturl = "",
    this.eventstartdatetime = "",
    this.eventenddatetime = "",
    this.eventpercentage = "",
    this.backgroundcolor = "",
    this.fontcolor = "",
    this.timezone = "",
    this.certificatepercentage = "",
    this.activityid = "",
    this.contentauthordisplayname = "",
    this.recordingurl = "",
    this.startdate = "",
    this.actionviewqrcode = "",
    this.datecompleted = "",
    this.totalsessiontime = "",
    this.corelessonstatus = "",
    this.groupdisplayname = "",
    this.corelessonlocation = "",
    this.actualstatus = "",
    this.dateassigned = "",
    this.percentcompleted = "",
    this.usercertificateid = "",
    this.certificatepage = "",
    this.locationname = "",
    this.buildingname = "",
    this.authordisplayname = "",
    this.recordingurl1 = "",
    this.siteurl = "",
    this.progress = "",
    this.jwstartpage = "",
    this.certificateaction = "",
    this.qrcodeimagepath = "",
    this.qrimagename = "",
    this.headerlocationname = "",
    this.suggesttoconnlink = "",
    this.suggestwithfriendlink = "",
    this.imageData = "",
    this.author = "",
    this.parentid = "",
    this.blockName = "",
    this.actionwaitlist = "",
    this.ShareContentwithUser = "",
    this.datefilter = "",
    this.wstatus = "",
    this.contentstatus = "",
    this.duration = "",
    this.presenter = "",
    this.availableseats = "",
    this.currency = "",
    this.saleprice = "",
    this.ratingid = 0,
    this.objecttypeid = 0,
    this.filterid = 0,
    this.siteid = 0,
    this.usersiteid = 0,
    this.createduserid = 0,
    this.cmsgroupid = 0,
    this.mediatypeid = 0,
    this.ecommbussinessrule = 0,
    this.modifieduserid = 0,
    this.viewtype = 0,
    this.ciid = 0,
    this.noofusersenrolled = 0,
    this.noofuserscompleted = 0,
    this.eventtype = 0,
    this.devicetypeid = 0,
    this.typeofevent = 0,
    this.webinartool = 0,
    this.totalattempts = 0,
    this.accessperiodtype = 0,
    this.eventscheduletype = 0,
    this.scoid = 0,
    this.accessednumber = 0,
    this.noofattempts = 0,
    this.groupdisplayorder = 0,
    this.scoreraw = 0,
    this.assignedby = 0,
    this.accessperiodunit = 0,
    this.xHide = 0,
    this.required = 0,
    this.schedulestatus = 0,
    this.waitlistenrolls = 0,
    this.relatedconentcount = 0,
    this.totalratings = 0,
    this.commentscount = 0,
    this.isaddedtomylearning = 0,
    this.iscontent = false,
    this.downloadable = false,
    this.active = false,
    this.bit4 = false,
    this.bit5 = false,
    this.eventrecording = false,
    this.assignedbyadmin = false,
    this.isarchived = false,
    this.isdownloaded = false,
    this.eventrecording1 = false,
    this.removelink = false,
    this.isbadcancellationenabled = false,
    this.isenrollfutureinstance = false,
    this.isviewreview = false,
    this.isDownloading = false,
    this.allowednavigation = true,
    this.version,
    this.checkedoutto,
    this.owner,
    this.publicationdate,
    this.activatedate,
    this.expirydate,
    this.downloadfile,
    this.listprice,
    this.skinid,
    this.folderid,
    this.launchwindowmode,
    this.hardwaretype,
    this.enrollmentlimit,
    this.presenterurl,
    this.presenterid,
    this.location,
    this.conferencenumbers,
    this.directionurl,
    this.starttime,
    this.personalizediconid1,
    this.personalizediconid2,
    this.eventkey,
    this.nvarchar2,
    this.nvarchar3,
    this.audience,
    this.searchreferencenumber,
    this.nvarchar4,
    this.bit3,
    this.webinarpassword,
    this.bit2,
    this.seotitle,
    this.seometadescription,
    this.seokeywords,
    this.waitlistlimit,
    this.itunesproductid,
    this.googleproductid,
    this.decimal2,
    this.budgetprice,
    this.budgetcurrency,
    this.eventresourcedisplayoption,
    this.bigint4,
    this.offeringstartdate,
    this.offeringenddate,
    this.registrationurl,
    this.videointroduction,
    this.noofmodules,
    this.learningobjectives,
    this.tableofcontent,
    this.tagname,
    this.credittypes,
    this.eventcategories,
    this.recordingmsg,
    this.recordingcontentid,
    this.corechildren,
    this.coreentry,
    this.corecredit,
    this.scorechildren,
    this.scoremin,
    this.scoremax,
    this.launchdata,
    this.userid,
    this.targetdate,
    this.ismandatory,
    this.durationenddate,
    this.usercontentstatus,
    this.attemptsleft,
    this.accessperiod,
    this.purchaseddate,
    this.joinurl,
    this.confirmationurl,
    this.schedulereserveddatetime,
    this.invitationurl,
    this.link,
    this.pareportlink,
    this.dareportlink,
    this.jwvideokey,
    this.cloudmediaplayerkey,
    this.dtfcontent,
    this.recordingmsg1,
    this.recordingcontentid1,
    this.eventstartdatedisplay,
    this.eventenddatedisplay,
    this.timezoneabbreviation,
    this.reschduleparentid,
    this.viewprerequisitecontentstatus,
    this.iswishlistcontent,
    this.recordingModel,
  });

  MobileLmsCourseModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    sitename = ParsingHelper.parseStringMethod(map["sitename"]);
    objectid = ParsingHelper.parseStringMethod(map["objectid"]);
    medianame = ParsingHelper.parseStringMethod(map["medianame"]);
    description = ParsingHelper.parseStringMethod(map["description"]);
    contenttype = ParsingHelper.parseStringMethod(map["contenttype"]);
    iconpath = ParsingHelper.parseStringMethod(map["iconpath"]);
    contenttypethumbnail = ParsingHelper.parseStringMethod(map["contenttypethumbnail"]);
    contentid = ParsingHelper.parseStringMethod(map["contentid"]);
    instanceparentcontentid = ParsingHelper.parseStringMethod(map["instanceparentcontentid"]);
    name = ParsingHelper.parseStringMethod(map["name"]);
    language = ParsingHelper.parseStringMethod(map["language"]);
    shortdescription = ParsingHelper.parseStringMethod(map["shortdescription"]);
    startpage = ParsingHelper.parseStringMethod(map["startpage"]);
    createddate = ParsingHelper.parseStringMethod(map["createddate"]);
    keywords = ParsingHelper.parseStringMethod(map["keywords"]);
    publisheddate = ParsingHelper.parseStringMethod(map["publisheddate"]);
    status = ParsingHelper.parseStringMethod(map["status"]);
    longdescription = ParsingHelper.parseStringMethod(map["longdescription"]);
    thumbnailimagepath = ParsingHelper.parseStringMethod(map["thumbnailimagepath"]);
    folderpath = ParsingHelper.parseStringMethod(map["folderpath"]);
    modifieddate = ParsingHelper.parseStringMethod(map["modifieddate"]);
    windowproperties = ParsingHelper.parseStringMethod(map["windowproperties"]);
    certificateid = ParsingHelper.parseStringMethod(map["certificateid"]);
    participanturl = ParsingHelper.parseStringMethod(map["participanturl"]);
    eventstartdatetime = ParsingHelper.parseStringMethod(map["eventstartdatetime"]);
    eventenddatetime = ParsingHelper.parseStringMethod(map["eventenddatetime"]);
    eventpercentage = ParsingHelper.parseStringMethod(map["eventpercentage"]);
    backgroundcolor = ParsingHelper.parseStringMethod(map["backgroundcolor"]);
    fontcolor = ParsingHelper.parseStringMethod(map["fontcolor"]);
    timezone = ParsingHelper.parseStringMethod(map["timezone"]);
    certificatepercentage = ParsingHelper.parseStringMethod(map["certificatepercentage"]);
    activityid = ParsingHelper.parseStringMethod(map["activityid"]);
    contentauthordisplayname = ParsingHelper.parseStringMethod(map["contentauthordisplayname"]);
    recordingurl = ParsingHelper.parseStringMethod(map["recordingurl"]);
    startdate = ParsingHelper.parseStringMethod(map["startdate"]);
    datecompleted = ParsingHelper.parseStringMethod(map["datecompleted"]);
    totalsessiontime = ParsingHelper.parseStringMethod(map["totalsessiontime"]);
    corelessonstatus = ParsingHelper.parseStringMethod(map["corelessonstatus"]);
    groupdisplayname = ParsingHelper.parseStringMethod(map["groupdisplayname"]);
    corelessonlocation = ParsingHelper.parseStringMethod(map["corelessonlocation"]);
    actualstatus = ParsingHelper.parseStringMethod(map["actualstatus"]);
    dateassigned = ParsingHelper.parseStringMethod(map["dateassigned"]);
    percentcompleted = ParsingHelper.parseStringMethod(map["percentcompleted"]);
    usercertificateid = ParsingHelper.parseStringMethod(map["usercertificateid"]);
    certificatepage = ParsingHelper.parseStringMethod(map["certificatepage"]);
    locationname = ParsingHelper.parseStringMethod(map["locationname"]);
    buildingname = ParsingHelper.parseStringMethod(map["buildingname"]);
    authordisplayname = ParsingHelper.parseStringMethod(map["authordisplayname"]);
    recordingurl1 = ParsingHelper.parseStringMethod(map["recordingurl1"]);
    siteurl = ParsingHelper.parseStringMethod(map["siteurl"]);
    progress = ParsingHelper.parseStringMethod(map["progress"]);
    jwstartpage = ParsingHelper.parseStringMethod(map["jwstartpage"]);
    certificateaction = ParsingHelper.parseStringMethod(map["certificateaction"]);
    qrcodeimagepath = ParsingHelper.parseStringMethod(map["qrcodeimagepath"]);
    qrimagename = ParsingHelper.parseStringMethod(map["qrimagename"]);
    headerlocationname = ParsingHelper.parseStringMethod(map["headerlocationname"]);
    suggesttoconnlink = ParsingHelper.parseStringMethod(map["suggesttoconnlink"]);
    suggestwithfriendlink = ParsingHelper.parseStringMethod(map["suggestwithfriendlink"]);
    imageData = ParsingHelper.parseStringMethod(map["imageData"]);
    author = ParsingHelper.parseStringMethod(map["author"]);
    parentid = ParsingHelper.parseStringMethod(map["parentid"]);
    blockName = ParsingHelper.parseStringMethod(map["blockName"]);
    actionwaitlist = ParsingHelper.parseStringMethod(map["actionwaitlist"]);
    ShareContentwithUser = ParsingHelper.parseStringMethod(map["ShareContentwithUser"]);
    datefilter = ParsingHelper.parseStringMethod(map["datefilter"]);
    wstatus = ParsingHelper.parseStringMethod(map["wstatus"]);
    contentstatus = ParsingHelper.parseStringMethod(map["contentstatus"]);
    duration = ParsingHelper.parseStringMethod(map["duration"]);
    presenter = ParsingHelper.parseStringMethod(map["presenter"]);
    availableseats = ParsingHelper.parseStringMethod(map["availableseats"]);
    currency = ParsingHelper.parseStringMethod(map["currency"]);
    saleprice = ParsingHelper.parseStringMethod(map["saleprice"]);
    actionviewqrcode = ParsingHelper.parseStringMethod(map["actionviewqrcode"]);
    ratingid = ParsingHelper.parseDoubleMethod(map["ratingid"]);
    objecttypeid = ParsingHelper.parseIntMethod(map["objecttypeid"]);
    filterid = ParsingHelper.parseIntMethod(map["filterid"]);
    siteid = ParsingHelper.parseIntMethod(map["siteid"]);
    usersiteid = ParsingHelper.parseIntMethod(map["usersiteid"]);
    createduserid = ParsingHelper.parseIntMethod(map["createduserid"]);
    cmsgroupid = ParsingHelper.parseIntMethod(map["cmsgroupid"]);
    mediatypeid = ParsingHelper.parseIntMethod(map["mediatypeid"]);
    ecommbussinessrule = ParsingHelper.parseIntMethod(map["ecommbussinessrule"]);
    modifieduserid = ParsingHelper.parseIntMethod(map["modifieduserid"]);
    viewtype = ParsingHelper.parseIntMethod(map["viewtype"]);
    ciid = ParsingHelper.parseIntMethod(map["ciid"]);
    noofusersenrolled = ParsingHelper.parseIntMethod(map["noofusersenrolled"]);
    noofuserscompleted = ParsingHelper.parseIntMethod(map["noofuserscompleted"]);
    eventtype = ParsingHelper.parseIntMethod(map["eventtype"]);
    devicetypeid = ParsingHelper.parseIntMethod(map["devicetypeid"]);
    typeofevent = ParsingHelper.parseIntMethod(map["typeofevent"]);
    webinartool = ParsingHelper.parseIntMethod(map["webinartool"]);
    totalattempts = ParsingHelper.parseIntMethod(map["totalattempts"]);
    accessperiodtype = ParsingHelper.parseIntMethod(map["accessperiodtype"]);
    eventscheduletype = ParsingHelper.parseIntMethod(map["eventscheduletype"]);
    scoid = ParsingHelper.parseIntMethod(map["scoid"]);
    accessednumber = ParsingHelper.parseIntMethod(map["accessednumber"]);
    noofattempts = ParsingHelper.parseIntMethod(map["noofattempts"]);
    groupdisplayorder = ParsingHelper.parseIntMethod(map["groupdisplayorder"]);
    scoreraw = ParsingHelper.parseIntMethod(map["scoreraw"]);
    assignedby = ParsingHelper.parseIntMethod(map["assignedby"]);
    accessperiodunit = ParsingHelper.parseIntMethod(map["accessperiodunit"]);
    xHide = ParsingHelper.parseIntMethod(map["xHide"]);
    required = ParsingHelper.parseIntMethod(map["required"]);
    schedulestatus = ParsingHelper.parseIntMethod(map["schedulestatus"]);
    waitlistenrolls = ParsingHelper.parseIntMethod(map["waitlistenrolls"]);
    relatedconentcount = ParsingHelper.parseIntMethod(map["relatedconentcount"]);
    totalratings = ParsingHelper.parseIntMethod(map["totalratings"]);
    commentscount = ParsingHelper.parseIntMethod(map["commentscount"]);
    isaddedtomylearning = ParsingHelper.parseIntMethod(map["isaddedtomylearning"]);
    iscontent = ParsingHelper.parseBoolMethod(map["iscontent"]);
    downloadable = ParsingHelper.parseBoolMethod(map["downloadable"]);
    active = ParsingHelper.parseBoolMethod(map["active"]);
    bit4 = ParsingHelper.parseBoolMethod(map["bit4"]);
    bit5 = ParsingHelper.parseBoolMethod(map["bit5"]);
    eventrecording = ParsingHelper.parseBoolMethod(map["eventrecording"]);
    assignedbyadmin = ParsingHelper.parseBoolMethod(map["assignedbyadmin"]);
    isarchived = ParsingHelper.parseBoolMethod(map["isarchived"]);
    isdownloaded = ParsingHelper.parseBoolMethod(map["isdownloaded"]);
    eventrecording1 = ParsingHelper.parseBoolMethod(map["eventrecording1"]);
    removelink = ParsingHelper.parseBoolMethod(map["removelink"]);
    isbadcancellationenabled = ParsingHelper.parseBoolMethod(map["isbadcancellationenabled"]);
    isenrollfutureinstance = ParsingHelper.parseBoolMethod(map["isenrollfutureinstance"]);
    isviewreview = ParsingHelper.parseBoolMethod(map["isviewreview"]);
    isDownloading = ParsingHelper.parseBoolMethod(map["isDownloading"]);
    allowednavigation = ParsingHelper.parseBoolMethod(map["allowednavigation"], defaultValue: true);
    version = map["version"];
    checkedoutto = map["checkedoutto"];
    owner = map["owner"];
    publicationdate = map["publicationdate"];
    activatedate = map["activatedate"];
    expirydate = map["expirydate"];
    downloadfile = map["downloadfile"];
    listprice = map["listprice"];
    skinid = map["skinid"];
    folderid = map["folderid"];
    launchwindowmode = map["launchwindowmode"];
    hardwaretype = map["hardwaretype"];
    enrollmentlimit = map["enrollmentlimit"];
    presenterurl = map["presenterurl"];
    presenterid = map["presenterid"];
    location = map["location"];
    conferencenumbers = map["conferencenumbers"];
    directionurl = map["directionurl"];
    starttime = map["starttime"];
    personalizediconid1 = map["personalizediconid1"];
    personalizediconid2 = map["personalizediconid2"];
    eventkey = map["eventkey"];
    nvarchar2 = map["nvarchar2"];
    nvarchar3 = map["nvarchar3"];
    audience = map["audience"];
    searchreferencenumber = map["searchreferencenumber"];
    nvarchar4 = map["nvarchar4"];
    bit3 = map["bit3"];
    webinarpassword = map["webinarpassword"];
    bit2 = map["bit2"];
    seotitle = map["seotitle"];
    seometadescription = map["seometadescription"];
    seokeywords = map["seokeywords"];
    waitlistlimit = map["waitlistlimit"];
    itunesproductid = map["itunesproductid"];
    googleproductid = map["googleproductid"];
    decimal2 = map["decimal2"];
    budgetprice = map["budgetprice"];
    budgetcurrency = map["budgetcurrency"];
    eventresourcedisplayoption = map["eventresourcedisplayoption"];
    bigint4 = map["bigint4"];
    offeringstartdate = map["offeringstartdate"];
    offeringenddate = map["offeringenddate"];
    registrationurl = map["registrationurl"];
    videointroduction = map["videointroduction"];
    noofmodules = map["noofmodules"];
    learningobjectives = map["learningobjectives"];
    tableofcontent = map["tableofcontent"];
    tagname = map["tagname"];
    credittypes = map["credittypes"];
    eventcategories = map["eventcategories"];
    recordingmsg = map["recordingmsg"];
    recordingcontentid = map["recordingcontentid"];
    corechildren = map["corechildren"];
    coreentry = map["coreentry"];
    corecredit = map["corecredit"];
    scorechildren = map["scorechildren"];
    scoremin = map["scoremin"];
    scoremax = map["scoremax"];
    launchdata = map["launchdata"];
    userid = map["userid"];
    targetdate = map["targetdate"];
    ismandatory = map["ismandatory"];
    durationenddate = map["durationenddate"];
    usercontentstatus = map["usercontentstatus"];
    attemptsleft = map["attemptsleft"];
    accessperiod = map["accessperiod"];
    purchaseddate = map["purchaseddate"];
    joinurl = map["joinurl"];
    confirmationurl = map["confirmationurl"];
    schedulereserveddatetime = map["schedulereserveddatetime"];
    invitationurl = map["invitationurl"];
    link = map["link"];
    pareportlink = map["pareportlink"];
    dareportlink = map["dareportlink"];
    jwvideokey = map["jwvideokey"];
    cloudmediaplayerkey = map["cloudmediaplayerkey"];
    dtfcontent = map["dtfcontent"];
    recordingmsg1 = map["recordingmsg1"];
    recordingcontentid1 = map["recordingcontentid1"];
    eventstartdatedisplay = map["eventstartdatedisplay"];
    eventenddatedisplay = map["eventenddatedisplay"];
    timezoneabbreviation = map["timezoneabbreviation"];
    reschduleparentid = map["reschduleparentid"];
    viewprerequisitecontentstatus = map["viewprerequisitecontentstatus"];
    iswishlistcontent = map["iswishlistcontent"];
    // recordingModel =
  }

  Map<String, dynamic> toMap({bool toJson = true}) {
    return <String, dynamic>{
      "sitename": sitename,
      "objectid": objectid,
      "medianame": medianame,
      "description": description,
      "contenttype": contenttype,
      "iconpath": iconpath,
      "contenttypethumbnail": contenttypethumbnail,
      "contentid": contentid,
      "instanceparentcontentid": instanceparentcontentid,
      "name": name,
      "language": language,
      "shortdescription": shortdescription,
      "startpage": startpage,
      "createddate": createddate,
      "keywords": keywords,
      "publisheddate": publisheddate,
      "status": status,
      "longdescription": longdescription,
      "thumbnailimagepath": thumbnailimagepath,
      "folderpath": folderpath,
      "modifieddate": modifieddate,
      "windowproperties": windowproperties,
      "certificateid": certificateid,
      "participanturl": participanturl,
      "eventstartdatetime": eventstartdatetime,
      "eventenddatetime": eventenddatetime,
      "eventpercentage": eventpercentage,
      "backgroundcolor": backgroundcolor,
      "fontcolor": fontcolor,
      "timezone": timezone,
      "certificatepercentage": certificatepercentage,
      "activityid": activityid,
      "contentauthordisplayname": contentauthordisplayname,
      "recordingurl": recordingurl,
      "startdate": startdate,
      "datecompleted": datecompleted,
      "totalsessiontime": totalsessiontime,
      "corelessonstatus": corelessonstatus,
      "groupdisplayname": groupdisplayname,
      "corelessonlocation": corelessonlocation,
      "actualstatus": actualstatus,
      "dateassigned": dateassigned,
      "percentcompleted": percentcompleted,
      "usercertificateid": usercertificateid,
      "certificatepage": certificatepage,
      "locationname": locationname,
      "buildingname": buildingname,
      "authordisplayname": authordisplayname,
      "recordingurl1": recordingurl1,
      "siteurl": siteurl,
      "progress": progress,
      "jwstartpage": jwstartpage,
      "certificateaction": certificateaction,
      "qrcodeimagepath": qrcodeimagepath,
      "qrimagename": qrimagename,
      "headerlocationname": headerlocationname,
      "suggesttoconnlink": suggesttoconnlink,
      "suggestwithfriendlink": suggestwithfriendlink,
      "imageData": imageData,
      "author": author,
      "parentid": parentid,
      "blockName": blockName,
      "actionwaitlist": actionwaitlist,
      "ShareContentwithUser": ShareContentwithUser,
      "datefilter": datefilter,
      "wstatus": wstatus,
      "contentstatus": contentstatus,
      "duration": duration,
      "presenter": presenter,
      "availableseats": availableseats,
      "currency": currency,
      "saleprice": saleprice,
      "actionviewqrcode": actionviewqrcode,
      "ratingid": ratingid,
      "objecttypeid": objecttypeid,
      "filterid": filterid,
      "siteid": siteid,
      "usersiteid": usersiteid,
      "createduserid": createduserid,
      "cmsgroupid": cmsgroupid,
      "mediatypeid": mediatypeid,
      "ecommbussinessrule": ecommbussinessrule,
      "modifieduserid": modifieduserid,
      "viewtype": viewtype,
      "ciid": ciid,
      "noofusersenrolled": noofusersenrolled,
      "noofuserscompleted": noofuserscompleted,
      "eventtype": eventtype,
      "devicetypeid": devicetypeid,
      "typeofevent": typeofevent,
      "webinartool": webinartool,
      "totalattempts": totalattempts,
      "accessperiodtype": accessperiodtype,
      "eventscheduletype": eventscheduletype,
      "scoid": scoid,
      "accessednumber": accessednumber,
      "noofattempts": noofattempts,
      "groupdisplayorder": groupdisplayorder,
      "scoreraw": scoreraw,
      "assignedby": assignedby,
      "accessperiodunit": accessperiodunit,
      "xHide": xHide,
      "required": required,
      "schedulestatus": schedulestatus,
      "waitlistenrolls": waitlistenrolls,
      "relatedconentcount": relatedconentcount,
      "totalratings": totalratings,
      "commentscount": commentscount,
      "isaddedtomylearning": isaddedtomylearning,
      "iscontent": iscontent,
      "downloadable": downloadable,
      "active": active,
      "bit4": bit4,
      "bit5": bit5,
      "eventrecording": eventrecording,
      "assignedbyadmin": assignedbyadmin,
      "isarchived": isarchived,
      "isdownloaded": isdownloaded,
      "eventrecording1": eventrecording1,
      "removelink": removelink,
      "isbadcancellationenabled": isbadcancellationenabled,
      "isenrollfutureinstance": isenrollfutureinstance,
      "isviewreview": isviewreview,
      "isDownloading": isDownloading,
      "allowednavigation": allowednavigation,
      "version": version,
      "checkedoutto": checkedoutto,
      "owner": owner,
      "publicationdate": publicationdate,
      "activatedate": activatedate,
      "expirydate": expirydate,
      "downloadfile": downloadfile,
      "listprice": listprice,
      "skinid": skinid,
      "folderid": folderid,
      "launchwindowmode": launchwindowmode,
      "hardwaretype": hardwaretype,
      "enrollmentlimit": enrollmentlimit,
      "presenterurl": presenterurl,
      "presenterid": presenterid,
      "location": location,
      "conferencenumbers": conferencenumbers,
      "directionurl": directionurl,
      "starttime": starttime,
      "personalizediconid1": personalizediconid1,
      "personalizediconid2": personalizediconid2,
      "eventkey": eventkey,
      "nvarchar2": nvarchar2,
      "nvarchar3": nvarchar3,
      "audience": audience,
      "searchreferencenumber": searchreferencenumber,
      "nvarchar4": nvarchar4,
      "bit3": bit3,
      "webinarpassword": webinarpassword,
      "bit2": bit2,
      "seotitle": seotitle,
      "seometadescription": seometadescription,
      "seokeywords": seokeywords,
      "waitlistlimit": waitlistlimit,
      "itunesproductid": itunesproductid,
      "googleproductid": googleproductid,
      "decimal2": decimal2,
      "budgetprice": budgetprice,
      "budgetcurrency": budgetcurrency,
      "eventresourcedisplayoption": eventresourcedisplayoption,
      "bigint4": bigint4,
      "offeringstartdate": offeringstartdate,
      "offeringenddate": offeringenddate,
      "registrationurl": registrationurl,
      "videointroduction": videointroduction,
      "noofmodules": noofmodules,
      "learningobjectives": learningobjectives,
      "tableofcontent": tableofcontent,
      "tagname": tagname,
      "credittypes": credittypes,
      "eventcategories": eventcategories,
      "recordingmsg": recordingmsg,
      "recordingcontentid": recordingcontentid,
      "corechildren": corechildren,
      "coreentry": coreentry,
      "corecredit": corecredit,
      "scorechildren": scorechildren,
      "scoremin": scoremin,
      "scoremax": scoremax,
      "launchdata": launchdata,
      "userid": userid,
      "targetdate": targetdate,
      "ismandatory": ismandatory,
      "durationenddate": durationenddate,
      "usercontentstatus": usercontentstatus,
      "attemptsleft": attemptsleft,
      "accessperiod": accessperiod,
      "purchaseddate": purchaseddate,
      "joinurl": joinurl,
      "confirmationurl": confirmationurl,
      "schedulereserveddatetime": schedulereserveddatetime,
      "invitationurl": invitationurl,
      "link": link,
      "pareportlink": pareportlink,
      "dareportlink": dareportlink,
      "jwvideokey": jwvideokey,
      "cloudmediaplayerkey": cloudmediaplayerkey,
      "dtfcontent": dtfcontent,
      "recordingmsg1": recordingmsg1,
      "recordingcontentid1": recordingcontentid1,
      "eventstartdatedisplay": eventstartdatedisplay,
      "eventenddatedisplay": eventenddatedisplay,
      "timezoneabbreviation": timezoneabbreviation,
      "reschduleparentid": reschduleparentid,
      "viewprerequisitecontentstatus": viewprerequisitecontentstatus,
      "iswishlistcontent": iswishlistcontent,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}
