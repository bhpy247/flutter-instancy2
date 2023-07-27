import 'package:flutter_instancy_2/configs/app_constants.dart';

class EnabledContentFilterByTypeModel {
  bool sorting = false;
  bool categories = false;
  bool skills = false;
  bool objecttypeid = false;
  bool jobroles = false;
  bool locations = false;
  bool userinfo = false;
  bool company = false;
  bool solutions = false;
  bool learningprovider = false;
  bool ecommerceprice = false;
  bool rating = false;
  bool locationname = false;
  bool eventduration = false;
  bool instructor = false;
  bool eventdates = false;
  bool creditpoints = false;

  EnabledContentFilterByTypeModel({
    this.sorting = false,
    this.categories = false,
    this.skills = false,
    this.objecttypeid = false,
    this.jobroles = false,
    this.locations = false,
    this.userinfo = false,
    this.company = false,
    this.solutions = false,
    this.learningprovider = false,
    this.ecommerceprice = false,
    this.rating = false,
    this.locationname = false,
    this.instructor = false,
    this.eventdates = false,
    this.creditpoints = false,
  });

  EnabledContentFilterByTypeModel.copyFrom(EnabledContentFilterByTypeModel enabledContentFilterByTypeModel) {
    sorting = enabledContentFilterByTypeModel.sorting;
    categories = enabledContentFilterByTypeModel.categories;
    skills = enabledContentFilterByTypeModel.skills;
    objecttypeid = enabledContentFilterByTypeModel.objecttypeid;
    jobroles = enabledContentFilterByTypeModel.jobroles;
    locations = enabledContentFilterByTypeModel.locations;
    userinfo = enabledContentFilterByTypeModel.userinfo;
    company = enabledContentFilterByTypeModel.company;
    solutions = enabledContentFilterByTypeModel.solutions;
    learningprovider = enabledContentFilterByTypeModel.learningprovider;
    ecommerceprice = enabledContentFilterByTypeModel.ecommerceprice;
    rating = enabledContentFilterByTypeModel.rating;
    locationname = enabledContentFilterByTypeModel.locationname;
    eventduration = enabledContentFilterByTypeModel.eventduration;
    instructor = enabledContentFilterByTypeModel.instructor;
    eventdates = enabledContentFilterByTypeModel.eventdates;
    creditpoints = enabledContentFilterByTypeModel.creditpoints;
  }

  EnabledContentFilterByTypeModel.fromList(List<String> contentFilterByList) {
    _initializeFromList(contentFilterByList);
  }

  void updateFromList(List<String> contentFilterByList) {
    _initializeFromList(contentFilterByList);
  }

  void _initializeFromList(List<String> contentFilterByList) {
    sorting = contentFilterByList.contains(ContentFilterByTypes.SortItems) || contentFilterByList.contains(ContentFilterByTypes.sortItems);
    categories = contentFilterByList.contains(ContentFilterByTypes.categories);
    skills = contentFilterByList.contains(ContentFilterByTypes.skills);
    objecttypeid = contentFilterByList.contains(ContentFilterByTypes.objecttypeid);
    jobroles = contentFilterByList.contains(ContentFilterByTypes.jobroles) || contentFilterByList.contains(ContentFilterByTypes.job);
    locations = contentFilterByList.contains(ContentFilterByTypes.locations);
    userinfo = contentFilterByList.contains(ContentFilterByTypes.userinfo);
    company = contentFilterByList.contains(ContentFilterByTypes.company);
    solutions = contentFilterByList.contains(ContentFilterByTypes.solutions);
    learningprovider = contentFilterByList.contains(ContentFilterByTypes.learningprovider);
    ecommerceprice = contentFilterByList.contains(ContentFilterByTypes.ecommerceprice);
    rating = contentFilterByList.contains(ContentFilterByTypes.rating);
    locationname = contentFilterByList.contains(ContentFilterByTypes.locationname);
    eventduration = contentFilterByList.contains(ContentFilterByTypes.eventduration);
    instructor = contentFilterByList.contains(ContentFilterByTypes.instructor);
    eventdates = contentFilterByList.contains(ContentFilterByTypes.eventdates);
    creditpoints = contentFilterByList.contains(ContentFilterByTypes.creditpoints);
  }



  /*@override
  String toString() {
    return MyUtils.encodeJson(object);
  }*/
}