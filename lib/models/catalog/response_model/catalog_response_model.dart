/*
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';

import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';

class CatalogResponseModel {
  List<Table> table = [];
  List<Table1> table1 = [];
  List<dynamic> table3 = [];
  List<CatalogCourseDtoModel> catalogContentList = [];

  CatalogResponseModel({this.table = const[], this.table1 = const[], this.table3 = const[], this.catalogContentList = const[]});

  CatalogResponseModel.fromMap(Map<String, dynamic> map) {
    table = ParsingHelper.parseMapsListMethod<String, dynamic>(map['table']).map((e) => Table.fromMap(e)).toList();
    table1 = ParsingHelper.parseMapsListMethod<String, dynamic>(map['table1']).map((e) => Table1.fromMap(e)).toList();
    catalogContentList = ParsingHelper.parseMapsListMethod<String, dynamic>(map['table2']).map((e) => CatalogCourseDtoModel.fromMap(e)).toList();
    table3 = ParsingHelper.parseMapsListMethod<String, dynamic>(map['table3']).map((e) => e).toList();

  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['table'] = table.map((v) => v.toJson()).toList();
    data['table1'] = table1.map((v) => v.toMap()).toList();
    data['table3'] = table3.map((v) => v.toJson()).toList();
    data['table2'] = catalogContentList.map((v) => v.toMap()).toList();
    return data;
  }
}

class Table {
  int totalRecordsCount = 0;

  Table({this.totalRecordsCount = 0});

  Table.fromMap(Map<String, dynamic> json) {
    totalRecordsCount = ParsingHelper.parseIntMethod(json['totalrecordscount']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalrecordscount'] = totalRecordsCount;
    return data;
  }
}

class Table1 {
  String title = "";

  Table1({this.title = ""});

  Table1.fromMap(Map<String, dynamic> json) {
    title = ParsingHelper.parseStringMethod(json['title']);
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    return data;
  }
}

class CatalogCourseDtoModel extends CourseDTOModel {
  String objectid = "";
  String location = "";
  String locationname = "";
  String sortlocation = "";
  String eventfulllocation = "";
  int orgunitid = 0;
  String sitename = "";
  String assigntoouon = "";
  int componentid = 0;
  String description = "";
  String contenttype = "";
  String backgroundcolor = "";
  String fontcolor = "";
  String iconpath = "";
  bool iscontent = false;
  int objecttypeid1 = 0;
  String contenttypethumbnail = "";
  String contentid = "";
  String name = "";
  String language = "";
  String defaultlanguage = "";
  String shortdescription = "";
  String version = "";
  String startpage = "";
  int createduserid = 0;
  String createddate = "";
  String keywords = "";
  bool downloadable = false;
  String publisheddate = "";
  String status = "";
  int cmsgroupid = 0;
  String checkedoutto = "";
  String longdescription = "";
  int mediatypeid = 0;
  String owner = "";
  String publicationdate = "";
  String activatedate = "";
  String expirydate = "";
  String thumbnailimagepath = "";
  int ecommbussinessrule = 0;
  String downloadfile = "";
  String saleprice = "";
  String listprice = "";
  String folderpath = "";
  String skinid = "";
  String folderid = "";
  int modifieduserid = 0;
  String modifieddate = "";
  String author = "";
  int viewtype = 0;
  String windowproperties = "";
  String currency = "";
  String certificatepage = "";
  String certificateid = "";
  String launchwindowmode = "";
  int scoid = 0;
  bool active = false;
  String hardwaretype = "";
  String enrollmentlimit = "";
  String presenterurl = "";
  String participanturl = "";
  String eventstartdatetime = "";
  String eventenddatetime = "";
  String presenterId = "";
  String contentstatus = "";
  String location1 = "";
  String conferencenumbers = "";
  String directionurl = "";
  String eventpercentage = "";
  String starttime = "";
  String duration = "";
  String personalizediconid1 = "";
  String personalizediconid2 = "";
  int availableseats = 0;
  int ciid = 0;
  int noofusersenrolled = 0;
  int noofuserscompleted = 0;
  String outputtype = "";
  int contentsize = 0;
  String downloadsize = "";
  String eventkey = "";
  int eventtype = 0;
  String devicetypeid = "";
  String nvarchar2 = "";
  String nvarchar3 = "";
  String audience = "";
  String searchreferencenumber = "";
  String nvarchar4 = "";
  int membershiplevel = 0;
  String membershipname = "";
  String timezone = "";
  int ratingid = 0;
  int totalratings = 0;
  int totalenrolls = 0;
  String objectdisplayorder = "";
  String medianame = "";
  String bigint3 = "";
  String nvarchar1 = "";
  int typeofevent = 0;
  int webinartool = 0;
  String webinarpassword = "";
  String seotitle = "";
  String seometadescription = "";
  String seokeywords = "";
  String waitlistlimit = "";
  int waitlistenrolls = 0;
  int totalattempts = 0;
  String authordisplayname = "";
  int accessperiodtype = 0;
  String itunesproductid = "";
  String googleproductid = "";
  String decimal2 = "";
  String credittypes = "";
  String budgetprice = "";
  String budgetcurrency = "";
  String locationname1 = "";
  int eventscheduletype = 0;
  String activityid = "";
  String bigint4 = "";
  String eventresourcedisplayoption = "";
  String contentauthordisplayname = "";
  String videointroduction = "";
  String noofmodules = "";
  String learningobjectives = "";
  String tableofcontent = "";
  String tagname = "";
  String eventcategories = "";
  bool eventrecording = false;
  String recordingmsg = "";
  String recordingcontentid = "";
  String recordingurl = "";
  bool ispinned = false;
  String gradient1 = "";
  String gradient2 = "";
  int relatedContentCount = 0;
  int trackconentcount = 0;
  String publishedon = "";
  int relatedconentcount1 = 0;
  int trackconentcount1 = 0;
  String joinurl = "";
  String jwvideokey = "";
  String cloudmediaplayerkey = "";
  int isaddedtomylearning = 0;
  String eventstartdatedisplay = "";
  String eventenddatedisplay = "";
  String userid = "";
  int iswishlistcontent = 0;
  String actionwaitlist = "";
  bool isbadcancellationenabled = false;
  String viewprerequisitecontentstatus = "";
  String instanceparentcontentid = "";
  String suggesttoconnlink = "";
  String suggestwithfriendlink = "";
  String isContentEnrolled = "";

  CatalogCourseDtoModel({
        this.objectid = "",
        this.location = "",
        this.locationname = "",
        this.sortlocation = "",
        this.eventfulllocation = "",
        this.orgunitid = 0,
        this.sitename = "",
        this.assigntoouon = "",
        this.componentid = 0,
        this.description = "",
        this.contenttype = "",
        this.backgroundcolor = "",
        this.fontcolor = "",
        this.iconpath = "",
        this.iscontent = false,
        this.objecttypeid1 = 0,
        this.contenttypethumbnail = "",
        this.contentid = "",
        this.name = "",
        this.language = "",
        this.defaultlanguage = "",
        this.shortdescription = "",
        this.version = "",
        this.startpage = "",
        this.createduserid = 0,
        this.createddate = "",
        this.keywords = "",
        this.downloadable = false,
        this.publisheddate = "",
        this.status = "",
        this.cmsgroupid = 0,
        this.checkedoutto = "",
        this.longdescription = "",
        this.mediatypeid = 0,
        this.owner = "",
        this.publicationdate = "",
        this.activatedate = "",
        this.expirydate = "",
        this.thumbnailimagepath = "",
        this.ecommbussinessrule = 0,
        this.downloadfile = "",
        this.saleprice = "",
        this.listprice = "",
        this.folderpath = "",
        this.skinid = "",
        this.folderid = "",
        this.modifieduserid = 0,
        this.modifieddate = "",
        this.author = "",
        this.viewtype = 0,
        this.windowproperties = "",
        this.currency = "",
        this.certificatepage = "",
        this.certificateid = "",
        this.launchwindowmode = "",
        this.scoid = 0,
        this.active = false,
        this.hardwaretype = "",
        this.enrollmentlimit = "",
        this.presenterurl = "",
        this.participanturl = "",
        this.eventstartdatetime = "",
        this.eventenddatetime = "",
        this.presenterId = "",
        this.contentstatus = "",
        this.location1 = "",
        this.conferencenumbers = "",
        this.directionurl = "",
        this.eventpercentage = "",
        this.starttime = "",
        this.duration = "",
        this.personalizediconid1 = "",
        this.personalizediconid2 = "",
        this.availableseats = 0,
        this.ciid = 0,
        this.noofusersenrolled = 0,
        this.noofuserscompleted = 0,
        this.outputtype = "",
        this.contentsize = 0,
        this.downloadsize = "",
        this.eventkey = "",
        this.eventtype = 0,
        this.devicetypeid = "",
        this.nvarchar2 = "",
        this.nvarchar3 = "",
        this.audience = "",
        this.searchreferencenumber = "",
        this.nvarchar4 = "",
        this.membershiplevel = 0,
        this.membershipname = "",
        this.timezone = "",
        this.ratingid = 0,
        this.totalratings = 0,
        this.totalenrolls = 0,
        this.objectdisplayorder = "",
        this.medianame = "",
        this.bigint3 = "",
        this.nvarchar1 = "",
        this.typeofevent = 0,
        this.webinartool = 0,
        this.webinarpassword = "",
        this.seotitle = "",
        this.seometadescription = "",
        this.seokeywords = "",
        this.waitlistlimit = "",
        this.waitlistenrolls = 0,
        this.totalattempts = 0,
        this.authordisplayname = "",
        this.accessperiodtype = 0,
        this.itunesproductid = "",
        this.googleproductid = "",
        this.decimal2 = "",
        this.credittypes = "",
        this.budgetprice = "",
        this.budgetcurrency = "",
        this.locationname1 = "",
        this.eventscheduletype = 0,
        this.activityid = "",
        this.bigint4 = "",
        this.eventresourcedisplayoption = "",
        this.contentauthordisplayname = "",
        this.videointroduction = "",
        this.noofmodules = "",
        this.learningobjectives = "",
        this.tableofcontent = "",
        this.tagname = "",
        this.eventcategories = "",
        this.eventrecording = false,
        this.recordingmsg = "",
        this.recordingcontentid = "",
        this.recordingurl = "",
        this.ispinned = false,
        this.gradient1 = "",
        this.gradient2 = "",
        this.relatedContentCount = 0,
        this.trackconentcount =0,
        this.publishedon = "",
        this.relatedconentcount1 = 0,
        this.trackconentcount1 = 0,
        this.joinurl = "",
        this.jwvideokey = "",
        this.cloudmediaplayerkey = "",
        this.isaddedtomylearning = 0,
        this.eventstartdatedisplay = "",
        this.eventenddatedisplay = "",
        this.userid = "",
        this.iswishlistcontent = 0,
        this.actionwaitlist = "",
        this.isbadcancellationenabled = false,
        this.viewprerequisitecontentstatus = "",
        this.instanceparentcontentid = "",
        this.suggesttoconnlink = "",
        this.suggestwithfriendlink = "",
        this.isContentEnrolled = "",
  }) : super();

  CatalogCourseDtoModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  @override
  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    super.updateFromMap(map);

    objectid = ParsingHelper.parseStringMethod(map['objectid']);
    location = ParsingHelper.parseStringMethod(map['location']);
    locationname = ParsingHelper.parseStringMethod(map['locationname']);
    sortlocation = ParsingHelper.parseStringMethod(map['sortlocation']);
    eventfulllocation = ParsingHelper.parseStringMethod(map['eventfulllocation']);
    orgunitid = ParsingHelper.parseIntMethod(map['orgunitid']);
    sitename = ParsingHelper.parseStringMethod(map['sitename']);
    assigntoouon = ParsingHelper.parseStringMethod(map['assigntoouon']);
    componentid = ParsingHelper.parseIntMethod(map['componentid']);
    description = ParsingHelper.parseStringMethod(map['description']);
    contenttype = ParsingHelper.parseStringMethod(map['contenttype']);
    backgroundcolor = ParsingHelper.parseStringMethod(map['backgroundcolor']);
    fontcolor = ParsingHelper.parseStringMethod(map['fontcolor']);
    iconpath = ParsingHelper.parseStringMethod(map['iconpath']);
    iscontent = ParsingHelper.parseBoolMethod(map['iscontent']);
    objecttypeid1 = ParsingHelper.parseIntMethod(map['objecttypeid1']);
    contenttypethumbnail = ParsingHelper.parseStringMethod(map['contenttypethumbnail']);
    contentid = ParsingHelper.parseStringMethod(map['contentid']);
    name = ParsingHelper.parseStringMethod(map['name']);
    language = ParsingHelper.parseStringMethod(map['language']);
    defaultlanguage = ParsingHelper.parseStringMethod(map['defaultlanguage']);
    shortdescription = ParsingHelper.parseStringMethod(map['shortdescription']);
    version = ParsingHelper.parseStringMethod(map['version']);
    startpage = ParsingHelper.parseStringMethod(map['startpage']);
    createduserid = ParsingHelper.parseIntMethod(map['createduserid']);
    createddate = ParsingHelper.parseStringMethod(map['createddate']);
    keywords = ParsingHelper.parseStringMethod(map['keywords']);
    downloadable = ParsingHelper.parseBoolMethod(map['downloadable']);
    publisheddate = ParsingHelper.parseStringMethod(map['publisheddate']);
    status = ParsingHelper.parseStringMethod(map['status']);
    cmsgroupid = ParsingHelper.parseIntMethod(map['cmsgroupid']);
    checkedoutto = ParsingHelper.parseStringMethod(map['checkedoutto']);
    longdescription = ParsingHelper.parseStringMethod(map['longdescription']);
    mediatypeid = ParsingHelper.parseIntMethod(map['mediatypeid']);
    owner = ParsingHelper.parseStringMethod(map['owner']);
    publicationdate = ParsingHelper.parseStringMethod(map['publicationdate']);
    activatedate = ParsingHelper.parseStringMethod(map['activatedate']);
    expirydate = ParsingHelper.parseStringMethod(map['expirydate']);
    thumbnailimagepath = ParsingHelper.parseStringMethod(map['thumbnailimagepath']);
    ecommbussinessrule = ParsingHelper.parseIntMethod(map['ecommbussinessrule']);
    downloadfile = ParsingHelper.parseStringMethod(map['downloadfile']);
    saleprice = ParsingHelper.parseStringMethod(map['saleprice']);
    listprice = ParsingHelper.parseStringMethod(map['listprice']);
    folderpath = ParsingHelper.parseStringMethod(map['folderpath']);
    skinid = ParsingHelper.parseStringMethod(map['skinid']);
    folderid = ParsingHelper.parseStringMethod(map['folderid']);
    modifieduserid = ParsingHelper.parseIntMethod(map['modifieduserid']);
    modifieddate = ParsingHelper.parseStringMethod(map['modifieddate']);
    author = ParsingHelper.parseStringMethod(map['author']);
    viewtype = ParsingHelper.parseIntMethod(map['viewtype']);
    windowproperties = ParsingHelper.parseStringMethod(map['windowproperties']);
    currency = ParsingHelper.parseStringMethod(map['currency']);
    certificatepage = ParsingHelper.parseStringMethod(map['certificatepage']);
    certificateid = ParsingHelper.parseStringMethod(map['certificateid']);
    launchwindowmode = ParsingHelper.parseStringMethod(map['launchwindowmode']);
    scoid = ParsingHelper.parseIntMethod(map['scoid']);
    active = ParsingHelper.parseBoolMethod(map['active']);
    hardwaretype = ParsingHelper.parseStringMethod(map['hardwaretype']);
    enrollmentlimit = ParsingHelper.parseStringMethod(map['enrollmentlimit']);
    presenterurl = ParsingHelper.parseStringMethod(map['presenterurl']);
    participanturl = ParsingHelper.parseStringMethod(map['participanturl']);
    eventstartdatetime = ParsingHelper.parseStringMethod(map['eventstartdatetime']);
    eventenddatetime = ParsingHelper.parseStringMethod(map['eventenddatetime']);
    presenterId = ParsingHelper.parseStringMethod(map['presenterid']);
    contentstatus = ParsingHelper.parseStringMethod(map['contentstatus']);
    location1 = ParsingHelper.parseStringMethod(map['location1']);
    conferencenumbers = ParsingHelper.parseStringMethod(map['conferencenumbers']);
    directionurl = ParsingHelper.parseStringMethod(map['directionurl']);
    eventpercentage = ParsingHelper.parseStringMethod(map['eventpercentage']);
    starttime = ParsingHelper.parseStringMethod(map['starttime']);
    duration = ParsingHelper.parseStringMethod(map['duration']);
    personalizediconid1 = ParsingHelper.parseStringMethod(map['personalizediconid1']);
    personalizediconid2 = ParsingHelper.parseStringMethod(map['personalizediconid2']);
    availableseats = ParsingHelper.parseIntMethod(map['availableseats']);
    ciid = ParsingHelper.parseIntMethod(map['ciid']);
    noofusersenrolled = ParsingHelper.parseIntMethod(map['noofusersenrolled']);
    noofuserscompleted = ParsingHelper.parseIntMethod(map['noofuserscompleted']);
    outputtype = ParsingHelper.parseStringMethod(map['outputtype']);
    contentsize = ParsingHelper.parseIntMethod(map['contentsize']);
    downloadsize = ParsingHelper.parseStringMethod(map['downloadsize']);
    eventkey = ParsingHelper.parseStringMethod(map['eventkey']);
    eventtype = ParsingHelper.parseIntMethod(map['eventtype']);
    devicetypeid = ParsingHelper.parseStringMethod(map['devicetypeid']);
    nvarchar2 = ParsingHelper.parseStringMethod(map['nvarchar2']);
    nvarchar3 = ParsingHelper.parseStringMethod(map['nvarchar3']);
    audience = ParsingHelper.parseStringMethod(map['audience']);
    searchreferencenumber = ParsingHelper.parseStringMethod(map['searchreferencenumber']);
    nvarchar4 = ParsingHelper.parseStringMethod(map['nvarchar4']);
    membershiplevel = ParsingHelper.parseIntMethod(map['membershiplevel']);
    membershipname = ParsingHelper.parseStringMethod(map['membershipname']);
    timezone = ParsingHelper.parseStringMethod(map['timezone']);
    ratingid = ParsingHelper.parseIntMethod(map['ratingid']);
    totalratings = ParsingHelper.parseIntMethod(map['totalratings']);
    totalenrolls = ParsingHelper.parseIntMethod(map['totalenrolls']);
    objectdisplayorder = ParsingHelper.parseStringMethod(map['objectdisplayorder']);
    medianame = ParsingHelper.parseStringMethod(map['medianame']);
    bigint3 = ParsingHelper.parseStringMethod(map['bigint3']);
    nvarchar1 = ParsingHelper.parseStringMethod(map['nvarchar1']);
    typeofevent = ParsingHelper.parseIntMethod(map['typeofevent']);
    webinartool = ParsingHelper.parseIntMethod(map['webinartool']);
    webinarpassword = ParsingHelper.parseStringMethod(map['webinarpassword']);
    seotitle = ParsingHelper.parseStringMethod(map['seotitle']);
    seometadescription = ParsingHelper.parseStringMethod(map['seometadescription']);
    seokeywords = ParsingHelper.parseStringMethod(map['seokeywords']);
    waitlistlimit = ParsingHelper.parseStringMethod(map['waitlistlimit']);
    waitlistenrolls = ParsingHelper.parseIntMethod(map['waitlistenrolls']);
    totalattempts = ParsingHelper.parseIntMethod(map['totalattempts']);
    authordisplayname = ParsingHelper.parseStringMethod(map['authordisplayname']);
    accessperiodtype = ParsingHelper.parseIntMethod(map['accessperiodtype']);
    itunesproductid = ParsingHelper.parseStringMethod(map['itunesproductid']);
    googleproductid = ParsingHelper.parseStringMethod(map['googleproductid']);
    decimal2 = ParsingHelper.parseStringMethod(map['decimal2']);
    credittypes = ParsingHelper.parseStringMethod(map['credittypes']);
    budgetprice = ParsingHelper.parseStringMethod(map['budgetprice']);
    budgetcurrency = ParsingHelper.parseStringMethod(map['budgetcurrency']);
    locationname1 = ParsingHelper.parseStringMethod(map['locationname1']);
    eventscheduletype = ParsingHelper.parseIntMethod(map['eventscheduletype']);
    activityid = ParsingHelper.parseStringMethod(map['activityid']);
    bigint4 = ParsingHelper.parseStringMethod(map['bigint4']);
    eventresourcedisplayoption = ParsingHelper.parseStringMethod(map['eventresourcedisplayoption']);
    contentauthordisplayname = ParsingHelper.parseStringMethod(map['contentauthordisplayname']);
    videointroduction = ParsingHelper.parseStringMethod(map['videointroduction']);
    noofmodules = ParsingHelper.parseStringMethod(map['noofmodules']);
    learningobjectives = ParsingHelper.parseStringMethod(map['learningobjectives']);
    tableofcontent = ParsingHelper.parseStringMethod(map['tableofcontent']);
    tagname = ParsingHelper.parseStringMethod(map['tagname']);
    eventcategories = ParsingHelper.parseStringMethod(map['eventcategories']);
    eventrecording = ParsingHelper.parseBoolMethod(map['eventrecording']);
    recordingmsg = ParsingHelper.parseStringMethod(map['recordingmsg']);
    recordingcontentid = ParsingHelper.parseStringMethod(map['recordingcontentid']);
    recordingurl = ParsingHelper.parseStringMethod(map['recordingurl']);
    ispinned = ParsingHelper.parseBoolMethod(map['ispinned']);
    gradient1 = ParsingHelper.parseStringMethod(map['gradient1']);
    gradient2 = ParsingHelper.parseStringMethod(map['gradient2']);
    relatedContentCount = ParsingHelper.parseIntMethod(map['relatedconentcount']);
    trackconentcount = ParsingHelper.parseIntMethod(map['trackconentcount']);
    publishedon = ParsingHelper.parseStringMethod(map['publishedon']);
    relatedconentcount1 = ParsingHelper.parseIntMethod(map['relatedconentcount1']);
    trackconentcount1 = ParsingHelper.parseIntMethod(map['trackconentcount1']);
    joinurl = ParsingHelper.parseStringMethod(map['joinurl']);
    jwvideokey = ParsingHelper.parseStringMethod(map['jwvideokey']);
    cloudmediaplayerkey = ParsingHelper.parseStringMethod(map['cloudmediaplayerkey']);
    isaddedtomylearning = ParsingHelper.parseIntMethod(map['isaddedtomylearning']);
    eventstartdatedisplay = ParsingHelper.parseStringMethod(map['eventstartdatedisplay']);
    eventenddatedisplay = ParsingHelper.parseStringMethod(map['eventenddatedisplay']);
    userid = ParsingHelper.parseStringMethod(map['userid']);
    iswishlistcontent = ParsingHelper.parseIntMethod(map['iswishlistcontent']);
    actionwaitlist = ParsingHelper.parseStringMethod(map['actionwaitlist']);
    isbadcancellationenabled = ParsingHelper.parseBoolMethod(map['isbadcancellationenabled']);
    viewprerequisitecontentstatus = ParsingHelper.parseStringMethod(map['viewprerequisitecontentstatus']);
    instanceparentcontentid = ParsingHelper.parseStringMethod(map['instanceparentcontentid']);
    suggesttoconnlink = ParsingHelper.parseStringMethod(map['suggesttoconnlink']);
    suggestwithfriendlink = ParsingHelper.parseStringMethod(map['suggestwithfriendlink']);
    isContentEnrolled = ParsingHelper.parseStringMethod(map['isContentEnrolled']);
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectid'] = objectid;
    data['location'] = location;
    data['locationname'] = locationname;
    data['sortlocation'] = sortlocation;
    data['eventfulllocation'] = eventfulllocation;
    data['orgunitid'] = orgunitid;
    data['sitename'] = sitename;
    data['assigntoouon'] = assigntoouon;
    data['componentid'] = componentid;
    data['description'] = description;
    data['contenttype'] = contenttype;
    data['backgroundcolor'] = backgroundcolor;
    data['fontcolor'] = fontcolor;
    data['iconpath'] = iconpath;
    data['iscontent'] = iscontent;
    data['objecttypeid1'] = objecttypeid1;
    data['contenttypethumbnail'] = contenttypethumbnail;
    data['contentid'] = contentid;
    data['name'] = name;
    data['language'] = language;
    data['defaultlanguage'] = defaultlanguage;
    data['shortdescription'] = shortdescription;
    data['version'] = version;
    data['startpage'] = startpage;
    data['createduserid'] = createduserid;
    data['createddate'] = createddate;
    data['keywords'] = keywords;
    data['downloadable'] = downloadable;
    data['publisheddate'] = publisheddate;
    data['status'] = status;
    data['cmsgroupid'] = cmsgroupid;
    data['checkedoutto'] = checkedoutto;
    data['longdescription'] = longdescription;
    data['mediatypeid'] = mediatypeid;
    data['owner'] = owner;
    data['publicationdate'] = publicationdate;
    data['activatedate'] = activatedate;
    data['expirydate'] = expirydate;
    data['thumbnailimagepath'] = thumbnailimagepath;
    data['ecommbussinessrule'] = ecommbussinessrule;
    data['downloadfile'] = downloadfile;
    data['saleprice'] = saleprice;
    data['listprice'] = listprice;
    data['folderpath'] = folderpath;
    data['skinid'] = skinid;
    data['folderid'] = folderid;
    data['modifieduserid'] = modifieduserid;
    data['modifieddate'] = modifieddate;
    data['author'] = author;
    data['viewtype'] = viewtype;
    data['windowproperties'] = windowproperties;
    data['currency'] = currency;
    data['certificatepage'] = certificatepage;
    data['certificateid'] = certificateid;
    data['launchwindowmode'] = launchwindowmode;
    data['scoid'] = scoid;
    data['active'] = active;
    data['hardwaretype'] = hardwaretype;
    data['enrollmentlimit'] = enrollmentlimit;
    data['presenterurl'] = presenterurl;
    data['participanturl'] = participanturl;
    data['eventstartdatetime'] = eventstartdatetime;
    data['eventenddatetime'] = eventenddatetime;
    data['presenterid'] = presenterId;
    data['contentstatus'] = contentstatus;
    data['location1'] = location1;
    data['conferencenumbers'] = conferencenumbers;
    data['directionurl'] = directionurl;
    data['eventpercentage'] = eventpercentage;
    data['starttime'] = starttime;
    data['duration'] = duration;
    data['personalizediconid1'] = personalizediconid1;
    data['personalizediconid2'] = personalizediconid2;
    data['availableseats'] = availableseats;
    data['ciid'] = ciid;
    data['noofusersenrolled'] = noofusersenrolled;
    data['noofuserscompleted'] = noofuserscompleted;
    data['outputtype'] = outputtype;
    data['contentsize'] = contentsize;
    data['downloadsize'] = downloadsize;
    data['eventkey'] = eventkey;
    data['eventtype'] = eventtype;
    data['devicetypeid'] = devicetypeid;
    data['nvarchar2'] = nvarchar2;
    data['nvarchar3'] = nvarchar3;
    data['audience'] = audience;
    data['searchreferencenumber'] = searchreferencenumber;
    data['nvarchar4'] = nvarchar4;
    data['membershiplevel'] = membershiplevel;
    data['membershipname'] = membershipname;
    data['timezone'] = timezone;
    data['ratingid'] = ratingid;
    data['totalratings'] = totalratings;
    data['totalenrolls'] = totalenrolls;
    data['objectdisplayorder'] = objectdisplayorder;
    data['medianame'] = medianame;
    data['bigint3'] = bigint3;
    data['nvarchar1'] = nvarchar1;
    data['typeofevent'] = typeofevent;
    data['webinartool'] = webinartool;
    data['webinarpassword'] = webinarpassword;
    data['seotitle'] = seotitle;
    data['seometadescription'] = seometadescription;
    data['seokeywords'] = seokeywords;
    data['waitlistlimit'] = waitlistlimit;
    data['waitlistenrolls'] = waitlistenrolls;
    data['totalattempts'] = totalattempts;
    data['authordisplayname'] = authordisplayname;
    data['accessperiodtype'] = accessperiodtype;
    data['itunesproductid'] = itunesproductid;
    data['googleproductid'] = googleproductid;
    data['decimal2'] = decimal2;
    data['credittypes'] = credittypes;
    data['budgetprice'] = budgetprice;
    data['budgetcurrency'] = budgetcurrency;
    data['locationname1'] = locationname1;
    data['eventscheduletype'] = eventscheduletype;
    data['activityid'] = activityid;
    data['bigint4'] = bigint4;
    data['eventresourcedisplayoption'] = eventresourcedisplayoption;
    data['contentauthordisplayname'] = contentauthordisplayname;
    data['videointroduction'] = videointroduction;
    data['noofmodules'] = noofmodules;
    data['learningobjectives'] = learningobjectives;
    data['tableofcontent'] = tableofcontent;
    data['tagname'] = tagname;
    data['eventcategories'] = eventcategories;
    data['eventrecording'] = eventrecording;
    data['recordingmsg'] = recordingmsg;
    data['recordingcontentid'] = recordingcontentid;
    data['recordingurl'] = recordingurl;
    data['ispinned'] = ispinned;
    data['gradient1'] = gradient1;
    data['gradient2'] = gradient2;
    data['relatedconentcount'] = relatedContentCount;
    data['trackconentcount'] = trackconentcount;
    data['publishedon'] = publishedon;
    data['relatedconentcount1'] = relatedconentcount1;
    data['trackconentcount1'] = trackconentcount1;
    data['joinurl'] = joinurl;
    data['jwvideokey'] = jwvideokey;
    data['cloudmediaplayerkey'] = cloudmediaplayerkey;
    data['isaddedtomylearning'] = isaddedtomylearning;
    data['eventstartdatedisplay'] = eventstartdatedisplay;
    data['eventenddatedisplay'] = eventenddatedisplay;
    data['userid'] = userid;
    data['iswishlistcontent'] = iswishlistcontent;
    data['actionwaitlist'] = actionwaitlist;
    data['isbadcancellationenabled'] = isbadcancellationenabled;
    data['viewprerequisitecontentstatus'] = viewprerequisitecontentstatus;
    data['instanceparentcontentid'] = instanceparentcontentid;
    data['suggesttoconnlink'] = suggesttoconnlink;
    data['suggestwithfriendlink'] = suggestwithfriendlink;
    data['isContentEnrolled'] = isContentEnrolled;
    return data;
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
*/
