class ComponentSortParamsModel {
  int? OrgUnitID;
  int? UserID;
  int? ComponentID;
  String LocaleID;

  ComponentSortParamsModel({
    this.OrgUnitID,
    this.UserID,
    this.ComponentID,
    this.LocaleID = "",
  });

  Map<String, String> toMap() {
    return <String, String>{
      if(OrgUnitID != null) "OrgUnitID" : OrgUnitID.toString(),
      if(UserID != null) "UserID" : UserID.toString(),
      if(ComponentID != null) "ComponentID" : ComponentID.toString(),
      "Locale" : LocaleID,
    };
  }
}