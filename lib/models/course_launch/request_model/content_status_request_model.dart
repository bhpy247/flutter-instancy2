import '../../../utils/my_utils.dart';

class ContentStatusRequestModel {
  int userId = 0;
  int scoId = 0;
  int? TrackObjectTypeID;
  int? TrackScoID;
  int SiteID = 0;
  int OrgUnitID = 0;
  String? TrackContentID;
  String? isonexist/* = "onexit"*/;

  ContentStatusRequestModel({
    this.userId = 0,
    this.scoId = 0,
    this.TrackObjectTypeID,
    this.TrackScoID,
    this.SiteID = 0,
    this.OrgUnitID = 0,
    this.TrackContentID,
    this.isonexist,
  });

  Map<String, String> toJson() {
    return {
      "userId": userId.toString(),
      "scoId": scoId.toString(),
      if(TrackObjectTypeID != null) "TrackObjectTypeID": TrackObjectTypeID.toString(),
      if(TrackScoID != null) "TrackScoID": TrackScoID.toString(),
      "SiteID": SiteID.toString(),
      "OrgUnitID": OrgUnitID.toString(),
      if(TrackContentID != null) "TrackContentID": TrackContentID.toString(),
      if(isonexist != null) "isonexist": isonexist.toString(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}