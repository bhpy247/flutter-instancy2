class ContentFilterParamsModel {
  int? SiteID;
  int? UserID;
  int? ComponentID;
  int? CatalogCategoriesID;
  String Type;
  String ShowAllItems;
  String FilterContentType;
  String FilterMediaType;
  String EventType;
  String SprateEvents;
  String IsCompetencypath;
  String Locale;

  ContentFilterParamsModel({
    this.SiteID,
    this.UserID,
    this.ComponentID,
    this.CatalogCategoriesID,
    this.Type = "",
    this.ShowAllItems = "",
    this.FilterContentType = "",
    this.FilterMediaType = "",
    this.EventType = "",
    this.SprateEvents = "",
    this.IsCompetencypath = "",
    this.Locale = "",
  });

  Map<String, String> toMap() {
    return <String, String>{
      if(SiteID != null) "SiteID" : SiteID.toString(),
      if(UserID != null) "UserID" : UserID.toString(),
      if(ComponentID != null) "ComponentID" : ComponentID.toString(),
      if(CatalogCategoriesID != null) "CatalogCategoriesID" : CatalogCategoriesID.toString(),
      "Type" : Type,
      "ShowAllItems" : ShowAllItems,
      "FilterContentType" : FilterContentType,
      "FilterMediaType" : FilterMediaType,
      "EventType" : EventType,
      "SprateEvents" : SprateEvents,
      "IsCompetencypath" : IsCompetencypath,
      "Locale" : Locale,
    };
  }
}