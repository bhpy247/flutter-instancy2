import 'package:flutter_instancy_2/backend/app/app_controller.dart';
import 'package:flutter_instancy_2/backend/configurations/app_configuration_operations.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/models/course_offline/data_model/cmi_model.dart';
import 'package:flutter_instancy_2/models/course_offline/data_model/learner_session_model.dart';
import 'package:flutter_instancy_2/models/course_offline/data_model/student_response_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/track_course_dto_model.dart';
import 'package:flutter_instancy_2/utils/date_representation.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class CourseOfflineSQLDatabaseHandler {
  //region tables

  /// TO store the my learning content metadata details
  static const String TBL_DOWNLOAD_DATA = 'DOWNLOADDATA';

  /// To store the user session details which tracked in offline course viewing
  static const String TBL_USER_SESSION = 'USERSESSION';

  /// To store the student responses which tracked in offline course viewing
  static const String TBL_STUDENT_RESPONSES = 'STUDENTRESPONSES';

  /// To store the offline tracking data
  static const String TBL_CMI = 'CMI';

  /// To store the track list content object details(track & content relation)
  static const String TBL_TRACK_OBJECTS = 'TRACKOBJECTS';

  /// To store the track list content metadata details
  static const String TBL_TRACKLIST_DATA = 'TRACKLISTDATA';

  static const String TBL_RELATED_CONTENT_DATA = 'RELATEDCONTENTDATA';
  //endregion tables

  static CourseOfflineSQLDatabaseHandler? _databaseHandler;
  static Database? _database;
  static bool _isInitializingDatabase = false;

  factory CourseOfflineSQLDatabaseHandler() {
    if (_databaseHandler == null) {
      _databaseHandler = CourseOfflineSQLDatabaseHandler._internal();
      init();
    }
    return _databaseHandler!;
  }

  CourseOfflineSQLDatabaseHandler._internal();

  static Future<bool> init() async {
    bool isSuccess = false;

    if (_database == null) {
      if (_isInitializingDatabase) {
        return isSuccess;
      }

      _isInitializingDatabase = true;

      try {
        _database = await openDatabase(
          path.join(await getDatabasesPath(), 'instancy_mylearning.db'),
          onOpen: (database) async => await database.execute('PRAGMA foreign_keys = ON'),
          onCreate: (db, version) async {
            await db.execute(
                'CREATE TABLE IF NOT EXISTS $TBL_DOWNLOAD_DATA (ID INTEGER PRIMARY KEY AUTOINCREMENT,username TEXT,userid TEXT,siteid TEXT,siteurl TEXT,sitename TEXT,contentid TEXT,objectid TEXT,coursename TEXT,author TEXT,shortdes TEXT,longdes TEXT,imagedata TEXT,medianame TEXT,createddate TEXT,startpage TEXT,eventstarttime TEXT,eventendtime TEXT,objecttypeid TEXT,locationname TEXT,timezone TEXT,scoid TEXT,participanturl TEXT,status TEXT,displaystatus TEXT,password TEXT,displayname TEXT,islistview TEXT,isdownloaded TEXT,courseattempts TEXT,eventcontentid TEXT,relatedcontentcount TEXT,durationenddate TEXT,ratingid TEXT,publisheddate TEXT,isExpiry TEXT, mediatypeid TEXT, dateassigned TEXT, keywords TEXT,tagname TEXT, downloadurl TEXT, offlinepath TEXT, presenter TEXT, eventaddedtocalender TEXT, joinurl TEXT, typeofevent TEXT,progress TEXT, membershiplevel INTEGER, membershipname TEXT ,folderpath TEXT,jwvideokey TEXT, cloudmediaplayerkey TEXT,eventstartUtctime TEXT,eventendUtctime TEXT,isarchived BOOLEAN,isRequired BOOLEAN,contentTypeImagePath TEXT,EventScheduleType INTEGER,LearningObjectives TEXT,TableofContent TEXT,LongDescription TEXT,ThumbnailVideoPath TEXT,totalratings INTEGER,groupName TEXT,activityid TEXT,cancelEventEnabled BOOLEAN,removeFromMylearning BOOLEAN,reSheduleEvent TEXT,isBadCancellationEnabled BOOLEAN,isEnrollFutureInstance BOOLEAN,percentcompleted TEXT,certificateaction TEXT,certificateid TEXT,certificatepage TEXT,windowproperties TEXT,bit4 BOOLEAN,qrCodeImagePath TEXT,QRImageName TEXT,offlineQrCodeImagePath TEXT,viewprerequisitecontentstatus TEXT,credits TEXT,decimal2 TEXT,duration TEXT ,recordingmsg  TEXT,eventrecording  TEXT,recordingcontentid TEXT,recordingurl TEXT,fileSize INTEGER,jwstartPage TEXT)');

            await db.execute(
                'CREATE TABLE IF NOT EXISTS $TBL_USER_SESSION (sessionid INTEGER PRIMARY KEY AUTOINCREMENT,userid INTEGER,scoid INTEGER,siteid INTEGR,attemptnumber INTEGER,sessiondatetime DATETIME,timespent TEXT)');

            await db.execute(
                'CREATE TABLE IF NOT EXISTS $TBL_STUDENT_RESPONSES (RESPONSEID INTEGER PRIMARY KEY AUTOINCREMENT,siteid INTEGER,scoid INTEGER,userid INTEGER,questionid INTEGER,assessmentattempt INTEGER,questionattempt INTEGER,attemptdate DATETIME,studentresponses TEXT,result TEXT,attachfilename TEXT,attachfileid TEXT,rindex INTEGER,attachedfilepath TEXT,optionalNotes TEXT,capturedVidFileName TEXT,capturedVidId TEXT,capturedVidFilepath TEXT,capturedImgFileName TEXT,capturedImgId TEXT,capturedImgFilepath TEXT)');

            await db.execute(
                'CREATE TABLE IF NOT EXISTS $TBL_CMI (ID INTEGER PRIMARY KEY AUTOINCREMENT,siteid INTEGER,scoid INTEGER,userid INTEGER,location TEXT,status TEXT,suspenddata TEXT,isupdate TEXT,siteurl TEXT,datecompleted DATETIME,noofattempts INTEGER,score TEXT,sequencenumber INTEGER,startdate DATETIME,timespent TEXT,coursemode TEXT,scoremin TEXT,scoremax TEXT,submittime TEXT,randomquesseq TEXT,pooledquesseq TEXT,textResponses TEXT, objecttypeid TEXT,percentageCompleted TEXT)');

            await db.execute(
                'CREATE TABLE IF NOT EXISTS $TBL_TRACK_OBJECTS (RESPONSEID INTEGER PRIMARY KEY AUTOINCREMENT,trackscoid INTEGER,scoid INTEGER,sequencenumber INTEGER,siteid INTEGER,userid INTEGER,objecttypeid INTEGER,name TEXT,mediatypeid TEXT)');

            await db.execute(
                'CREATE TABLE IF NOT EXISTS $TBL_TRACKLIST_DATA (ID INTEGER PRIMARY KEY AUTOINCREMENT,username TEXT,userid INTEGER,siteid INTEGER,siteurl TEXT,sitename TEXT,contentid TEXT,coursename TEXT,author TEXT,shortdes TEXT,longdes TEXT,imagedata TEXT,medianame TEXT,createddate DATE,startpage TEXT,eventstarttime DATE,eventendtime DATE,objecttypeid INTEGER,locationname TEXT,timezone TEXT,scoid INTEGER,participanturl TEXT,courselaunchpath TEXT,status TEXT,displaystatus TEXT,password TEXT,eventid TEXT,displayname TEXT,trackscoid TEXT,parentid TEXT,blockname TEXT,showstatus TEXT,timedelay TEXT,isdiscussion TEXT,eventcontentid TEXT, sequencenumber TEXT,courseattempts TEXT,mediatypeid TEXT, relatedcontentcount INTEGER, downloadurl TEXT,eventaddedtocalender TEXT, joinurl TEXT,offlinepath TEXT, typeofevent INTEGER,presenter TEXT,isdownloaded TEXT, progress TEXT, stepid  TEXT, ruleid  TEXT,wmessage TEXT,trackContentId TEXT,folderpath TEXT,jwvideokey TEXT, cloudmediaplayerkey TEXT,eventstartUtctime TEXT,eventendUtctime TEXT,contentTypeImagePath TEXT,activityid TEXT,bookmarkid INTEGER,recordingmsg  TEXT,eventrecording  TEXT,recordingcontentid TEXT,recordingurl TEXT,jwstartPage TEXT,objectfolderid TEXT)');

            await db.execute(
                'CREATE TABLE IF NOT EXISTS $TBL_RELATED_CONTENT_DATA (ID INTEGER PRIMARY KEY AUTOINCREMENT,username TEXT,userid TEXT,siteid TEXT,siteurl TEXT,sitename TEXT,contentid TEXT,coursename TEXT,author TEXT,shortdes TEXT,longdes TEXT,imagedata TEXT,medianame TEXT,createddate TEXT,startpage TEXT,eventstarttime TEXT,eventendtime TEXT,objecttypeid TEXT,locationname TEXT,timezone TEXT,scoid TEXT,participanturl TEXT,status TEXT,displaystatus TEXT,password TEXT,displayname TEXT,islistview TEXT,isdiscussion TEXT,isdownloaded TEXT,courseattempts TEXT,eventcontentid TEXT,wresult TEXT, wmessage TEXT, durationenddate TEXT, isExpiry TEXT, ratingid TEXT, publisheddate TEXT,mediatypeid TEXT,dateassigned TEXT, keywords TEXT,tagname TEXT, downloadurl TEXT, offlinepath TEXT, presenter TEXT, joinurl TEXT,blockname TEXT,trackscoid TEXT, progress TEXT, showstatus TEXT,trackContentId TEXT, stepid  TEXT, ruleid  TEXT,folderpath TEXT,jwvideokey TEXT, cloudmediaplayerkey TEXT,eventstartUtctime TEXT,eventendUtctime TEXT,contentTypeImagePath TEXT,activityid TEXT,recordingmsg  TEXT,eventrecording  TEXT,recordingcontentid TEXT,recordingurl TEXT,jwstartPage TEXT,objectfolderid TEXT)');

            MyPrint.printOnConsole('init:  TABLES CREATED');
          },
          version: 1,
        );

        isSuccess = true;
      } catch (e, s) {
        MyPrint.printOnConsole("Error in Initializing SQL Database:$e");
        MyPrint.printOnConsole(s);
      }

      _isInitializingDatabase = false;
    } else {
      isSuccess = true;
    }

    return isSuccess;
  }

  Future<({String requestString, LearnerSessionModel? learnerSessionModel})> generateOfflinePathForCourseView({
    required int SiteId,
    required int ScoID,
    required int UserID,
    required int ContentTypeId,
  }) async {
    ({String requestString, LearnerSessionModel? learnerSessionModel}) response = (requestString: "", learnerSessionModel: null);

    if (!(await init())) return response;

    try {
      // String downloadDestFolderPath = mylearningModel.offlinepath ?? '';

      // String offlineCourseLaunch = "";

      // if (downloadDestFolderPath.contains("file:")) {
      //   offlineCourseLaunch = downloadDestFolderPath;
      // } else {
      //   offlineCourseLaunch = "file://" + downloadDestFolderPath;
      // }

      String requestString = "";
      String query = "";
      String question = "";

      String locationValue = "";
      String statusValue = "";
      String suspendDataValue = "";
      String sequenceNumberValue = "1";

      int flag = 0;

      String getCourseProgress = "SELECT location,status,suspenddata,sequencenumber,CourseMode FROM CMI WHERE "
          "siteid =$SiteId AND "
          "scoid = $ScoID AND "
          "userid = $UserID";
      MyPrint.printOnConsole("getCourseProgress query:$getCourseProgress");
      List<Map<String, dynamic>> data = await _database!.rawQuery(getCourseProgress);

      MyPrint.printOnConsole("getCourseProgress data:$data");

      if (data.isNotEmpty) {
        for (Map<String, dynamic> item in data) {
          flag = 1;
          locationValue = '${item['location']}';
          statusValue = '${item['status']}';
          suspendDataValue = '${item['suspenddata']}';
          sequenceNumberValue = '${item['sequencenumber']}';

          if (int.tryParse(sequenceNumberValue) == null) {
            sequenceNumberValue = "1";
          }
        }
        suspendDataValue = suspendDataValue.replaceAll("#", "%23");

        if (flag == 1) {
          if (ContentTypeId == InstancyObjectTypes.track) {
            // query = await getTrackObjectList(courseDTOModel, statusValue, suspendDataValue, sequenceNumberValue);
          } else if ([InstancyObjectTypes.contentObject, InstancyObjectTypes.assessment].contains(ContentTypeId)) {
            String assessmentAttempt = "";
            try {
              String sqlQuery = "SELECT noofattempts FROM CMI WHERE SITEID = $SiteId AND SCOID = $ScoID AND USERID = $UserID";

              List<Map<String, dynamic>> data = await _database!.rawQuery(sqlQuery);

              if (data.isNotEmpty) {
                for (Map<String, dynamic> item in data) {
                  assessmentAttempt = '${item['noofattempts']}';
                  if (equalsIgnoreCase(assessmentAttempt, "0") || assessmentAttempt.isEmpty) {
                    assessmentAttempt = "1";
                  }
                }
              }
            } catch (e) {
              MyPrint.printOnConsole('generateOfflinePathForCourseView failed: $e');
            }

            if (!equalsIgnoreCase(assessmentAttempt, "0")) {
              try {
                String sqlQuery =
                    "select QUESTIONID,studentresponses,Result,attachfilename,attachfileid,optionalNotes,capturedVidFileName,capturedVidId,capturedImgFileName,capturedImgId from $TBL_STUDENT_RESPONSES WHERE SITEID = $SiteId AND SCOID = $ScoID AND USERID = $UserID AND QuestionAttempt = 1";

                List<Map<String, dynamic>> data = await _database!.rawQuery(sqlQuery);

                if (data.isNotEmpty) {
                  for (Map<String, dynamic> item in data) {
                    if (question.isNotEmpty) {
                      question = "$question\$";
                    }

                    String questionID = '${item['questionid']}';

                    if (!equalsIgnoreCase(questionID, "null") && questionID.isNotEmpty) {
                      question = '$question$questionID@';
                    }

                    String studentResponse = "";
                    String studentresp = item['studentresponses'];

                    if (!equalsIgnoreCase(studentresp, "null") && studentresp.isNotEmpty) {
                      if ((equalsIgnoreCase(studentresp, "undefined")) || equalsIgnoreCase(studentResponse, "null")) {
                        studentResponse = "";
                      } else {
                        studentResponse = studentresp;
                      }
                    }
                    question = '$question$studentResponse@';

                    String result = item['result'];

                    if (!equalsIgnoreCase(result, "null") && result.isNotEmpty) {
                      question = '$question$result@';
                    }

                    String attachFile = item['attachfilename'];

                    if (!equalsIgnoreCase(attachFile, "null") && attachFile.isNotEmpty) {
                      question = '$question$attachFile@';
                    }

                    String attachFileID = item['attachfileid'];

                    if (!equalsIgnoreCase(attachFileID, "null") && attachFileID.isNotEmpty) {
                      question = '$question$attachFileID@';
                    }

                    String optionalNotes = item['optionalNotes'];

                    if (!equalsIgnoreCase(optionalNotes, "null") && optionalNotes.isNotEmpty) {
                      question = '$question$optionalNotes@';
                    }

                    String capturedVidFileName = item['capturedVidFileName'];

                    if (!equalsIgnoreCase(capturedVidFileName, "null") && capturedVidFileName.isNotEmpty) {
                      question = '$question$capturedVidFileName@';
                    }

                    String capturedVidID = item['capturedVidId'];

                    if (!equalsIgnoreCase(capturedVidID, "null") && capturedVidID.isNotEmpty) {
                      question = '$question$capturedVidID@';
                    }

                    String capturedImgFileName = item['capturedImgFileName'];

                    if (!equalsIgnoreCase(capturedImgFileName, "null") && capturedImgFileName.isNotEmpty) {
                      question = '$question$capturedImgFileName@';
                    }

                    String capturedImgID = item['capturedImgId'];

                    if (!equalsIgnoreCase(capturedImgID, "null") && capturedImgID.isNotEmpty) {
                      question = '$question$capturedImgID@';
                    }
                  }
                }
              } catch (e) {
                MyPrint.printOnConsole('generateOfflinePathForCourseView $e');
              }
              question = question.replaceAll("null", "");

              query = "cid=$ScoID&stid=$UserID&lloc=$locationValue&lstatus=$statusValue&susdata=$suspendDataValue&quesdata=$question&sname=";
            } else {
              query = "cid=$ScoID&stid=$UserID&lloc=$locationValue&lstatus=$statusValue&susdata=$suspendDataValue&sname=";
            }
          }
        } else {
          sequenceNumberValue = "1";
          query = "cid=$ScoID&stid=$UserID&lloc=$locationValue&lstatus=$statusValue&susdata=$suspendDataValue&quesdata=$question&sname=";
        }
      }
      //      not required for now
      bool isSessionExists = false;
      int numberOfAttemptsInt = 0;
//            var timeSpent = "00:00:00"
      String sqlQuery = "SELECT count(sessionid) as attemptscount FROM $TBL_USER_SESSION WHERE siteid = $SiteId AND scoid = '$ScoID' AND userid = $UserID";

      List<Map<String, dynamic>> data2 = await _database!.rawQuery(sqlQuery);
      try {
        if (data2.isNotEmpty) {
          for (Map<String, dynamic> item in data2) {
            isSessionExists = true;
            String counts = '${item['attemptscount']}';
            numberOfAttemptsInt = int.parse(counts);
            numberOfAttemptsInt = numberOfAttemptsInt + 1;
          }
        }
      } catch (e) {
        MyPrint.printOnConsole('failed to parse attemptscount $e');
      }

      LearnerSessionModel? learnerSessionModel;

      if (isSessionExists) {
        learnerSessionModel = LearnerSessionModel();
        if (ContentTypeId == InstancyObjectTypes.track) {
          ({int ContentTypeId, int ScoId})? trackObjectTypeIDAndScoIdResponse = await getTrackObjectTypeIDAndScoidBasedOnSequenceNumber(
            ScoID: ScoID,
            SiteId: ScoID,
            UserID: ScoID,
            seqNumber: sequenceNumberValue,
          );
          int objectScoidValue = trackObjectTypeIDAndScoIdResponse?.ScoId ?? 0;

          int latestAttemptNo = await getLatestAttempt(
            scoId: objectScoidValue.toString(),
            userId: UserID.toString(),
            siteID: SiteId.toString(),
          );

          learnerSessionModel.scoid = objectScoidValue;

          learnerSessionModel.attemptnumber = latestAttemptNo;
        } else {
          learnerSessionModel.scoid = ScoID;
          learnerSessionModel.attemptnumber = numberOfAttemptsInt;
        }

        learnerSessionModel.siteid = SiteId;
        learnerSessionModel.userid = UserID;
        learnerSessionModel.sessiondatetime = getCurrentDateTime();

        await insertUserSession(sessionDetails: learnerSessionModel);
      }

      query = query.replaceAll("#", "%23");
      String instancyContent = 'IsInstancyContent=true';
      if (ContentTypeId == InstancyObjectTypes.scorm1_2) {
        instancyContent = 'IsInstancyContent=false';
      }

      if (query.isNotEmpty) {
        requestString = "$query&$instancyContent&nativeappURL=true";
      } else {
        requestString = 'nativeappURL=true&'
            '$instancyContent&'
            'cid=$ScoID&'
            'stid=$UserID&'
            'tbookmark=&'
            'lloc=&'
            'lstatus=&'
            'susdata=&'
            'quesdata=null&'
            'score=&'
            'LtSusdata=&'
            'LtStatus=&'
            'LtQuesData=&'
            'sname=';
      }

      MyPrint.printOnConsole("generateOfflinePathForCourseView requestString: $requestString");

      response = (
        requestString: requestString,
        learnerSessionModel: learnerSessionModel,
      );

      return response;
    } catch (e) {
      MyPrint.printOnConsole('generateOfflinePathForCourseView failed: $e');
      return response;
    }
  }

  bool equalsIgnoreCase(String string1, String string2) {
    return string1.toLowerCase() == string2.toLowerCase();
  }

  Future<void> injectMyLearningIntoTable({required CourseDTOModel courseDTOModel}) async {
    if (!(await init())) return;

    try {
      bool isExists = await isContentExists(courseDTOModel: courseDTOModel, tableName: TBL_DOWNLOAD_DATA);
      if (isExists) return;

      String query = 'INSERT INTO $TBL_DOWNLOAD_DATA ('
          'username,'
          'userid,'
          'siteid,'
          'siteurl,'
          'sitename,'
          'contentid,'
          'objectid,'
          'coursename,'
          'author,'
          'shortdes,'
          'longdes,'
          'imagedata,'
          'medianame,'
          'createddate,'
          'startpage,'
          'eventstarttime,'
          'eventendtime,'
          'objecttypeid,'
          'locationname,'
          'timezone,'
          'scoid,'
          'participanturl,'
          'status,'
          'displaystatus,'
          'password,'
          'displayname,'
          'islistview,'
          'isdownloaded,'
          'courseattempts,'
          'eventcontentid,'
          'relatedcontentcount,'
          'durationenddate,'
          'ratingid,'
          'publisheddate,'
          'isExpiry,'
          'mediatypeid,'
          'dateassigned,'
          'keywords,'
          'tagname,'
          'downloadurl,'
          'offlinepath,'
          'presenter,'
          'eventaddedtocalender,'
          'joinurl,'
          'typeofevent,'
          'progress,'
          'membershiplevel,'
          'membershipname ,'
          'folderpath,'
          'jwvideokey,'
          'cloudmediaplayerkey,'
          'eventstartUtctime,'
          'eventendUtctime,'
          'isarchived,'
          'isRequired,'
          'contentTypeImagePath,'
          'EventScheduleType,'
          'LearningObjectives,'
          'TableofContent,'
          'LongDescription,'
          'ThumbnailVideoPath,'
          'totalratings,'
          'groupName,'
          'activityid,'
          'cancelEventEnabled,'
          'removeFromMylearning,'
          'reSheduleEvent,'
          'isBadCancellationEnabled,'
          'isEnrollFutureInstance,'
          'percentcompleted,'
          'certificateaction,'
          'certificateid,'
          'certificatepage,'
          'windowproperties,'
          'bit4,'
          'qrCodeImagePath,'
          'QRImageName,'
          'offlineQrCodeImagePath,'
          'viewprerequisitecontentstatus,'
          'credits,'
          'decimal2,'
          'duration,'
          'recordingmsg,'
          'eventrecording,'
          'recordingcontentid,'
          'recordingurl,'
          'fileSize,'
          'jwstartPage'
          ') VALUES ('
          '\'\','
          '\'${courseDTOModel.SiteUserID}\','
          '\'${courseDTOModel.SiteId}\','
          '\'\','
          '\'${courseDTOModel.SiteName}\','
          '\'${courseDTOModel.ContentID}\','
          '\'${courseDTOModel.ContentID}\','
          '\'${courseDTOModel.ContentName}\','
          '\'${courseDTOModel.AuthorDisplayName}\','
          '\'${courseDTOModel.ShortDescription}\','
          '\'${courseDTOModel.LongDescription}\','
          '\'${courseDTOModel.ThumbnailImagePath}\','
          '\'${courseDTOModel.ContentType}\','
          '\'\','
          '\'${courseDTOModel.startpage}\','
          '\'${courseDTOModel.EventStartDateTime}\','
          '\'${courseDTOModel.EventEndDateTime}\','
          '\'${courseDTOModel.ContentTypeId}\','
          '\'${courseDTOModel.LocationName}\','
          '\'${courseDTOModel.TimeZone}\','
          '\'${courseDTOModel.ScoID}\','
          '\'${courseDTOModel.JoinURL}\','
          '\'${courseDTOModel.ActualStatus}\','
          '\'${courseDTOModel.ContentStatus}\','
          '\'\','
          '\'\','
          '\'\','
          '\'\','
          '\'\','
          '\'\','
          '\'\','
          '\'${courseDTOModel.DurationEndDate}\','
          '\'${courseDTOModel.RatingID}\','
          '\'\','
          '\'${courseDTOModel.Expired}\','
          '\'${courseDTOModel.MediaTypeID}\','
          '\'\','
          '\'\','
          '\'${courseDTOModel.Tags}\','
          '\'\','
          '\'\','
          '\'${courseDTOModel.PresenterDisplayName}\','
          '\'\','
          '\'${courseDTOModel.JoinURL}\','
          '\'${courseDTOModel.TypeofEvent}\','
          '\'${courseDTOModel.PercentCompleted}\','
          ','
          '\'${courseDTOModel.MembershipName}\','
          '\'${courseDTOModel.FolderPath}\','
          '\'${courseDTOModel.JWVideoKey}\','
          '\'\','
          '\'\','
          '\'${courseDTOModel.EventEndDateTimeTimeWithoutConvert}\','
          '${courseDTOModel.IsArchived},'
          ','
          '\'\','
          '${courseDTOModel.EventScheduleType},'
          '\'${courseDTOModel.LearningObjectives}\','
          '\'${courseDTOModel.TableofContent}\','
          '\'${courseDTOModel.LongDescription}\','
          '\'${courseDTOModel.ThumbnailVideoPath}\','
          '${courseDTOModel.TotalRatings},'
          '\'\','
          '\'${courseDTOModel.ActivityId}\','
          ','
          ','
          '\'${courseDTOModel.ReScheduleEvent}\','
          '${courseDTOModel.isBadCancellationEnabled},'
          '${courseDTOModel.isEnrollFutureInstance},'
          '\'${courseDTOModel.PercentCompleted}\','
          '\'\','
          '\'\','
          '\'\','
          '\'${courseDTOModel.WindowProperties}\','
          '${courseDTOModel.bit4},'
          '\'\','
          '\'${courseDTOModel.QRImageName}\','
          '\'\','
          '\'\','
          '\'${courseDTOModel.Credits}\','
          '\'\','
          '\'${courseDTOModel.Duration}\','
          '\'${courseDTOModel.RecordingDetails?.EventRecordingMessage ?? ""}\','
          '\'${courseDTOModel.EventRecording}\','
          '\'${courseDTOModel.RecordingDetails?.ContentID ?? ""}\','
          '\'${courseDTOModel.RecordingDetails?.EventRecordingURL ?? ""}\','
          ','
          '\'${courseDTOModel.jwstartpage}\''
          ')';
      await _database!.rawQuery(query);
    } catch (e) {
      MyPrint.printOnConsole('injectMyLearningIntoTable failed: $e');
    }
  }

  /*Future<void> injectTrackListIntoTable({required CourseDTOModel courseDTOModel}) async {
    if (!(await init())) return;

    try {
      bool isExists = await isContentExists(courseDTOModel: courseDTOModel, tableName: TBL_TRACKLIST_DATA);
      if (isExists) return;

      String query = 'INSERT INTO $TBL_TRACKLIST_DATA ('
          'username,'
          'siteid,'
          'userid,'
          'scoid,'
          'siteurl,'
          'sitename,'
          'contentid,'
          'coursename,'
          'author,'
          'shortdes,'
          'longdes,'
          'imagedata,'
          'medianame,'
          'createddate,'
          'startpage,'
          'eventstarttime,'
          'eventendtime,'
          'objecttypeid,'
          'locationname,'
          'timezone,'
          'participanturl,'
          'trackscoid,'
          'status,'
          'displaystatus,'
          'eventid,'
          'password,'
          'displayname,'
          'isdownloaded,'
          'courseattempts,'
          'eventcontentid,'
          'relatedcontentcount,'
          'mediatypeid,'
          'downloadurl,'
          'progress,'
          'presenter,'
          'eventaddedtocalender,'
          'joinurl,'
          'typeofevent,'
          'blockname,'
          'showstatus,'
          'parentid,'
          'timedelay,'
          'isdiscussion,'
          'sequencenumber,'
          'courseattempts,'
          'offlinepath,'
          'trackContentId,'
          'ruleid,'
          'stepid,'
          'wmessage,'
          'folderpath,'
          'jwvideokey,'
          'cloudmediaplayerkey,'
          'eventstartUtctime,'
          'eventendUtctime,'
          'contentTypeImagePath,'
          'activityid,'
          'bookmarkid,'
          'recordingmsg,'
          'eventrecording,'
          'recordingcontentid,'
          'recordingurl,'
          'objectfolderid'
          ') VALUES ('
          '\'${trackListModel.userName}\','
          '\'${trackListModel.siteID}\','
          '\'${trackListModel.userID}\','
          '\'${trackListModel.scoid}\','
          '\'${trackListModel.siteURL}\','
          '\'${trackListModel.siteName}\','
          '\'${trackListModel.contentID}\','
          '\'${trackListModel.courseName}\','
          '\'${trackListModel.author}\','
          '\'${trackListModel.shortDes}\','
          '\'${trackListModel.longDes}\','
          '\'${trackListModel.imageData}\','
          '\'${trackListModel.mediaName}\','
          '\'${trackListModel.createdDate}\','
          '\'${trackListModel.startPage}\','
          '\'${trackListModel.eventstartTime}\','
          '\'${trackListModel.eventendTime}\','
          '\'${trackListModel.objecttypeId}\','
          '\'${trackListModel.locationName}\','
          '\'${trackListModel.timeZone}\','
          '\'${trackListModel.participantUrl}\','
          '\'${trackListModel.trackScoid}\','
          '\'${trackListModel.statusActual}\','
          '\'${trackListModel.statusDisplay}\','
          '\'${trackListModel.eventID}\','
          '\'${trackListModel.password}\','
          '\'${trackListModel.displayName}\','
          '\'${trackListModel.isDownloaded}\','
          '\'${trackListModel.courseAttempts}\','
          'false,'
          '\'${trackListModel.relatedContentCount}\','
          '\'${trackListModel.mediatypeId}\','
          '\'${trackListModel.downloadURL}\','
          '\'${trackListModel.progress}\','
          '\'${trackListModel.presenter}\','
          '\'${trackListModel.eventAddedToCalender}\','
          '\'${trackListModel.joinurl}\','
          '\'${trackListModel.typeofevent}\','
          '\'${trackListModel.blockName}\','
          '\'${trackListModel.showStatus}\','
          '\'${trackListModel.parentID}\','
          '\'${trackListModel.timeDelay}\','
          '\'${trackListModel.isDiscussion}\','
          '\'${trackListModel.sequenceNumber}\','
          '\'${trackListModel.courseAttempts}\','
          '\'${trackListModel.offlinepath}\','
          '\'${trackListModel.trackOrRelatedContentID}\','
          '0,'
          '0,'
          '\'\','
          '\'${trackListModel.folderPath}\','
          '\'${trackListModel.jwvideokey}\','
          '\'${trackListModel.cloudmediaplayerkey}\','
          '\'${trackListModel.eventstartUtcTime}\','
          '\'${trackListModel.eventendUtcTime}\','
          '\'${trackListModel.contentTypeImagePath}\','
          '\'${trackListModel.activityId}\','
          '\'${trackListModel.bookmarkID}\','
          '\'${trackListModel.recordingmsg}\','
          '\'${trackListModel.eventrecording}\','
          '\'${trackListModel.recordingcontentid}\','
          '\'${trackListModel.recordingurl}\','
          '\'${trackListModel.objectfolderid}\''
          ')';

      await _database!.rawQuery(query);
      MyPrint.printOnConsole('success');
    } catch (e) {
      MyPrint.printOnConsole('injectTrackListIntoTable failed: $e');
    }
  }

  Future<void> insertTrackObjects({required Map<String, dynamic> jsonResponse, required CourseDTOModel courseDTOModel}) async {
    if (!(await init())) return;

    try {
      List<dynamic> jsonTrackObjects = jsonResponse["table3"];
      List<dynamic> jsonTrackList = jsonResponse["table5"];

      if (jsonTrackObjects.isNotEmpty) {
        ejectRecordsinTrackObjDb(courseDTOModel: courseDTOModel);

        TrackCourseDTOModel trackObjectsModel = TrackCourseDTOModel();
        for (int i = 0; i < jsonTrackObjects.length; i++) {
          Map<dynamic, dynamic> jsonTrackObj = jsonTrackObjects[i];
          MyPrint.printOnConsole("insertTrackObjects: $jsonTrackObj");

          trackObjectsModel.ContentName = ParsingHelper.parseStringMethod(jsonTrackObj["name"]);
          trackObjectsModel.ContentTypeId = ParsingHelper.parseIntMethod(jsonTrackObj["objecttypeid"]);
          trackObjectsModel.ScoID = ParsingHelper.parseIntMethod(jsonTrackObj["scoid"]);
          trackObjectsModel.SequenceID = ParsingHelper.parseIntMethod(jsonTrackObj["sequencenumber"]);
          trackObjectsModel.TrackScoID = ParsingHelper.parseIntMethod(jsonTrackObj["trackscoid"]);
          trackObjectsModel.UserID = courseDTOModel.SiteUserID;
          trackObjectsModel.SiteId = courseDTOModel.SiteId;

          injectIntoTrackObjectsTable(trackObjModel: trackObjectsModel);
        }
      }

      if (jsonTrackList.isNotEmpty) {
        ejectRecordsinTracklistTable(courseDTOModel.SiteId.toString(), courseDTOModel.ScoID.toString(), courseDTOModel.SiteUserID.toString(), true);
        for (int i = 0; i < jsonTrackList.length; i++) {
          Map<dynamic, dynamic> jsonMyLearningColumnObj = jsonTrackList[i];

          CourseDTOModel trackLearningModel = CourseDTOModel();
          // trackscoid
          trackLearningModel.trackScoid = courseDTOModel.scoid.toString();

          // userid
          trackLearningModel.userID = courseDTOModel.userid.toString();

          // username

          trackLearningModel.userName = await sharePrefGetString(sharedPref_username);

          // password
          trackLearningModel.password = await sharePrefGetString(sharedPref_LoginPassword);

          //sitename

          trackLearningModel.siteName = courseDTOModel.sitename;
          // siteurl

          trackLearningModel.siteURL = courseDTOModel.siteurl;

          // siteid

          trackLearningModel.siteID = courseDTOModel.siteid.toString();

          // parentid
          if (jsonMyLearningColumnObj.containsKey("parentid")) {
            trackLearningModel.parentID = jsonMyLearningColumnObj["parentid"].toString();
          }

          //showstatus
          if (jsonMyLearningColumnObj.containsKey("showstatus")) {
            trackLearningModel.showStatus = jsonMyLearningColumnObj["showstatus"].toString();
          } else {
            trackLearningModel.showStatus = "show";
          }
          //timedelay
          if (jsonMyLearningColumnObj.containsKey("timedelay")) {
            trackLearningModel.showStatus = jsonMyLearningColumnObj["timedelay"].toString();
          }
          //isdiscussion
          if (jsonMyLearningColumnObj.containsKey("isdiscussion")) {
            trackLearningModel.isDiscussion = jsonMyLearningColumnObj["isdiscussion"].toString();
          }

          //eventcontendid
          if (jsonMyLearningColumnObj.containsKey("eventcontentid")) {
            trackLearningModel.eventContentid = jsonMyLearningColumnObj["eventcontentid"].toString();
          }

          //eventid
          if (jsonMyLearningColumnObj.containsKey("eventid")) {
            trackLearningModel.eventID = jsonMyLearningColumnObj["eventid"].toString();
          }

          //sequencenumber
          if (jsonMyLearningColumnObj.containsKey("sequencenumber")) {
            int parseInteger = int.parse(jsonMyLearningColumnObj["sequencenumber"].toString());
            trackLearningModel.sequenceNumber = parseInteger;
          }
          // mediatypeid
          if (jsonMyLearningColumnObj.containsKey("mediatypeid")) {
            trackLearningModel.mediatypeId = jsonMyLearningColumnObj["mediatypeid"].toString();
          }
          // relatedcontentcount
          if (jsonMyLearningColumnObj.containsKey("relatedcontentcount")) {
            trackLearningModel.relatedContentCount = jsonMyLearningColumnObj["relatedcontentcount"].toString();
          }

          // coursename
          if (jsonMyLearningColumnObj.containsKey("name")) {
            trackLearningModel.courseName = jsonMyLearningColumnObj["name"].toString();
          }
          // shortdes
          if (jsonMyLearningColumnObj.containsKey("shortdescription")) {
            // Spanned result = fromHtml(
            //     jsonMyLearningColumnObj["shortdescription"].toString());

            trackLearningModel.shortDes = jsonMyLearningColumnObj["shortdescription"].toString();
          }
          // author
          if (jsonMyLearningColumnObj.containsKey("author")) {
            trackLearningModel.author = jsonMyLearningColumnObj["author"].toString();
          }
          // contentID
          if (jsonMyLearningColumnObj.containsKey("contentid")) {
            trackLearningModel.contentID = jsonMyLearningColumnObj["contentid"].toString();
          }
          // createddate
          if (jsonMyLearningColumnObj.containsKey("createddate")) {
            trackLearningModel.createdDate = jsonMyLearningColumnObj["createddate"].toString();
          }
          // displayName
          trackLearningModel.displayName = appBloc.nativeMenuModel.displayname;

          // thumbnailimagepath
          if (jsonMyLearningColumnObj.containsKey("thumbnailimagepath")) {
            String imageurl = jsonMyLearningColumnObj["thumbnailimagepath"];

            if (AppConfigurationOperations.isValidString(imageurl)) {
              trackLearningModel.thumbnailImagePath = imageurl;

              String imagePathSet = "";

              if (appBloc.uiSettingModel.isCloudStorageEnabled == 'true') {
                imagePathSet = imageurl;
              } else {
                imagePathSet = trackLearningModel.siteURL + imageurl;
              }

              trackLearningModel.imageData = imagePathSet;
            } else {
              if (jsonMyLearningColumnObj.containsKey("contenttypethumbnail")) {
                String imageurlContentType = jsonMyLearningColumnObj["contenttypethumbnail"];
                if (AppConfigurationOperations.isValidString(imageurlContentType)) {
                  String imagePathSet = "";

                  if (appBloc.uiSettingModel.isCloudStorageEnabled == 'true') {
                    imagePathSet = imageurlContentType;
                  } else {
                    imagePathSet = trackLearningModel.siteURL + "/content/sitefiles/Images/" + imageurlContentType;
                  }

                  trackLearningModel.imageData = imagePathSet;
                }
              }
            }
          }
          if (jsonMyLearningColumnObj.containsKey("objecttypeid") && jsonMyLearningColumnObj.containsKey("startpage")) {
            String objtId = jsonMyLearningColumnObj["objecttypeid"].toString();
            String startPage = jsonMyLearningColumnObj["startpage"].toString();
            String contentid = jsonMyLearningColumnObj["contentid"].toString();
            String downloadDestFolderPath = await AppDirectory.getDocumentsDirectory() + "/.Mydownloads/Contentdownloads" + "/$contentid-${appBloc.userid}";

            String finalDownloadedFilePath = "$downloadDestFolderPath/$startPage";

            trackLearningModel.offlinepath = finalDownloadedFilePath;
          }

          // relatedcontentcount
          if (jsonMyLearningColumnObj.containsKey("relatedconentcount")) {
            trackLearningModel.relatedContentCount = jsonMyLearningColumnObj["relatedconentcount"].toString();
          }
          // isDownloaded
          if (jsonMyLearningColumnObj.containsKey("isdownloaded")) {
            trackLearningModel.isDownloaded = jsonMyLearningColumnObj["isdownloaded"].toString();
          }
          // courseattempts
          if (jsonMyLearningColumnObj.containsKey("courseattempts")) {
            trackLearningModel.courseAttempts = jsonMyLearningColumnObj["courseattempts"].toString();
          }
          // objecttypeid
          if (jsonMyLearningColumnObj.containsKey("objecttypeid")) {
            trackLearningModel.objecttypeId = jsonMyLearningColumnObj["objecttypeid"].toString();
          }
          // scoid
          if (jsonMyLearningColumnObj.containsKey("scoid")) {
            trackLearningModel.scoid = jsonMyLearningColumnObj["scoid"].toString();
          }
          // startpage
          if (jsonMyLearningColumnObj.containsKey("startpage")) {
            trackLearningModel.startPage = jsonMyLearningColumnObj["startpage"].toString();
          }
          // status
          if (jsonMyLearningColumnObj.containsKey("actualstatus")) {
            trackLearningModel.statusActual = jsonMyLearningColumnObj["actualstatus"].toString();
          }

          if (jsonMyLearningColumnObj.containsKey("corelessonstatus")) {
            trackLearningModel.statusDisplay = jsonMyLearningColumnObj["corelessonstatus"].toString();
          }

          // longdes
          if (jsonMyLearningColumnObj.containsKey("longdescription")) {
            // Spanned result = fromHtml(
            //     jsonMyLearningColumnObj["longdescription"].toString());

            trackLearningModel.longDes = jsonMyLearningColumnObj["longdescription"].toString();
          }
          // typeofevent
          if (jsonMyLearningColumnObj.containsKey("typeofevent")) {
            int typeoFEvent = int.parse(jsonMyLearningColumnObj["typeofevent"].toString());

            trackLearningModel.typeofevent = typeoFEvent;
          }

          // medianame
          if (jsonMyLearningColumnObj.containsKey("medianame")) {
            String medianame = jsonMyLearningColumnObj["medianame"];

            if (!(trackLearningModel.objecttypeId.toLowerCase() == "70")) {
              if (jsonMyLearningColumnObj["medianame"].toString().toLowerCase() == "test") {
                medianame = "Assessment(Test)";
              } else {
                medianame = jsonMyLearningColumnObj["medianame"].toString();
              }
            } else {
              if (trackLearningModel.typeofevent == 2) {
                medianame = "Event (Online)";
              } else if (trackLearningModel.typeofevent == 1) {
                medianame = "Event (Face to Face)";
              }
            }

            trackLearningModel.mediaName = medianame;
          }

          if (jsonMyLearningColumnObj.containsKey("contenttype")) {
            trackLearningModel.mediaName = jsonMyLearningColumnObj["contenttype"].toString();
          }

          // eventstarttime
          if (jsonMyLearningColumnObj.containsKey("eventstartdatedisplay")) {
            trackLearningModel.eventstartTime = jsonMyLearningColumnObj["eventstartdatedisplay"].toString();
          }
          // eventenddatedisplay
          if (jsonMyLearningColumnObj.containsKey("eventenddatedisplay")) {
            trackLearningModel.eventendTime = jsonMyLearningColumnObj["eventenddatedisplay"].toString();
          }

          // mediatypeid
          if (jsonMyLearningColumnObj.containsKey("mediatypeid")) {
            trackLearningModel.mediatypeId = jsonMyLearningColumnObj["mediatypeid"].toString();
          }
          // eventcontentid
          if (jsonMyLearningColumnObj.containsKey("eventcontentid")) {
            trackLearningModel.eventContentid = jsonMyLearningColumnObj["eventcontentid"].toString();
          }
          // eventAddedToCalender
          trackLearningModel.eventAddedToCalender = false;

          // eventfulllocation
          if (jsonMyLearningColumnObj.containsKey("eventfulllocation")) {
            trackLearningModel.locationName = jsonMyLearningColumnObj["eventfulllocation"].toString();
          }
          // timezone
          if (jsonMyLearningColumnObj.containsKey("timezone")) {
            trackLearningModel.timeZone = jsonMyLearningColumnObj["timezone"].toString();
          }
          // participanturl
          if (jsonMyLearningColumnObj.containsKey("participanturl")) {
            trackLearningModel.participantUrl = jsonMyLearningColumnObj["participanturl"].toString();
          }

          // isListView
          if (jsonMyLearningColumnObj.containsKey("bit5")) {
            trackLearningModel.isListView = jsonMyLearningColumnObj["bit5"].toString();
          }

          // joinurl
          if (jsonMyLearningColumnObj.containsKey("joinurl")) {
            trackLearningModel.joinurl = jsonMyLearningColumnObj["joinurl"].toString();
          }

          // presenter
          if (jsonMyLearningColumnObj.containsKey("presentername")) {
            trackLearningModel.presenter = jsonMyLearningColumnObj["presentername"].toString();
          }

          //sitename
          if (jsonMyLearningColumnObj.containsKey("progress")) {
            trackLearningModel.progress = jsonMyLearningColumnObj["progress"].toString();
          }

          trackLearningModel.recordingmsg = jsonMyLearningColumnObj["recordingmsg"] ?? '';
          trackLearningModel.eventrecording = jsonMyLearningColumnObj["eventrecording"] ?? '';
          trackLearningModel.recordingcontentid = jsonMyLearningColumnObj["recordingcontentid"];
          trackLearningModel.recordingurl = jsonMyLearningColumnObj["recordingurl"] ?? '';

          trackLearningModel.blockName = "";
          trackLearningModel.trackOrRelatedContentID = courseDTOModel.contentid;

          injectIntoTrackTable(courseDTOModel: trackLearningModel);
        }
      }
    } catch (err) {
      MyPrint.printOnConsole('insertTrackObjects failed: $err');
    }
  }

  Future<void> injectIntoTrackTable({required CourseDTOModel courseDTOModel}) async {
    if (!(await init())) return;

    try {
      String query = 'INSERT INTO $TBL_TRACKLIST_DATA('
          'username,'
          'siteid,'
          'userid,'
          'scoid,'
          'siteurl,'
          'sitename,'
          'contentid,'
          'coursename,'
          'author,'
          'shortdes,'
          'longdes,'
          'imagedata,'
          'medianame,'
          'createddate,'
          'startpage,'
          'eventstarttime,'
          'eventendtime,'
          'objecttypeid,'
          'locationname,'
          'timezone,'
          'participanturl,'
          'trackscoid,'
          'status,'
          'displaystatus,'
          'eventid,'
          'password,'
          'displayname,'
          'isdownloaded,'
          'courseattempts,'
          'eventcontentid,'
          'relatedcontentcount,'
          'mediatypeid,'
          'downloadurl,'
          'progress,'
          'presenter,'
          'eventaddedtocalender,'
          'joinurl,'
          'typeofevent,'
          'blockname,'
          'showstatus,'
          'parentid,'
          'timedelay,'
          'isdiscussion,'
          'sequencenumber,'
          'courseattempts,'
          'offlinepath,'
          'trackContentId,'
          'ruleid,'
          'stepid,'
          'wmessage,'
          'folderpath,'
          'jwvideokey,'
          'cloudmediaplayerkey,'
          'eventstartUtctime,'
          'eventendUtctime,'
          'contentTypeImagePath,'
          'activityid,'
          'bookmarkid,'
          'recordingmsg,'
          'eventrecording,'
          'recordingcontentid,'
          'recordingurl,'
          'objectfolderid'
          ')VALUES('
          '${trackListModel.userName},'
          '${trackListModel.siteID},'
          '${trackListModel.userID},'
          '${trackListModel.scoid},'
          '${trackListModel.siteURL},'
          '${trackListModel.siteName},'
          '${trackListModel.contentID},'
          '${trackListModel.courseName},'
          '${trackListModel.author},'
          '${trackListModel.shortDes},'
          '${trackListModel.longDes},'
          '${trackListModel.imageData},'
          '${trackListModel.mediaName},'
          '${trackListModel.createdDate},'
          '${trackListModel.startPage},'
          '${trackListModel.eventstartTime},'
          '${trackListModel.eventendTime},'
          '${trackListModel.objecttypeId},'
          '${trackListModel.locationName},'
          '${trackListModel.timeZone},'
          '${trackListModel.participantUrl},'
          '${trackListModel.trackScoid},'
          '${trackListModel.statusActual},'
          '${trackListModel.statusDisplay},'
          '${trackListModel.eventID},'
          '${trackListModel.password},'
          '${trackListModel.displayName},'
          '${trackListModel.isDownloaded},'
          '${trackListModel.courseAttempts},'
          'false,'
          '${trackListModel.relatedContentCount},'
          '${trackListModel.mediatypeId},'
          '${trackListModel.downloadURL},'
          '${trackListModel.progress},'
          '${trackListModel.presenter},'
          '${trackListModel.eventAddedToCalender},'
          '${trackListModel.joinurl},'
          '${trackListModel.typeofevent},'
          '${trackListModel.blockName},'
          '${trackListModel.showStatus},'
          '${trackListModel.parentID},'
          '${trackListModel.timeDelay},'
          '${trackListModel.isDiscussion},'
          '${trackListModel.sequenceNumber},'
          '${trackListModel.courseAttempts},'
          '${trackListModel.offlinepath},'
          '${trackListModel.trackOrRelatedContentID},'
          '0,'
          '0,'
          '\'\','
          '${trackListModel.folderPath},'
          '${trackListModel.jwvideokey},'
          '${trackListModel.cloudmediaplayerkey},'
          '${trackListModel.eventstartUtcTime},'
          '${trackListModel.eventendUtcTime},'
          '${trackListModel.contentTypeImagePath},'
          '${trackListModel.activityId},'
          '${trackListModel.bookmarkID},'
          '${trackListModel.recordingmsg},'
          '${trackListModel.eventrecording},'
          '${trackListModel.recordingcontentid},'
          '${trackListModel.recordingurl},'
          '${trackListModel.objectfolderid}'
          ')';

      await _database!.rawQuery(query);
    } catch (err) {
      MyPrint.printOnConsole('injectIntoTrackTable failed: $err');
    }
  }*/

  Future<void> injectCMIDataInto({required Map<String, dynamic> jsonObjectCMI, required CourseDTOModel courseDTOModel}) async {
    if (!(await init())) return;

    try {
      List<dynamic> jsonCMiArray = jsonObjectCMI['cmi'];
      List<dynamic> jsonStudentAry = jsonObjectCMI['studentresponse'];
      List<dynamic> jsonLearnerSessionAry = jsonObjectCMI['learnersession'];

      /// Delete all existing records irrespective of whether there is data coming from the server or not.
      /// If there's no data on the server, then there should not be data on the local DB as well.
      /// Usage: In cases where the course has been unassigned earlier but is now reassigned
      /// When the course is unassigned, track data is cleared on the server
      ejectRecordsinCmi(courseDTOModel: courseDTOModel);
      insertCMIData(jsonArray: jsonCMiArray, courseDTOModel: courseDTOModel);

      ejectRecordsinStudentResponse(courseDTOModel: courseDTOModel);
      insertStudentResponsData(jsonArray: jsonStudentAry, courseDTOModel: courseDTOModel);

      ejectRecordsinLearnerSession(courseDTOModel: courseDTOModel);
      insertLearnerSession(jsonArray: jsonLearnerSessionAry, courseDTOModel: courseDTOModel);
    } catch (err) {
      MyPrint.printOnConsole('injectCMIDataInto failed $err');
    }
  }

  Future<void> insertCMIData({required List<dynamic> jsonArray, required CourseDTOModel courseDTOModel}) async {
    if (!(await init())) return;

    try {
      for (int i = 0; i < jsonArray.length; i++) {
        Map<dynamic, dynamic> jsonCMiColumnObj = jsonArray[i];
        MyPrint.printOnConsole('injectINTCMI: $jsonCMiColumnObj');

        CMIModel cmiModel = CMIModel();

        if (jsonCMiColumnObj.containsKey("corelessonstatus")) {
          String string = jsonCMiColumnObj["corelessonstatus"].toString();
          cmiModel.corelessonstatus = AppConfigurationOperations.isValidString(string) ? string : '';
        }

        // scoid
        if (jsonCMiColumnObj.containsKey("scoid")) {
          int scoID = int.parse(jsonCMiColumnObj["scoid"].toString());
          cmiModel.scoid = scoID;
        }
        // userid
        if (jsonCMiColumnObj.containsKey("userid")) {
          int userID = int.parse(jsonCMiColumnObj["userid"].toString());
          cmiModel.userid = userID;
        }
        // corelessonlocation
        if (jsonCMiColumnObj.containsKey("corelessonlocation")) {
          String string = jsonCMiColumnObj["corelessonlocation"].toString();
          cmiModel.corelessonlocation = AppConfigurationOperations.isValidString(string) ? string : '';
        }

        // author
        if (jsonCMiColumnObj.containsKey("totalsessiontime")) {
          String string = jsonCMiColumnObj["totalsessiontime"].toString();
          cmiModel.totalsessiontime = AppConfigurationOperations.isValidString(string) ? string : "0:00:00";
        }
        // scoreraw
        if (jsonCMiColumnObj.containsKey("scoreraw")) {
          String string = jsonCMiColumnObj["scoreraw"].toString();
          cmiModel.scoreraw = AppConfigurationOperations.isValidString(string) ? string : '';
        }
        // sequencenumber
        cmiModel.sequencenumber = ParsingHelper.parseIntMethod(jsonCMiColumnObj["sequencenumber"]);
        // durationEndDate
        if (jsonCMiColumnObj.containsKey("corelessonmode")) {
          String string = jsonCMiColumnObj["corelessonmode"].toString();
          cmiModel.corelessonmode = AppConfigurationOperations.isValidString(string) ? string : '';
        }
        // scoremin
        if (jsonCMiColumnObj.containsKey("scoremin")) {
          String string = jsonCMiColumnObj["scoremin"].toString();
          cmiModel.scoremin = AppConfigurationOperations.isValidString(string) ? string : '';
        }

        // scoremax
        if (jsonCMiColumnObj.containsKey("scoremax")) {
          String string = jsonCMiColumnObj["scoremax"].toString();
          cmiModel.scoremax = AppConfigurationOperations.isValidString(string) ? string : '';
        }

        cmiModel.startdate = "";

        // datecompleted
        if (jsonCMiColumnObj.containsKey("datecompleted")) {
          String s = jsonCMiColumnObj["datecompleted"].toString().toUpperCase();

          if (!(s.toLowerCase() == "null")) {
            String dateStr = s.substring(0, 19);

            DateTime? dateObj = ParsingHelper.parseDateTimeMethod(dateStr, dateFormat: "yyyy-MM-dd\'T\'HH:mm:ss");
            String strCreatedDate = DatePresentation.getFormattedDate(dateFormat: "yyyy-MM-dd hh:mm:ss", dateTime: dateObj) ?? "";
            cmiModel.datecompleted = strCreatedDate;
          } else {
            cmiModel.datecompleted = "";
          }
        }
        // objecttypeid
        if (jsonCMiColumnObj.containsKey("suspenddata")) {
          cmiModel.suspenddata = jsonCMiColumnObj["suspenddata"].toString();
        }
        // scoid
        if (jsonCMiColumnObj.containsKey("textresponses")) {
          String string = jsonCMiColumnObj["textresponses"].toString();
          cmiModel.textresponses = AppConfigurationOperations.isValidString(string) ? string : '';
        }
        cmiModel.siteid = courseDTOModel.SiteId;
        // cmiModel.sitrurl = learningModel.siteurl;
        cmiModel.isupdate = "true";
        // status
        if (jsonCMiColumnObj.containsKey("noofattempts") && !(jsonCMiColumnObj["noofattempts"] == null)) {
          int numberAtmps = int.parse(jsonCMiColumnObj["noofattempts"].toString());
          cmiModel.noofattempts = numberAtmps;
        }
        injectIntoCMITable(cmiModel: cmiModel, isViewed: true);
      }
    } catch (err) {
      MyPrint.printOnConsole('insertCMIData failed: $err');
    }
  }

  Future<void> injectIntoCMITable({required CMIModel cmiModel, bool isViewed = false}) async {
    if (!(await init())) return;

    try {
      String query = 'INSERT INTO $TBL_CMI('
          'siteid,'
          'scoid,'
          'userid,'
          'location,'
          'status,'
          'suspenddata,'
          'isupdate,'
          'siteurl,'
          'datecompleted,'
          'noofattempts,'
          'score,'
          'sequencenumber,'
          'startdate,'
          'timespent,'
          'coursemode,'
          'scoremin,'
          'scoremax,'
          'submittime,'
          'randomquesseq,'
          'pooledquesseq,'
          'textResponses,'
          'percentageCompleted)VALUES('
          '\'${cmiModel.siteid}\','
          '\'${cmiModel.scoid}\','
          '\'${cmiModel.userid}\','
          '\'${cmiModel.corelessonlocation}\','
          '\'${cmiModel.corelessonstatus}\','
          '\'${cmiModel.suspenddata}\','
          '\'$isViewed\','
          '\'${cmiModel.siteurl}\','
          '\'${cmiModel.datecompleted}\','
          '\'${cmiModel.noofattempts}\','
          '\'${cmiModel.scoreraw}\','
          '\'${cmiModel.sequencenumber}\','
          '\'${cmiModel.startdate}\','
          '\'${cmiModel.totalsessiontime}\','
          '\'${cmiModel.corelessonmode}\','
          '\'${cmiModel.scoremin}\','
          '\'${cmiModel.scoremax}\','
          '\'${cmiModel.submittime}\','
          '\'${cmiModel.randomquestionnos}\','
          '\'${cmiModel.pooledquestionnos}\','
          '\'${cmiModel.textresponses}\','
          '\'${cmiModel.percentageCompleted}\')';
      await _database!.rawQuery(query);
    } catch (err) {
      MyPrint.printOnConsole('injectIntoCMITable failed: $err');
    }
  }

  Future<void> insertStudentResponsData({required List<dynamic> jsonArray, required CourseDTOModel courseDTOModel}) async {
    if (!(await init())) return;

    try {
      for (int i = 0; i < jsonArray.length; i++) {
        Map<dynamic, dynamic> jsonCMiColumnObj = jsonArray[i];

        MyPrint.printOnConsole("injectINTCMI: $jsonCMiColumnObj");

        StudentResponseModel studentResponseModel = StudentResponseModel();

        //userid
        if (jsonCMiColumnObj.containsKey("userid")) {
          int userID = int.parse(jsonCMiColumnObj["userid"].toString());
          studentResponseModel.userid = userID;
        }
        // statusdisplayname
        if (jsonCMiColumnObj.containsKey("studentresponses")) {
          String checkForNull = jsonCMiColumnObj["studentresponses"].toString();

          if (AppConfigurationOperations.isValidString(checkForNull)) {
            // Replace "@" with "#^#"
            if (checkForNull.contains("@")) {
              checkForNull = checkForNull.replaceAll("@", "#^#^");
            }

            // Replace "&&**&&" with "##^^##"
            if (checkForNull.contains("&&**&&")) {
              checkForNull = checkForNull.replaceAll("&&\\*\\*&&", "##^^##^^");
            }

            studentResponseModel.studentresponses = checkForNull;
          } else {
            studentResponseModel.studentresponses = "";
          }
        }
        // scoid
        if (jsonCMiColumnObj.containsKey("scoid")) {
          int scoID = int.parse(jsonCMiColumnObj["scoid"].toString());
          studentResponseModel.scoid = scoID;
        }
        // userid
        if (jsonCMiColumnObj.containsKey("result")) {
          studentResponseModel.result = jsonCMiColumnObj["result"].toString();
        }

        // author
        if (jsonCMiColumnObj.containsKey("questionid") && !(jsonCMiColumnObj["questionid"] == null)) {
          int questionID = -1;
          try {
            questionID = int.parse(jsonCMiColumnObj["questionid"].toString());
          } catch (numberEx) {
            MyPrint.printOnConsole('insertStudentResponsData failed: $numberEx');
            questionID = -1;
          }

          studentResponseModel.questionid = questionID;
        }
        // scoreraw
        if (jsonCMiColumnObj.containsKey("questionattempt") && !(jsonCMiColumnObj["questionattempt"] == null)) {
          int questionattempts = int.parse(jsonCMiColumnObj["questionattempt"].toString());
          studentResponseModel.questionattempt = questionattempts;
        }
        // sequencenumber
        if (jsonCMiColumnObj.containsKey("optionalnotes")) {
          studentResponseModel.optionalnotes = jsonCMiColumnObj["optionalnotes"].toString();
        }

        // indexs
        if (jsonCMiColumnObj.containsKey("index")) {
          int indexs = int.parse(jsonCMiColumnObj["index"].toString());
          studentResponseModel.index = indexs;
        }

        // scoremax
        if (jsonCMiColumnObj.containsKey("capturedvidid")) {
          studentResponseModel.capturedvidid = jsonCMiColumnObj["capturedvidid"].toString();
        }
        // startdate
        if (jsonCMiColumnObj.containsKey("capturedvidfilename")) {
          studentResponseModel.capturedvidfilename = jsonCMiColumnObj["capturedvidfilename"].toString();
        }
        // datecompleted
        if (jsonCMiColumnObj.containsKey("capturedimgid")) {
          studentResponseModel.capturedimgid = jsonCMiColumnObj["capturedimgid"].toString();
        }
        // objecttypeid
        if (jsonCMiColumnObj.containsKey("capturedimgfilename")) {
          studentResponseModel.capturedimgfilename = jsonCMiColumnObj["capturedimgfilename"].toString();
        }
        // scoid
        if (jsonCMiColumnObj.containsKey("attemptdate")) {
          studentResponseModel.attemptdate = jsonCMiColumnObj["attemptdate"].toString();
        }
        studentResponseModel.siteid = courseDTOModel.SiteId;
        // status
        if (jsonCMiColumnObj.containsKey("attachfileid") && !(jsonCMiColumnObj["attachfileid"] == null)) {
          studentResponseModel.attachfileid = jsonCMiColumnObj["attachfileid"].toString();
        }

        // status
        if (jsonCMiColumnObj.containsKey("attachfilename") && !(jsonCMiColumnObj["attachfilename"] == null)) {
          studentResponseModel.attachfilename = jsonCMiColumnObj["attachfilename"].toString();
        }
        // status
        if (jsonCMiColumnObj.containsKey("assessmentattempt") && !(jsonCMiColumnObj["assessmentattempt"] == null)) {
          int numberAtmps = int.parse(jsonCMiColumnObj["assessmentattempt"].toString());
          studentResponseModel.assessmentattempt = numberAtmps;
        }
        injectIntoStudentResponseTable(studentResponseModel: studentResponseModel);
      }
    } catch (err) {
      MyPrint.printOnConsole('insertStudentResponsData failed: $err');
    }
  }

  Future<void> injectIntoStudentResponseTable({required StudentResponseModel studentResponseModel}) async {
    if (!(await init())) return;

    try {
      String query = 'INSERT INTO $TBL_STUDENT_RESPONSES('
          'siteid,'
          'scoid,'
          'userid,'
          'questionid,'
          'assessmentattempt,'
          'questionattempt,'
          'attemptdate,'
          'studentresponses,'
          'result,'
          'attachfilename,'
          'attachfileid,'
          'rindex,'
          'attachedfilepath,'
          'optionalNotes,'
          'capturedVidFileName,'
          'capturedVidId,'
          'capturedVidFilepath,'
          'capturedImgFileName,'
          'capturedImgId,'
          'capturedImgFilepath'
          ')VALUES ('
          '\'${studentResponseModel.siteid}\','
          '\'${studentResponseModel.scoid}\','
          '\'${studentResponseModel.userid}\','
          '\'${studentResponseModel.questionid}\','
          '\'${studentResponseModel.assessmentattempt}\','
          '\'${studentResponseModel.questionattempt}\','
          '\'${studentResponseModel.attemptdate}\','
          '\'${studentResponseModel.studentresponses}\','
          '\'${studentResponseModel.result}\','
          '\'${studentResponseModel.attachfilename}\','
          '\'${studentResponseModel.attachfileid}\','
          '\'${studentResponseModel.index}\','
          '\'${studentResponseModel.attachfilename}\','
          '\'${studentResponseModel.optionalnotes}\','
          '\'${studentResponseModel.capturedimgfilename}\','
          '\'${studentResponseModel.capturedvidid}\','
          '\'${studentResponseModel.capturedVidFilepath}\','
          '\'${studentResponseModel.capturedimgfilename}\','
          '\'${studentResponseModel.capturedimgid}\','
          '\'${studentResponseModel.capturedImgFilepath}\')';
      await _database!.rawQuery(query);
    } catch (err) {
      MyPrint.printOnConsole('injectIntoStudentResponseTable failed $err');
    }
  }

  Future<void> insertLearnerSession({required List<dynamic> jsonArray, required CourseDTOModel courseDTOModel}) async {
    if (!(await init())) return;

    try {
      for (int i = 0; i < jsonArray.length; i++) {
        Map<dynamic, dynamic> jsonCMiColumnObj = jsonArray[i];
        MyPrint.printOnConsole("injectINTCMI: $jsonCMiColumnObj");

        LearnerSessionModel learnerSessionTable = LearnerSessionModel();

        learnerSessionTable.siteid = courseDTOModel.SiteId;
        //userid
        if (jsonCMiColumnObj.containsKey("userid")) {
          learnerSessionTable.userid = jsonCMiColumnObj["userid"];
        }
        // timespent
        if (jsonCMiColumnObj.containsKey("timespent")) {
          String string = jsonCMiColumnObj["timespent"].toString();
          learnerSessionTable.timespent = AppConfigurationOperations.isValidString(string) ? string : '0:00:00';
        }
        // sessionid
        if (jsonCMiColumnObj.containsKey("sessionid")) {
          learnerSessionTable.sessionid = jsonCMiColumnObj["sessionid"];
        }
        // sessiondatetime
        if (jsonCMiColumnObj.containsKey("sessiondatetime")) {
          String s = jsonCMiColumnObj["sessiondatetime"].toUpperCase();
          if (!(s.toLowerCase() == "null")) {
            String dateStr = s.substring(0, 19);
            DateTime? dateObj = ParsingHelper.parseDateTimeMethod(dateStr, dateFormat: "yyyy-MM-dd\'T\'HH:mm:ss");
            String strCreatedDate = DatePresentation.getFormattedDate(dateFormat: "yyyy-MM-dd hh:mm:ss", dateTime: dateObj) ?? "";
            learnerSessionTable.sessiondatetime = strCreatedDate;
          } else {
            learnerSessionTable.sessiondatetime = "";
          }
        }

        // scoID
        if (jsonCMiColumnObj.containsKey("scoid")) {
          learnerSessionTable.scoid = jsonCMiColumnObj["scoid"];
        }

        // attemptnumber

        int attemptnumber = 0;
        if (jsonCMiColumnObj.containsKey("attemptnumber") && !(jsonCMiColumnObj["attemptnumber"] == null)) {
          attemptnumber = jsonCMiColumnObj["attemptnumber"];

          learnerSessionTable.attemptnumber = attemptnumber;
        }

        if (attemptnumber == 1) {
          String startDate = "";
          if (AppConfigurationOperations.isValidString(learnerSessionTable.sessiondatetime)) {
            startDate = learnerSessionTable.sessiondatetime;
          }
          updateCMIStartDate(scoID: learnerSessionTable.scoid.toString(), startDate: startDate, userID: learnerSessionTable.userid.toString(), siteId: learnerSessionTable.siteid);
        }
        injectIntoLearnerTable(learnerSessionModel: learnerSessionTable);
      }
    } catch (err) {
      MyPrint.printOnConsole('insertLearnerSession failed $err');
    }
  }

  Future<void> injectIntoLearnerTable({required LearnerSessionModel learnerSessionModel}) async {
    if (!(await init())) return;

    try {
      String query = 'INSERT INTO $TBL_USER_SESSION('
          'userid,'
          'scoid,'
          'siteid,'
          'attemptnumber,'
          'sessiondatetime,'
          'timespent'
          ')VALUES('
          '\'${learnerSessionModel.userid}\','
          '\'${learnerSessionModel.scoid}\','
          '\'${learnerSessionModel.siteid}\','
          '\'${learnerSessionModel.attemptnumber}\','
          '\'${learnerSessionModel.sessiondatetime}\','
          '\'${learnerSessionModel.timespent}\''
          ')';
      await _database!.rawQuery(query);
    } catch (err) {
      MyPrint.printOnConsole('injectIntoLearnerTable failed $err');
    }
  }

  Future<void> injectIntoTrackObjectsTable({required TrackCourseDTOModel trackObjModel}) async {
    if (!(await init())) return;

    try {
      String query = 'INSERT INTO $TBL_TRACK_OBJECTS('
          'trackscoid,'
          'scoid,'
          'sequencenumber,'
          'siteid,'
          'userid,'
          'objecttypeid,'
          'name,'
          'mediatypeid'
          ')VALUES('
          '${trackObjModel.TrackScoID},'
          '${trackObjModel.ScoID},'
          '${trackObjModel.SequenceID},'
          '${trackObjModel.SiteId},'
          '${trackObjModel.UserID},'
          '${trackObjModel.ContentTypeId},'
          '${trackObjModel.ContentName},'
          '${trackObjModel.MediaTypeID},'
          ')';

      await _database!.rawQuery(query);
    } catch (err) {
      MyPrint.printOnConsole('injectIntoTrackObjectsTable failed: $err');
    }
  }

  Future<bool> isContentExists({required CourseDTOModel courseDTOModel, required String tableName}) async {
    if (!(await init())) return false;

    bool isRecordExists = false;
    try {
      String strExeQuery = "SELECT * FROM $tableName WHERE siteid= ${courseDTOModel.SiteId} AND userid= ${courseDTOModel.SiteUserID} AND contentid = '${courseDTOModel.ContentID}}' ";
      List<Map<String, dynamic>> data = await _database!.rawQuery(strExeQuery);

      isRecordExists = data.isNotEmpty;
    } catch (err) {
      MyPrint.printOnConsole('isContentExists failed: $err');
    }

    return isRecordExists;
  }

  Future<void> ejectRecordsInTable(String tableName) async {
    if (!(await init())) return;

    try {
      String strDelete = 'DELETE FROM $tableName';
      await _database!.rawQuery(strDelete);
    } catch (err) {
      MyPrint.printOnConsole('ejectRecordsinTable failed: $err');
    }
  }

  Future<void> ejectRecordsinCmi({required CourseDTOModel courseDTOModel}) async {
    if (!(await init())) return;

    try {
      String strDelete = "DELETE FROM $TBL_CMI WHERE siteid= '${courseDTOModel.SiteId}' AND scoid= '${courseDTOModel.ScoID}' AND userid= '${courseDTOModel.SiteUserID}'";
//            String strDelete = "DELETE FROM " + TBL_CMI + " WHERE siteid= '" + learnerModel.getSiteID() +
//                    "' AND userid= '" + learnerModel.getUserID() + "'";
      await _database!.rawQuery(strDelete);
    } catch (err) {
      MyPrint.printOnConsole('ejectRecordsinCmi failed: $err');
    }

    if (courseDTOModel.ContentTypeId == InstancyObjectTypes.track) {
      try {
        String strDelete = "DELETE FROM $TBL_CMI WHERE siteid= '${courseDTOModel.SiteId}' AND scoid= '${courseDTOModel.ScoID}' AND userid= '${courseDTOModel.SiteUserID}'";
        await _database!.rawQuery(strDelete);
      } catch (err) {
        MyPrint.printOnConsole('ejectRecordsinCmi failed: $err');
      }
    }
  }

  Future<void> ejectRecordsinStudentResponse({required CourseDTOModel courseDTOModel}) async {
    if (!(await init())) return;

    try {
      String strDelete = "DELETE FROM $TBL_STUDENT_RESPONSES WHERE siteid= '${courseDTOModel.SiteId}' AND scoid= '${courseDTOModel.ScoID}' AND userid= '${courseDTOModel.SiteUserID}'";
      await _database!.rawQuery(strDelete);
    } catch (err) {
      MyPrint.printOnConsole('ejectRecordsinStudentResponse failed: $err');
    }
  }

  Future<void> ejectRecordsinLearnerSession({required CourseDTOModel courseDTOModel}) async {
    if (!(await init())) return;

    try {
      String strDelete = "DELETE FROM $TBL_USER_SESSION WHERE siteid= '${courseDTOModel.SiteId}' AND scoid= '${courseDTOModel.ScoID}' AND userid= '${courseDTOModel.SiteUserID}'";
      await _database!.rawQuery(strDelete);
    } catch (err) {
      MyPrint.printOnConsole('ejectRecordsinLearnerSession failed: $err');
    }
  }

  Future<void> ejectRecordsinTrackObjDb({required CourseDTOModel courseDTOModel}) async {
    if (!(await init())) return;

    try {
      String strDelete = "DELETE FROM $TBL_TRACK_OBJECTS "
          "WHERE siteid= '${courseDTOModel.SiteId}' "
          "AND trackscoid= '${courseDTOModel.ScoID}' "
          "AND userid= '${courseDTOModel.SiteUserID}'";
      await _database!.rawQuery(strDelete);
    } catch (err) {
      MyPrint.printOnConsole('ejectRecordsinTrackObjDb failed: $err');
    }
  }

  Future<void> ejectRecordsinTracklistTable(String siteID, String trackscoID, String userID, bool isTrackList) async {
    if (!(await init())) return;

    String TBL_NAME;
    if (!isTrackList) {
      TBL_NAME = TBL_RELATED_CONTENT_DATA;
    } else {
      TBL_NAME = TBL_TRACKLIST_DATA;
    }

    try {
      String strDelete = "DELETE FROM $TBL_NAME "
          "WHERE siteid= '$siteID' "
          "AND trackscoid= '$trackscoID' "
          "AND userid= '$userID'";
      await _database!.rawQuery(strDelete);
    } catch (err) {
      MyPrint.printOnConsole('ejectRecordsinTracklistTable failed: $err');
    }
  }

  Future<List<CMIModel>> getAllCmiDownloadDataDetails() async {
    if (!(await init())) return <CMIModel>[];

    List<CMIModel> cmiList = <CMIModel>[];

    try {
      String selQuery =
          "SELECT C.location, C.status, C.suspenddata, C.datecompleted, C.noofattempts, C.score,C.percentageCompleted, D.objecttypeid, C.sequencenumber, C.scoid, C.userid, C.siteid, D.courseattempts, D.contentid, C.coursemode, C.scoremin, C.scoreMax, C.randomQuesSeq, C.textResponses, C.ID, C.siteurl, C.pooledquesseq FROM $TBL_CMI C inner join $TBL_DOWNLOAD_DATA D On D.userid = C.userid and D.scoid = C.scoid and D.siteid = C.siteid WHERE C.isupdate = 'false' ORDER BY C.sequencenumber";
      List<Map<String, dynamic>> data = await _database!.rawQuery(selQuery);

      if (data.isNotEmpty) {
        for (Map<String, dynamic> item in data) {
          String objecttypeId = item['objecttypeid'];

          if (equalsIgnoreCase(objecttypeId, "10")) {
            continue;
          }

          CMIModel cmiDetails = CMIModel();
          cmiDetails.scoid = item['scoid'];
          cmiDetails.corelessonlocation = item['location'];

          cmiDetails.corelessonstatus = item['status'];

          cmiDetails.suspenddata = item['suspenddata'];
          cmiDetails.siteid = item['siteid'];
          cmiDetails.scoreraw = item['score'] ?? '';
          cmiDetails.objecttypeid = item['objecttypeid'];
          cmiDetails.sequencenumber = item['sequencenumber'];
          cmiDetails.userid = item['userid'];
          cmiDetails.datecompleted = item['datecompleted'];
          cmiDetails.noofattempts = item['noofattempts'];

          cmiDetails.randomquestionnos = item['randomquesseq'];
          cmiDetails.siteurl = item['siteurl'];
          cmiDetails.textresponses = item['textResponses'];
          cmiDetails.pooledquestionnos = item['pooledquesseq'] ?? '';

          cmiDetails.contentId = item['contentid'];

          cmiDetails.corelessonmode = item['coursemode'];

          cmiDetails.scoremin = item['scoremin'];

          cmiDetails.scoremax = item['scoremax'];

          cmiDetails.percentageCompleted = item['percentageCompleted'];

          cmiDetails.parentObjTypeId = "";
          cmiDetails.parentContentId = "";
          cmiDetails.parentScoId = "";

          cmiList.add(cmiDetails);
        }
      }
    } catch (err) {
      MyPrint.printOnConsole('getAllCmiDownloadDataDetails failed: $err');
    }
    return cmiList;
  }

  Future<List<CMIModel>> getAllCmiTrackListDetails() async {
    if (!(await init())) return <CMIModel>[];

    List<CMIModel> cmiList = <CMIModel>[];

    try {
      String selQuery =
          "SELECT C.location, C.status, C.suspenddata, C.datecompleted, C.noofattempts, C.score,C.sequencenumber,C.percentageCompleted, C.scoid, C.userid, D.siteid, D.courseattempts, D.objecttypeid, D.contentid, D.trackContentId, D.trackscoid, C.coursemode, C.scoremin, C.scoreMax, C.randomQuesSeq, C.textResponses, C.ID, D.siteurl, C.pooledquesseq FROM $TBL_CMI C inner join $TBL_TRACKLIST_DATA D On D.userid = C.userid and D.scoid = C.scoid and D.siteid = C.siteid WHERE C.isupdate = 'false' ORDER BY C.sequencenumber ";

      List<Map<String, dynamic>> data = await _database!.rawQuery(selQuery);
      if (data.isNotEmpty) {
        for (Map<String, dynamic> item in data) {
          String objecttypeId = item['objecttypeid'].toString();

          if (equalsIgnoreCase(objecttypeId, "10")) {
            continue;
          }

          CMIModel cmiDetails = CMIModel();
          cmiDetails.scoid = item['scoid'];
          cmiDetails.corelessonlocation = item['location'];
          cmiDetails.corelessonstatus = item['status'];

          cmiDetails.suspenddata = item['suspenddata'];
          cmiDetails.siteid = item['siteid'];

          cmiDetails.scoreraw = item['score'] ?? '';
          cmiDetails.objecttypeid = item['objecttypeid'].toString();
          cmiDetails.sequencenumber = item['sequencenumber'];
          cmiDetails.userid = item['userid'];
          cmiDetails.datecompleted = item['datecompleted'];

          cmiDetails.noofattempts = item['noofattempts'];
//                cmiDetails.set_noofattempts(cursor.getInt(cursor
//                        .getColumnIndex("attemptnumber")));
          cmiDetails.corelessonmode = item['coursemode'];
          cmiDetails.randomquestionnos = item['randomquesseq'];
          cmiDetails.siteurl = item['siteurl'];

          cmiDetails.textresponses = item['textResponses'];
          cmiDetails.pooledquestionnos = item['pooledquesseq'] ?? '';

          cmiDetails.contentId = item['contentid'];

          cmiDetails.parentObjTypeId = '10';
          cmiDetails.parentContentId = item['trackContentId'];
          cmiDetails.parentScoId = item['trackscoid'];

          cmiDetails.percentageCompleted = item['percentageCompleted'];
          cmiList.add(cmiDetails);
        }
      }
    } catch (err) {
      MyPrint.printOnConsole('getAllCmiTrackListDetails failed: $err');
    }

    return cmiList;
  }

  Future<List<CMIModel>> getAllCmiRelatedContentDetails() async {
    if (!(await init())) return <CMIModel>[];

    List<CMIModel> cmiList = <CMIModel>[];

    try {
      String selQuery =
          "SELECT C.location, C.status, C.suspenddata,C.percentageCompleted, C.datecompleted, C.noofattempts, C.score, D.objecttypeid, C.sequencenumber, C.scoid, C.userid, C.siteid, D.courseattempts, D.contentid, D.trackcontentid, D.trackscoid, C.coursemode, C.scoremin, C.scoreMax, C.randomQuesSeq, C.textResponses, C.ID, C.siteurl,C.pooledquesseq FROM $TBL_CMI C inner join $TBL_RELATED_CONTENT_DATA D On D.userid = C.userid and D.scoid = C.scoid and D.siteid = C.siteid WHERE C.isupdate = 'false' ORDER BY C.sequencenumber";

      List<Map<String, dynamic>> data = await _database!.rawQuery(selQuery);
      if (data.isNotEmpty) {
        for (Map<String, dynamic> item in data) {
          String objecttypeId = item['objecttypeid'];

          if (equalsIgnoreCase(objecttypeId, "10")) {
            continue;
          }

          CMIModel cmiDetails = CMIModel();
          cmiDetails.scoid = int.parse(item['scoid']);
          cmiDetails.corelessonlocation = item['location'];

          cmiDetails.corelessonstatus = item['status'];
          cmiDetails.suspenddata = item['suspenddata'];
          cmiDetails.siteid = item['siteid'];

          cmiDetails.scoreraw = item['score'];
          cmiDetails.objecttypeid = item['objecttypeid'];
          cmiDetails.sequencenumber = item['sequencenumber'];
          cmiDetails.userid = int.parse(item['userid']);
          cmiDetails.datecompleted = item['datecompleted'];
          cmiDetails.noofattempts = int.parse(item['noofattempts']);

          cmiDetails.corelessonmode = item['coursemode'];
          cmiDetails.randomquestionnos = item['randomquesseq'];
          cmiDetails.siteurl = item['siteurl'];
          cmiDetails.textresponses = item['textResponses'];
          cmiDetails.pooledquestionnos = item['pooledquesseq'];

          cmiDetails.parentObjTypeId = '10';
          cmiDetails.parentContentId = item['trackContentId'];
          cmiDetails.parentScoId = item['trackscoid'];

          cmiDetails.percentageCompleted = item['percentageCompleted'];

          cmiList.add(cmiDetails);
        }
      }
    } catch (err) {
      MyPrint.printOnConsole('getAllCmiRelatedContentDetails failed: $err');
    }

    return cmiList;
  }

  Future<List<LearnerSessionModel>> getAllSessionDetails(String userId, String siteId, String scoid) async {
    if (!(await init())) return <LearnerSessionModel>[];

    List<LearnerSessionModel> sessionList = <LearnerSessionModel>[];

    try {
      String selQuery = "SELECT sessionid,scoid,attemptnumber,sessiondatetime,timespent FROM USERSESSION WHERE userid=$userId AND siteid=$siteId AND scoid=$scoid";

      List<Map<String, dynamic>> data = await _database!.rawQuery(selQuery);
      if (data.isNotEmpty) {
        for (Map<String, dynamic> item in data) {
          LearnerSessionModel sesDetails = LearnerSessionModel();
          sesDetails.sessionid = item['sessionid'];
          sesDetails.scoid = item['scoid'];
          sesDetails.attemptnumber = item['attemptnumber'];
          sesDetails.sessiondatetime = item['sessiondatetime'];
          sesDetails.timespent = item['timespent']?.toString() ?? "";
          sessionList.add(sesDetails);
        }
      }
    } catch (err) {
      MyPrint.printOnConsole('getAllSessionDetails failed: $err');
    }

    return sessionList;
  }

  Future<List<StudentResponseModel>> getAllResponseDetails({required String userId, required String siteId, required String scoId}) async {
    if (!(await init())) return <StudentResponseModel>[];

    List<StudentResponseModel> responseList = <StudentResponseModel>[];

    try {
      String selQuery =
          "SELECT scoid,questionid,assessmentattempt,questionattempt,attemptdate,studentresponses,result,attachfilename,attachfileid,attachedfilepath,optionalNotes,capturedVidFileName,capturedVidId,capturedVidFilepath,capturedImgFileName,capturedImgId,capturedImgFilepath FROM studentresponses WHERE userid=$userId AND siteid=$siteId AND scoid=$scoId";

      List<Map<String, dynamic>> data = await _database!.rawQuery(selQuery);
      if (data.isNotEmpty) {
        for (Map<String, dynamic> item in data) {
          StudentResponseModel resDetails = StudentResponseModel();
          resDetails.scoid = item['scoid'];
          resDetails.questionid = item['questionid'];

          resDetails.assessmentattempt = item['assessmentattempt'];
          resDetails.questionattempt = item['questionattempt'];
          resDetails.attemptdate = item['attemptdate'];
          resDetails.studentresponses = item['studentresponses'];
          resDetails.result = item['result'];
          resDetails.attachfilename = item['attachfilename'];
          resDetails.attachfileid = item['attachfileid'];
          resDetails.attachedfilepath = item['attachedfilepath'];
          resDetails.optionalnotes = item['optionalNotes'];

          resDetails.capturedvidfilename = item['capturedVidFileName'];
          resDetails.capturedvidid = item['capturedVidId'];
          resDetails.capturedVidFilepath = item['capturedVidFilepath'];

          resDetails.capturedimgfilename = item['capturedImgFileName'];
          resDetails.capturedimgid = item['capturedImgId'];
          resDetails.capturedImgFilepath = item['capturedImgFilepath'];

          responseList.add(resDetails);
        }
      }
    } catch (e) {
      MyPrint.printOnConsole('getAllResponseDetails failed $e');
    }

    return responseList;
  }

  Future<void> insertCMiIsViewed({required CMIModel cmiModel}) async {
    if (!(await init())) return;

    try {
      String strExeQuery = "UPDATE $TBL_CMI SET isupdate = 'true' WHERE siteid ='${cmiModel.siteid}' AND userid ='${cmiModel.userid}' AND scoid='${cmiModel.scoid}'";

      await _database!.rawQuery(strExeQuery);
    } catch (e) {
      MyPrint.printOnConsole('insertCMiIsViewed failed: $e');
    }
  }

  Future<String> saveResponseCMI({required CourseDTOModel courseDTOModel, required String getname, required String getvalue}) async {
    if (!(await init())) return "";

    try {
      String strExeQuery = '';

      strExeQuery = 'UPDATE $TBL_CMI SET '
          '$getname = \'$getvalue\','
          ' isupdate= \'false\''
          ' WHERE scoid=${courseDTOModel.ScoID}'
          ' AND siteid=${courseDTOModel.SiteId}'
          ' AND userid=${courseDTOModel.UserSiteId}';
      MyPrint.printOnConsole("saveResponseCMI Query:$strExeQuery");
      await _database!.rawQuery(strExeQuery);
      return "true";
    } catch (e) {
      MyPrint.printOnConsole('saveResponseCMI query failed: $e');
      return "false";
    }
  }

  Future<String> getResponseCMI({required CourseDTOModel courseDTOModel, required String getname}) async {
    if (!(await init())) return "";
    try {
      String strExeQuery = '';

      strExeQuery = 'SELECT $getname from $TBL_CMI'
          ' WHERE scoid=${courseDTOModel.ScoID}'
          ' AND siteid=${courseDTOModel.SiteId}'
          ' AND userid=${courseDTOModel.SiteUserID}';
      MyPrint.printOnConsole("getResponseCMI Query:$strExeQuery");

      List<Map<String, dynamic>> data = await _database!.rawQuery(strExeQuery);

      String response = "true";

      if (data.isNotEmpty) {
        for (Map<String, dynamic> item in data) {
          response = item[getname]?.toString() ?? "";
        }
      }

      return response;
    } catch (e) {
      MyPrint.printOnConsole('getResponseCMI query failed: $e');
      return "false";
    }
  }

  Future<String> checkCMIWithGivenQueryElement({required CourseDTOModel courseDTOModel, required String queryElement}) async {
    if (!(await init())) return "";

    String returnStr = "";

    try {
      String strExeQuery = "SELECT $queryElement FROM cmi WHERE scoid= ${courseDTOModel.ScoID} AND userid= ${courseDTOModel.SiteUserID} AND siteid= ${courseDTOModel.SiteId}";
      List<dynamic> data = await _database!.rawQuery(strExeQuery);

      if (data.isNotEmpty) {
        int len = data.length - 1;
        returnStr = data[len][queryElement];
      }
    } catch (err) {
      MyPrint.printOnConsole('checkCMIWithGivenQueryElement failed: $err');
    }
    return returnStr;
  }

  Future<void> UpdateScormCMI({required CMIModel cmiNew, required String getname, required String getvalue}) async {
    if (!(await init())) return;

    try {
      String strExeQuery = "";
      if (getname.toLowerCase() == "timespent") {
        String pretime;
        strExeQuery = "SELECT timespent,noofattempts,objecttypeid FROM cmi WHERE scoid=${cmiNew.scoid} AND userid=${cmiNew.userid} AND siteid=${cmiNew.siteid}";
        List<dynamic> data = await _database!.rawQuery(strExeQuery);

        if (data.isNotEmpty) {
          if (AppConfigurationOperations.isValidString(data[0]["timespent"])) {
            pretime = data[0]["timespent"];

            if (AppConfigurationOperations.isValidString(getvalue)) {
              List<String> strSplitvalues = pretime.split(":");
              List<String> strSplitvalues1 = getvalue.split(":");
              if (strSplitvalues.length == 3 && strSplitvalues1.length == 3) {
                try {
                  int hours1 = (int.parse(strSplitvalues[0]) + int.parse(strSplitvalues1[0])) * 3600;
                  int mins1 = (int.parse(strSplitvalues[1]) + int.parse(strSplitvalues1[1])) * 60;
                  int secs1 = (double.parse(strSplitvalues[2]) + double.parse(strSplitvalues1[2])).round();
                  int totaltime = hours1 + mins1 + secs1;
                  int longVal = totaltime;
                  int hours = (longVal / 3600).round();
                  int remainder = (longVal - hours * 3600).round();
                  int mins = (remainder / 60).round();
                  remainder = remainder - mins * 60;
                  int secs = remainder;

                  // cmiNew.set_timespent(hours+":"+mins+":"+secs);
                  getvalue = "$hours:$mins:$secs";
                } catch (err) {
                  MyPrint.printOnConsole("UpdateScormCMI failed $err");
                }
              }
            }
          }
          Map<String, dynamic> obj = data[0] as Map<String, dynamic>;
          String key = (obj.keys.toList())[1];
          if (['8', '9'].contains(data[0][key])) {
            if (!AppConfigurationOperations.isValidString(cmiNew.scoreraw)) {
            } else {
              int intNoAtt = int.parse(data[0][key]);

              intNoAtt = intNoAtt + 1;
              strExeQuery = "UPDATE CMI SET noofattempts=$intNoAtt, isupdate= 'false' WHERE scoid=${cmiNew.scoid} AND siteid=${cmiNew.siteid} AND userid=${cmiNew.userid}";

              await _database!.rawQuery(strExeQuery);
            }
          }
        }
      }

      strExeQuery = "UPDATE CMI SET $getname='$getvalue', isupdate= 'false' WHERE scoid=${cmiNew.scoid} AND siteid=${cmiNew.siteid} AND userid=${cmiNew.userid}";

      await _database!.rawQuery(strExeQuery);
    } catch (err) {
      MyPrint.printOnConsole("UpdateScormCMI failed $err");
    }
  }

  Future<int> updateContentStatusFromLRSInterface({required CourseDTOModel courseDTOModel, required double percantageCompleted}) async {
    if (!(await init())) return -1;

    int status = -1;
    try {
      String strUpdate = 'UPDATE $TBL_DOWNLOAD_DATA SET '
          'percentcompleted = \'$percantageCompleted\', '
          'progress = \'$percantageCompleted\' '
          'WHERE siteid = \'${courseDTOModel.SiteId}\' AND '
          'scoid= \'${courseDTOModel.ScoID}\' AND '
          'userid=\'${courseDTOModel.SiteUserID}\'';
      await _database!.rawQuery(strUpdate);
      status = 1;
    } catch (e) {
      status = -1;
      MyPrint.printOnConsole('updateContentStatus query failed: $e');
    }

    return status;
  }

  Future<int> updateContentStatusInTrackListLRS({required CourseDTOModel courseDTOModel, required String updatedStatus, bool isEventList = false}) async {
    MyPrint.printOnConsole("SqlDatabaseHandler().updateContentStatusInTrackListLRS() called with updatedStatus:$updatedStatus");

    if (!(await init())) return -1;

    int status = -1;
    String TBL_TYPE = TBL_TRACKLIST_DATA;

    if (isEventList) {
      TBL_TYPE = TBL_RELATED_CONTENT_DATA;
    }

    try {
      String strUpdate = 'UPDATE $TBL_TYPE SET '
          'progress = \'$updatedStatus\' '
          'WHERE siteid =\'${courseDTOModel.SiteId}\' AND '
          'scoid=\'${courseDTOModel.ScoID}\' AND '
          'userid=\'${courseDTOModel.SiteUserID}\'';
      await _database!.rawQuery(strUpdate);
      status = 1;
    } catch (e) {
      status = -1;
      MyPrint.printOnConsole('updateContentStatusInTrackListLRS query 1 failed $e');
    }

    try {
      String status = 'In progress';
      if (updatedStatus.toLowerCase().contains("failed")) {
        status = 'failed';
      } else if (updatedStatus.toLowerCase().contains("passed")) {
        status = 'passed';
      } else if (updatedStatus.toLowerCase().contains("completed")) {
        status = 'completed';
      }
      String strUpdate = 'UPDATE $TBL_CMI SET '
          'status = \'$status\' '
          'WHERE siteid =\'${courseDTOModel.SiteId}\' AND '
          'scoid=\'${courseDTOModel.ScoID}\' AND '
          'userid=\'${courseDTOModel.SiteUserID}\'';
      await _database!.rawQuery(strUpdate);
    } catch (e) {
      MyPrint.printOnConsole('updateContentStatusInTrackListLRS query 2 failed $e');
    }

    return status;
  }

  Future<String> savePercentCompletedInCMI({required CourseDTOModel courseDTOModel, double progressValue = 0}) async {
    if (!(await init())) return "";

    bool isRecordExists = await isCMIRecordExists(courseDTOModel: courseDTOModel);
    try {
      String strExeQuery = "";
      if (isRecordExists) {
        strExeQuery = 'UPDATE CMI SET '
            'percentageCompleted = \'$progressValue\', '
            'isupdate= \'false\' '
            'WHERE scoid=\'${courseDTOModel.ScoID}\' AND '
            'siteid=\'${courseDTOModel.SiteId}\' AND '
            'userid=\'${courseDTOModel.SiteUserID}\'';
      } else {
        strExeQuery = "INSERT INTO $TBL_CMI(siteid,scoid,userid,location,status,suspenddata,objecttypeid,datecompleted,noofattempts,percentageCompleted,sequencenumber,"
            "isupdate,startdate,timespent,coursemode,scoremin,scoremax,randomquesseq,siteurl,textResponses) VALUES (${courseDTOModel.SiteId},${courseDTOModel.ScoID},${courseDTOModel.SiteUserID},'','incomplete','','${courseDTOModel.ContentTypeId}','',1,'$progressValue','','false','','','','','','','','')";
      }
      await _database!.rawQuery(strExeQuery);
    } catch (e) {
      MyPrint.printOnConsole("savePercentCompletedInCMI failed: $e");
    }

    return "true";
  }

  Future<bool> isCMIRecordExists({required CourseDTOModel courseDTOModel}) async {
    if (!(await init())) return false;

    bool isRecordExists = false;
    try {
      String strExeQuery = 'SELECT * FROM $TBL_CMI '
          'WHERE siteid= \'${courseDTOModel.SiteId}\' AND '
          'userid= \'${courseDTOModel.SiteUserID}\' AND '
          'scoid = \'${courseDTOModel.ScoID}\'';
      List data = await _database!.rawQuery(strExeQuery);

      isRecordExists = data.isNotEmpty;
    } catch (e) {
      MyPrint.printOnConsole('isCMIRecordExists query failed: $e');
    }

    return isRecordExists;
  }

  Future<void> updateCMIStartDate({required int siteId, required String scoID, required String startDate, required String userID}) async {
    if (!(await init())) return;

    try {
      String strUpdate = "UPDATE $TBL_CMI SET "
          "startdate = '$startDate' "
          "WHERE scoid = $scoID and "
          "userid = $userID and "
          "siteid =$siteId";
      _database!.rawQuery(strUpdate);
    } catch (err) {
      MyPrint.printOnConsole('updateCMIStartDate failed $err');
    }
  }

  Future<String> saveQuestionDataWithQuestionDataMethod({required CourseDTOModel courseDTOModel, String questionData = "", String seqID = ""}) async {
    if (!(await init())) return "";

    try {
      String externalDirectory = await AppController.getDocumentsDirectory();
      String uploadfilepath = '$externalDirectory/.Mydownloads';
      String strTempUploadPath = "${uploadfilepath.substring(1, uploadfilepath.lastIndexOf("/"))}/Offline_Attachments";

      String tempStr = questionData.replaceAll("undefined", "");
      List<String> quesAry = tempStr.split("@");
      int scoID = courseDTOModel.ScoID;

      int assessmentAttempt = await getAssessmentAttempt(courseDTOModel: courseDTOModel, reTake: false);

      int ContentTypeId = 0;

      if (quesAry.length > 3) {
        if (courseDTOModel.ContentTypeId == InstancyObjectTypes.track && seqID.isNotEmpty) {
          ({int ContentTypeId, int ScoId})? objectTypeIDScoidResponse = await getTrackObjectTypeIDAndScoidBasedOnSequenceNumber(
            ScoID: courseDTOModel.ScoID,
            SiteId: courseDTOModel.SiteId,
            UserID: courseDTOModel.SiteUserID,
            seqNumber: seqID,
          );

          if (objectTypeIDScoidResponse != null) {
            ContentTypeId = objectTypeIDScoidResponse.ContentTypeId;
            scoID = objectTypeIDScoidResponse.ScoId;
          }
        } else {
          ContentTypeId = courseDTOModel.ContentTypeId;
        }
        StudentResponseModel studentResponse = StudentResponseModel();
        studentResponse.scoid = scoID;
        studentResponse.siteid = courseDTOModel.SiteId;
        studentResponse.userid = courseDTOModel.SiteUserID;

        studentResponse.studentresponses = quesAry[2];
        studentResponse.result = quesAry[3];
        studentResponse.assessmentattempt = assessmentAttempt;
        String formattedDate = getCurrentDateTime();
        studentResponse.attemptdate = formattedDate;

        if (ContentTypeId == InstancyObjectTypes.contentObject) {
          studentResponse.questionid = int.parse(quesAry[0]) + 1;
        } else {
          studentResponse.questionid = int.parse(quesAry[0]);
        }

        if (quesAry.length > 4) {
          String tempOptionalNotes = quesAry[4];

          if (tempOptionalNotes.contains("^notes^")) {
            tempOptionalNotes = tempOptionalNotes.replaceAll("^notes^", "");
            studentResponse.optionalnotes = tempOptionalNotes;
          } else {
            if (quesAry.length > 5) {
              studentResponse.attachfilename = quesAry[4];
              studentResponse.attachfileid = quesAry[5];
              String strManyDirectories = "${strTempUploadPath.substring(1, strTempUploadPath.lastIndexOf("/"))}/Offline_Attachments/";
              studentResponse.attachedfilepath = strManyDirectories + quesAry[5];
            }
          }

          if (quesAry.length > 6) {
            if (quesAry[6].isEmpty && quesAry[6] == "undefined") {
              studentResponse.capturedvidfilename = "";
              studentResponse.capturedvidid = "";
              studentResponse.capturedVidFilepath = "";
            }

            studentResponse.capturedvidfilename = quesAry[6];
            studentResponse.capturedvidid = quesAry[7];
            String strManyDirectories = "${strTempUploadPath.substring(1, strTempUploadPath.lastIndexOf("/"))}/mediaresource/mediacapture/";
            studentResponse.capturedVidFilepath = strManyDirectories + quesAry[7];
          }

          if (quesAry.length > 8) {
            if (quesAry[8].isEmpty || quesAry[8] == "undefined") {
              studentResponse.capturedimgfilename = "";
              studentResponse.capturedimgid = "";
              studentResponse.capturedImgFilepath = "";
            }

            studentResponse.capturedimgfilename = quesAry[8];
            studentResponse.capturedimgid = quesAry[9];
            String strManyDirectories = "${strTempUploadPath.substring(1, strTempUploadPath.lastIndexOf("/"))}/mediaresource/mediacapture/";
            studentResponse.capturedImgFilepath = strManyDirectories + quesAry[9];
          }
        } else {
          studentResponse.attachfilename = "";
          studentResponse.attachfileid = "";
          studentResponse.attachedfilepath = "";
          studentResponse.index = 0;
          studentResponse.optionalnotes = "";

          studentResponse.capturedvidfilename = "";
          studentResponse.capturedvidid = "";

          studentResponse.capturedimgfilename = "";
          studentResponse.capturedimgid = "";
          studentResponse.capturedImgFilepath = "";
        }
        insertStudentResponses(resDetails: studentResponse);
      }

      return "true";
    } catch (e) {
      MyPrint.printOnConsole('SaveQuestionDataWithQuestionDataMethod failed: $e');
      return 'false';
    }
  }

  Future<int> getAssessmentAttempt({required CourseDTOModel courseDTOModel, bool reTake = false}) async {
    if (!(await init())) return 1;

    int attempt = 1;
    try {
      String strSelQuery = "SELECT noofattempts FROM cmi  WHERE siteid=${courseDTOModel.SiteId} AND scoid=${courseDTOModel.ScoID} AND userid=${courseDTOModel.SiteUserID}";
      List<dynamic> data = await _database!.rawQuery(strSelQuery);
      if (data.isNotEmpty) {
        attempt = data[0]['noofattempts'];
        if (attempt == 0) attempt = attempt + 1;

        if (reTake) {
          String strDelQuery = "DELETE FROM STUDENTRESPONSES WHERE siteid=${courseDTOModel.SiteId} AND scoid=${courseDTOModel.ScoID} AND userid=${courseDTOModel.SiteUserID}";
          _database!.rawQuery(strDelQuery);
          attempt = 1;
        }
      }
    } catch (e) {
      MyPrint.printOnConsole('Getassessmentattempt failed: $e');
    }
    return attempt;
  }

  Future<({int ContentTypeId, int ScoId})?> getTrackObjectTypeIDAndScoidBasedOnSequenceNumber({
    required int SiteId,
    required int ScoID,
    required int UserID,
    String seqNumber = "",
  }) async {
    ({int ContentTypeId, int ScoId})? response;

    if (!(await init())) return response;

    String sqlQuery = "SELECT scoid, objecttypeid FROM $TBL_TRACK_OBJECTS WHERE siteid = $SiteId AND trackscoid = $ScoID AND sequencenumber = $seqNumber AND userid = $UserID";

    List<Map<String, Object?>> data = await _database!.rawQuery(sqlQuery);

    try {
      if (data.isNotEmpty) {
        response = (ContentTypeId: ParsingHelper.parseIntMethod(data.first['objecttypeid']), ScoId: ParsingHelper.parseIntMethod(data.first['objecttypeid']));
      }
    } catch (e) {
      MyPrint.printOnConsole('getTrackObjectTypeIDAndScoidBasedOnSequenceNumber failed: $e');
    }
    return response;
  }

  Future<void> insertStudentResponses({required StudentResponseModel resDetails}) async {
    if (!(await init())) return;

    if (!AppConfigurationOperations.isValidString(resDetails.attachfilename)) {
      resDetails.attachfileid = "";
      resDetails.attachfilename = "";
      resDetails.attachedfilepath = "";
    }

    if (!AppConfigurationOperations.isValidString(resDetails.optionalnotes)) {
      resDetails.optionalnotes = "";
    }

    if (!AppConfigurationOperations.isValidString(resDetails.capturedvidfilename)) {
      resDetails.capturedvidfilename = "";
      resDetails.capturedvidid = "";
      resDetails.capturedVidFilepath = "";
    }

    if (!AppConfigurationOperations.isValidString(resDetails.capturedimgfilename)) {
      resDetails.capturedimgfilename = "";
      resDetails.capturedimgid = "";
      resDetails.capturedImgFilepath = "";
    }

    bool isStudentResExist = false;

    try {
      String query1 =
          "SELECT MAX(AssessmentAttempt) AS assessmentnumber from studentresponses WHERE scoid=${resDetails.scoid} and userid=${resDetails.userid} and questionid=${resDetails.questionid} and siteid=${resDetails.siteid}";
      List<Map<String, dynamic>> data = await _database!.rawQuery(query1);

      int assesmentNumber = 1;
      int quesAttempt = 1;

      if (data.isNotEmpty) {
        String key1 = data.first.keys.first;
        if (data.first['$key1'] != null) {
          assesmentNumber = data.first['$key1'];
          MyPrint.printOnConsole('insertStudentResponses assesmentNumber $assesmentNumber');
        }
      }

      String query2 =
          "SELECT QUESTIONID FROM studentresponses WHERE scoid=${resDetails.scoid} and userid=${resDetails.userid} and questionid=${resDetails.questionid} and siteid=${resDetails.siteid} and AssessmentAttempt=$assesmentNumber";

      List<Map<String, dynamic>> data2 = await _database!.rawQuery(query2);

      if (data2.isNotEmpty) {
        isStudentResExist = true;
      }

      String query3 = "";
      if (isStudentResExist) {
        query3 =
            "UPDATE studentresponses SET studentresponses ='${resDetails.studentresponses}',result='${resDetails.result}',attachfilename= '${resDetails.attachfilename}',attachfileid='${resDetails.attachfileid}' ,attachedfilepath='${resDetails.attachedfilepath}' ,optionalNotes='${resDetails.optionalnotes}' ,capturedVidFileName ='${resDetails.capturedvidfilename}' ,capturedVidId ='${resDetails.capturedvidid}' ,capturedVidFilepath ='${resDetails.capturedVidFilepath}' ,capturedImgFileName ='${resDetails.capturedimgfilename}' ,capturedImgId ='${resDetails.capturedimgid}' ,capturedImgFilepath ='${resDetails.capturedImgFilepath}' where scoid=${resDetails.scoid} and userid=${resDetails.userid} and questionid=${resDetails.questionid} and siteid=${resDetails.siteid} and assessmentattempt=$assesmentNumber";
      } else {
        query3 =
            "INSERT INTO $TBL_STUDENT_RESPONSES(siteid,scoid,userid,questionid,assessmentattempt,questionattempt,attemptdate,studentresponses,result,attachfilename,attachfileid,attachedfilepath,optionalNotes,capturedVidFileName,capturedVidId,capturedVidFilepath,capturedImgFileName,capturedImgId,capturedImgFilepath) values (${resDetails.siteid},${resDetails.scoid},${resDetails.userid},${resDetails.questionid},$assesmentNumber,$quesAttempt,'${resDetails.attemptdate}','${resDetails.studentresponses}','${resDetails.result}','${resDetails.attachfilename}','${resDetails.attachfileid}','${resDetails.attachedfilepath}','${resDetails.optionalnotes}','${resDetails.capturedvidfilename}','${resDetails.capturedvidid}','${resDetails.capturedVidFilepath}','${resDetails.capturedimgfilename}','${resDetails.capturedimgid}','${resDetails.capturedImgFilepath}')";
      }
      await _database!.rawQuery(query3);
    } catch (e) {
      MyPrint.printOnConsole('insertStudentResponses failed $e');
    }
  }

  Future<String> getTrackObjectList({required CourseDTOModel courseDTOModel, String lStatusValue = "", String susData = "", String cmiSeqNumber = ""}) async {
    if (!(await init())) return "";

    String query = "";
    String locationValue = "";
    String statusValue = "";
    String suspendDataValue = "";
    String question = "";
    String tempSeqNo = "";

    String sqlQuery =
        "SELECT C.status,C.suspenddata,C.location,T.sequencenumber FROM CMI C inner join $TBL_TRACK_OBJECTS T on C.scoid=T.scoid AND C.userid=T.userid WHERE C.siteid =${courseDTOModel.SiteId} AND C.userid = ${courseDTOModel.SiteUserID} AND T.TrackSCOID =${courseDTOModel.ScoID} order by T.SequenceNumber ";
    try {
      List<Map<String, dynamic>> data = await _database!.rawQuery(sqlQuery);

      if (data.isNotEmpty) {
        for (Map<String, dynamic> item in data) {
          String status = "";
          String suspendData = "";
          String location = "";
          String sequenceNo = "";

          status = item['status'];
          suspendData = item['suspenddata'];
          location = item['location'];
          sequenceNo = item['sequencenumber'];

          if (!equalsIgnoreCase(statusValue, "null") && statusValue.isNotEmpty) {
            statusValue = "$statusValue@$status\$$sequenceNo";
          } else {
            statusValue = "$status\$$sequenceNo";
          }

          if (!equalsIgnoreCase(suspendDataValue, "null") && suspendDataValue.isNotEmpty) {
            suspendDataValue = "$suspendDataValue@$suspendData\$$sequenceNo";
          } else {
            suspendDataValue = "$suspendData\$$sequenceNo";
          }

          if (!equalsIgnoreCase(locationValue, "null") && locationValue.isNotEmpty) {
            locationValue = "$locationValue@$location\$$sequenceNo";
          } else {
            locationValue = "$location\$$sequenceNo";
          }
        }
      }
    } catch (e) {
      MyPrint.printOnConsole('getTrackObjectList failed: $e');
    }

    try {
      String sqlQuery =
          "select S.QUESTIONID,S.StudentResponses,S.result,S.attachfilename,S.attachfileid,T.Sequencenumber,S.OptionalNotes,S.capturedVidFileName,S.capturedVidId,S.capturedImgFileName,S.capturedImgId from $TBL_STUDENT_RESPONSES S inner join $TBL_TRACK_OBJECTS T on S.scoid=T.scoid AND S.userid=T.userid WHERE S.SITEID =${courseDTOModel.SiteId} AND S.USERID =${courseDTOModel.SiteUserID} AND T.TrackSCOID = ${courseDTOModel.ScoID} AND S.assessmentattempt = (select max(assessmentattempt) from $TBL_STUDENT_RESPONSES where scoid= T.scoid) order by T.SequenceNumber";

      List<Map<String, dynamic>> data = await _database!.rawQuery(sqlQuery);

      if (data.isNotEmpty) {
        for (Map<String, dynamic> item in data) {
          if (question.isNotEmpty) {
            question = "$question\$";
          }

          String sqNO = "";
          String seqNo = item['sequencenumber'];

          if (!equalsIgnoreCase(seqNo, "null") && seqNo.isNotEmpty) {
            sqNO = seqNo;
          }

          if (!tempSeqNo.toLowerCase().contains(sqNO)) {
            if (!equalsIgnoreCase(question, "null") && question.isNotEmpty) {
              question = "$question~";
            }
            tempSeqNo = seqNo;
            question = "$question$seqNo-";
          }

          String questionID = item['questionid'];

          if (!equalsIgnoreCase(questionID, "null") && !questionID.isNotEmpty) {
            question = question + questionID;
            question = "$question@";
          }

          String studentResponse = "";
          String studentresp = item['studentresponses'];

          if (!equalsIgnoreCase(studentresp, "null") && studentresp.isNotEmpty) {
            if ((equalsIgnoreCase(studentresp.toLowerCase(), "undefined")) || equalsIgnoreCase(studentResponse, "null")) {
              studentResponse = "";
            } else {
              studentResponse = studentresp;
            }
          }
          question = question + studentResponse;
          question = "$question@";

          String result = item['result'];

          if (!equalsIgnoreCase(result, "null") && result.isNotEmpty) {
            question = question + result;
            question = "$question@";
          }

          String attachFile = item['attachfilename'];

          if (!equalsIgnoreCase(attachFile, "null") && attachFile.isNotEmpty) {
            question = question + attachFile;
            question = "$question@";
          }

          String attachFileID = item['attachfileid'];

          if (!equalsIgnoreCase(attachFileID, "null") && attachFileID.isNotEmpty) {
            question = question + attachFileID;
            question = "$question@";
          }

          String optionalNotes = item['optionalNotes'];

          if (!equalsIgnoreCase(optionalNotes, "null") && optionalNotes.isNotEmpty) {
            question = question + optionalNotes;
            question = "$question@";
          }

          String capturedVidFileName = item['capturedVidFileName'];

          if (!equalsIgnoreCase(capturedVidFileName, "null") && capturedVidFileName.isNotEmpty) {
            question = question + capturedVidFileName;
            question = "$question@";
          }

          String capturedVidID = item['capturedVidId'];

          if (!equalsIgnoreCase(capturedVidID, "null") && capturedVidID.isNotEmpty) {
            question = question + capturedVidID;
            question = "$question@";
          }

          String capturedImgFileName = item['capturedImgFileName'];

          if (!equalsIgnoreCase(capturedImgFileName, "null") && capturedImgFileName.isNotEmpty) {
            question = question + capturedImgFileName;
            question = "$question@";
          }

          String capturedImgID = item['capturedImgId'];

          if (!equalsIgnoreCase(capturedImgID, "null") && capturedImgID.isNotEmpty) {
            question = question + capturedImgID;
            question = "$question@";
          }
        }
      }
    } catch (e) {
      MyPrint.printOnConsole('');
    }

    MyPrint.printOnConsole('getTrackObjectList: $question');
    question = question.replaceAll("%25", "%");

    MyPrint.printOnConsole('getTrackObjectList: $suspendDataValue');

    // String displayName = mylearningModel.userName;
    String displayName = "";

    String replaceString = displayName.replaceAll(" ", "%20");

    query =
        "?nativeappURL=true&cid=${courseDTOModel.ScoID}&stid=${courseDTOModel.SiteUserID}&lloc=$locationValue&lstatus=$lStatusValue&susdata=$susData&tbookmark=$cmiSeqNumber&LtSusdata=$suspendDataValue&LtQuesData=$question&LtStatus=$statusValue&sname=$replaceString";

    query = query.replaceAll("null", "");

    String replaceStr = query.replaceAll(" ", "%20");
    return replaceStr;
  }

  Future<int> getLatestAttempt({required String scoId, required String userId, required String siteID}) async {
    if (!(await init())) return 0;

    String sqlQuery = "SELECT count(sessionid) as attemptscount FROM $TBL_USER_SESSION WHERE siteid = $siteID AND scoid = '$scoId' AND userid = $userId";

    List<Map<String, dynamic>> userSessionData = await _database!.rawQuery(sqlQuery);

    int numberOfAttemptsInt = 0;
    try {
      if (userSessionData.isNotEmpty) {
        for (Map<String, dynamic> item in userSessionData) {
          String counts = item['attemptscount'];
          numberOfAttemptsInt = int.parse(counts);
        }
      }
    } catch (e) {
      MyPrint.printOnConsole('getLatestAttempt failed: $e');
    }

    return numberOfAttemptsInt + 1;
  }

  Future<void> insertUserSession({required LearnerSessionModel sessionDetails}) async {
    if (!(await init())) return;

    String strExeQuery = "";
    if (sessionDetails.timespent.isEmpty) {
      sessionDetails.timespent = "00:00:00";
    }
    try {
      strExeQuery =
          "SELECT * FROM $TBL_USER_SESSION WHERE scoid=${sessionDetails.scoid} AND userid=${sessionDetails.userid} AND attemptnumber=${sessionDetails.attemptnumber} AND siteid=${sessionDetails.siteid}";
      List<Map<String, dynamic>> data = await _database!.rawQuery(strExeQuery);

      if (data.isNotEmpty) {
        try {
          strExeQuery =
              "UPDATE $TBL_USER_SESSION SET timespent='${sessionDetails.timespent}' WHERE scoid=${sessionDetails.scoid} AND siteid=${sessionDetails.siteid} AND userid=${sessionDetails.userid} AND attemptnumber=${sessionDetails.attemptnumber}";
          await _database!.execute(strExeQuery);
        } catch (e) {
          MyPrint.printOnConsole("InsertUserSession failed: $e");
        }
      } else {
        try {
          strExeQuery =
              "INSERT INTO $TBL_USER_SESSION(siteid,scoid,userid,attemptnumber,sessiondatetime,timespent) VALUES (${sessionDetails.siteid},${sessionDetails.scoid},${sessionDetails.userid},${sessionDetails.attemptnumber},'${sessionDetails.sessiondatetime}','${sessionDetails.timespent}')";
          await _database!.execute(strExeQuery);
        } catch (e) {
          MyPrint.printOnConsole("InsertUserSession failed: $e");
        }
      }
    } catch (e) {
      MyPrint.printOnConsole("InsertUserSession failed: $e");
    }
  }

  Future<void> setCompleteMethods({required CourseDTOModel courseDTOModel, String? suspenddata}) async {
    if (!(await init())) return;

    try {
      await insertCMI(courseDTOModel: courseDTOModel, suspenddata: suspenddata);
    } catch (e) {
      MyPrint.printOnConsole('setCompleteMethods failed $e');
    }
  }

  Future<void> insertCMI({required CourseDTOModel courseDTOModel, String? suspenddata, double? score}) async {
    if (!(await init())) return;

    try {
      Map<String, dynamic> data = <String, dynamic>{
        if (suspenddata != null) "suspenddata": suspenddata,
        if (score != null) "score": score,
      };

      String updateKeyValues = "";
      data.forEach((key, value) {
        updateKeyValues += "$key='$value',";
      });
      if (updateKeyValues.endsWith(",")) updateKeyValues = updateKeyValues.substring(0, updateKeyValues.length - 1);

      String strExeQuery = "UPDATE $TBL_CMI SET $updateKeyValues WHERE scoid=${courseDTOModel.ScoID} AND siteid=${courseDTOModel.SiteId} AND userid=${courseDTOModel.SiteUserID}";

      await _database!.rawQuery(strExeQuery);
    } catch (e) {
      MyPrint.printOnConsole('insertCMI failed: $e');
    }
  }

  Future<void> updateCMIstatus({required CourseDTOModel courseDTOModel, required String updatedStatus, required int progressValue, required String datecompleted}) async {
    MyPrint.printOnConsole("SqlDatabaseHandler().updateCMIstatus() called with updatedStatus:$updatedStatus");

    if (!(await init())) return;

    try {
      bool isRecordExists = await isCMIRecordExists(courseDTOModel: courseDTOModel);
      String query = '';
      if (!isRecordExists) {
        query = "INSERT INTO $TBL_CMI(siteid,scoid,userid,location,status,suspenddata,objecttypeid,datecompleted,noofattempts,percentageCompleted,sequencenumber,"
                "isupdate,startdate,timespent,coursemode,scoremin,scoremax,randomquesseq,siteurl,textResponses)" +
            " VALUES (${courseDTOModel.SiteId},${courseDTOModel.ScoID},${courseDTOModel.SiteUserID},'','$updatedStatus','','${courseDTOModel.ContentTypeId}','$datecompleted',1,'$progressValue','0','false','','','','','','','','')";
      } else {
        query =
            "UPDATE $TBL_CMI SET status = '$updatedStatus', isupdate= 'false', datecompleted = '$datecompleted' WHERE siteid='${courseDTOModel.SiteId}' AND scoid='${courseDTOModel.ScoID}' AND userid='${courseDTOModel.SiteUserID}'";
      }
      await _database!.rawQuery(query);
    } catch (err) {
      MyPrint.printOnConsole('updateCMIstatus failed: $err');
    }
  }

  String getCurrentDateTime() {
    return DatePresentation.getFormattedDate(dateFormat: "yyyy-MM-dd HH:mm:ss", dateTime: DateTime.now()) ?? "";
  }

  //region Workflow Rules Related Methods
  Future<String> getTrackTemplateWorkflowResults({required CourseDTOModel courseDTOModel, required String trackContentId}) async {
    if (!(await init())) return "";

    String returnStr = "";

    String selQuery =
        "SELECT trackContentId, userid, showstatus, ruleid, stepid, contentid, wmessage FROM $TBL_TRACKLIST_DATA WHERE trackContentId = '$trackContentId' AND userid = '${courseDTOModel.SiteUserID}' AND siteid = '${courseDTOModel.SiteId}'";

    List<Map<String, dynamic>> userSessionData = await _database!.rawQuery(selQuery);

    List<Map<String, dynamic>> jsonArray = <Map<String, dynamic>>[];

    for (Map<String, dynamic> map in userSessionData) {
      String ruleID = map['ruleid']?.toString() ?? "";

      if (ruleID == "0") {
        break;
      }

      Map<String, dynamic> trackObj = <String, dynamic>{};
      try {
        trackObj["userid"] = map["userid"];
        trackObj["trackcontentid"] = map["trackContentId"];
        trackObj["trackobjectid"] = map["contentid"];
        trackObj["result"] = map["showstatus"];
        trackObj["wmessage"] = map["wmessage"];
        trackObj["ruleid"] = ruleID;
        trackObj["stepid"] = map["stepid"];
        jsonArray.add(trackObj);
      } catch (e, s) {
        MyPrint.printOnConsole("Error in getTrackTemplateWorkflowResults:$e");
        MyPrint.printOnConsole(s);
      }
    }

    if (jsonArray.isEmpty) {
      returnStr = "";
    } else {
      returnStr = jsonArray.toString();
    }

    return returnStr;
  }

  Future<void> updateWorkFlowRulesInDBForTrackTemplate(
      {required CourseDTOModel courseDTOModel, required String trackContentId, String trackItemState = "", String wmessage = "", String ruleID = "", String stepID = ""}) async {
    if (!(await init())) return;

    try {
      String sqlQuery =
          "UPDATE $TBL_TRACKLIST_DATA SET showstatus = '$trackItemState' , ruleid = '$ruleID' , stepid = '$stepID', wmessage = '$wmessage' WHERE trackContentId = '$trackContentId'  AND contentid = '${courseDTOModel.ContentID}'  AND siteid =' ${courseDTOModel.SiteId}'  AND userid =  '${courseDTOModel.SiteUserID}'";

      List<Map<String, dynamic>> userSessionData = await _database!.rawQuery(sqlQuery);
    } catch (e, s) {
      MyPrint.printOnConsole("Error in updateWorkFlowRulesInDBForTrackTemplate:$e");
      MyPrint.printOnConsole(s);
    }
  }
//endregion
}
