class GetPeopleListRequestModel {
  int ComponentID = 0;
  int ComponentInstanceID = 0;
  int UserID = 0;
  int SiteID = 0;
  int pageIndex = 0;
  int pageSize = 0;
  String Locale = "";
  String sortBy = "";
  String sortType = "";
  String SearchText = "";
  String filterType = "";
  String TabID = "";
  String contentid = "";
  String AdditionalParams = "";
  String firstname = "";
  String lastname = "";
  String location = "";
  String company = "";
  String skillcats = "";
  String skills = "";
  String skilllevels = "";
  String jobroles = "";

  GetPeopleListRequestModel({
    this.ComponentID = 0,
    this.ComponentInstanceID = 0,
    this.UserID = 0,
    this.SiteID = 0,
    this.pageIndex = 0,
    this.pageSize = 0,
    this.Locale = "",
    this.sortBy = "",
    this.sortType = "",
    this.SearchText = "",
    this.filterType = "",
    this.TabID = "",
    this.contentid = "",
    this.AdditionalParams = "",
    this.firstname = "",
    this.lastname = "",
    this.location = "",
    this.company = "",
    this.skillcats = "",
    this.skills = "",
    this.skilllevels = "",
    this.jobroles = "",
  });

  Map<String, dynamic> toJson() {
    return {
      "ComponentID" : ComponentID,
      "ComponentInstanceID" : ComponentInstanceID,
      "UserID" : UserID,
      "SiteID" : SiteID,
      "pageIndex" : pageIndex,
      "pageSize" : pageSize,
      "Locale" : Locale,
      "sortBy" : sortBy,
      "sortType" : sortType,
      "SearchText" : SearchText,
      "filterType" : filterType,
      "TabID" : TabID,
      "contentid" : contentid,
      "AdditionalParams" : AdditionalParams,
      "firstname" : firstname,
      "lastname" : lastname,
      "location" : location,
      "company" : company,
      "skillcats" : skillcats,
      "skills" : skills,
      "skilllevels" : skilllevels,
      "jobroles" : jobroles,
    };
  }
}