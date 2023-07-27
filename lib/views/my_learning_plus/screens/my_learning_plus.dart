import 'package:flutter/material.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';

import '../../../backend/app_theme/style.dart';
import '../../common/components/common_cached_network_image.dart';

class MyLearningPlus extends StatefulWidget {
  static const String routeName = "/myLearningPlus";
  const MyLearningPlus({Key? key}) : super(key: key);

  @override
  State<MyLearningPlus> createState() => _MyLearningPlusState();
}

class _MyLearningPlusState extends State<MyLearningPlus> with SingleTickerProviderStateMixin{

  late ThemeData themeData;


  TabController? controller;

  int selectedIndex = 0;


  @override
  void initState() {
    super.initState();

    controller = TabController(vsync: this, length: 8);

  }
  @override
  Widget build(BuildContext context) {

    themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: themeData.primaryColor,
      body: getMainBodyWidget(),
    );
  }

  Widget getMainBodyWidget(){
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        color: Styles.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          getTrackDetailComponentWidget(),
          Expanded(child: tabBarView())
        ],
      ),
    );
  }

  //region myLearningComponent
  Widget getTrackDetailComponentWidget(){
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imageWidget("https://picsum.photos/200"),
          const SizedBox(width: 20,),
          Expanded(child: detailColumn())
        ],
      ),
    );
  }

  Widget imageWidget(String url){
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: themeData.primaryColor),
        shape: BoxShape.circle
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: SizedBox(
          height: 95,
          width: 95,
          child: CommonCachedNetworkImage(imageUrl: url,height: 80,width: 80, fit: BoxFit.cover,),
        ),
      ),
    );
  }

  Widget detailColumn(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Dishant Agrawal",style: themeData.textTheme.titleSmall?.copyWith(color: const Color(0xff1D293F)),),
            const SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Advanced",style: themeData.textTheme.bodySmall?.copyWith(fontSize: 12,color: const Color(0xff9AA0A6)),),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4,horizontal: 10),
                    decoration: BoxDecoration(
                      color: themeData.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Text("Points 1425",style: themeData.textTheme.bodySmall?.copyWith(fontWeight:FontWeight.w700,fontSize: 11,color: themeData.primaryColor),)),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 4,horizontal: 10),

                    decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Text("Badges 106",style: themeData.textTheme.bodyLarge?.copyWith(fontWeight:FontWeight.w700,fontSize: 11,color: Colors.blue),)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8,),
        linearProgressBar(50),
      ],
    );
  }

  Widget coursesIcon({String assetName = ""}){
    return Image.asset(assetName, height: 13,width: 13, fit: BoxFit.cover,);
  }

  Widget linearProgressBar(int percentCompleted){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),

          child: LinearProgressBar(
            maxSteps: 100,
            progressType: LinearProgressBar.progressTypeLinear, // Use Dots progress
            currentStep: percentCompleted,
            progressColor: Colors.black,
            backgroundColor: const Color(0xffDCDCDC),
          ),
        ),
        const SizedBox(height: 10,),
        Text("$percentCompleted% Completed", style: themeData.textTheme.titleSmall?.copyWith(fontSize: 12),)
      ],
    );
  }

  Widget downloadIcon(){
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 3,
                spreadRadius: 1
            )
          ]
      ),
      child: InkWell(
        onTap: (){},
        child: const Padding(
          padding: EdgeInsets.all(3.0),
          child: Icon(Icons.file_download_outlined, color: Color(0xff242424),),
        ),
      ),
    );
  }
  //endregion

  //region tabBar
  Widget tabBarView(){
    return DefaultTabController(
      length: 8,
      child: Scaffold(
        backgroundColor: themeData.primaryColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 1,
          bottom:  PreferredSize(
            preferredSize: const Size.fromHeight(10),
            child: Container(

              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))),
              child: SafeArea(
                child: Container(
                  decoration:  BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.5),width: 0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TabBar(
                        controller: controller,
                        isScrollable: true,


                        padding: EdgeInsets.symmetric(vertical: 0),
                        labelPadding: const EdgeInsets.only(bottom: 10,left: 8,right: 8),
                        indicatorPadding: EdgeInsets.only(top: 42),
                        indicator: BoxDecoration(
                          color: themeData.primaryColor,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
                        ),
                        indicatorSize: TabBarIndicatorSize.label,
                        onTap: (int index){
                          selectedIndex = index;
                          setState(() {
                          });
                        },
                        labelStyle: themeData.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500,letterSpacing: 0.5),
                        // indicator: BoxDecoration(
                        //
                        //
                        //   color: themeData.primaryColor,
                        //
                        //
                        //
                        //   borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                        // ),
                        tabs:  [
                          tabTitleWidget(title: "Dashboard", assetPath: "assets/myLearning/overview.png", index:0),
                          tabTitleWidget(title: "In Progress", assetPath: "assets/myLearning/content.png", index:1),
                          tabTitleWidget(title: "Attending",assetPath: "assets/myLearning/resources.png", index:2),
                          tabTitleWidget(title: "Waiting List",assetPath: "assets/myLearning/discussion.png", index:3),
                          tabTitleWidget(title: "My Wishlist",assetPath: "assets/myLearning/people.png", index:4),
                          tabTitleWidget(title: "Completed",assetPath: "assets/myLearning/glossary.png", index:5),
                          tabTitleWidget(title: "Not Started",assetPath: "assets/myLearning/glossary.png", index:6),
                          tabTitleWidget(title: "Archive",assetPath: "assets/myLearning/glossary.png", index:7),
                        ],

                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: TabBarView(
            controller: controller,
            children: <Widget>[
              Container(
                child: Text("helo"),
              ),Container(
                child: Text("helo"),
              ),Container(
                child: Text("helo"),
              ),Container(
                child: Text("helo"),
              ),Container(
                child: Text("helo"),
              ),Container(
                child: Text("helo"),
              ),Container(
                child: Text("helo"),
              ),Container(
                child: Text("helo"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget tabTitleWidget({String title = "", String assetPath = "", int index = 0}){
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: Text(title)),
        ],
      ),
    );
  }

  // Widget getOverviewTabWidget(){
  //   return OverViewTabWidget();
  // }
  //
  // Widget getContentTabWidget(){
  //   return ContentTabWidget();
  // }
  //
  // Widget getResourceTabWidget(){
  //   return ResourceTabWidget();
  // }
  //
  // Widget getDiscussionTabWidget(){
  //   return DiscussionTabWidget();
  // }
  //
  // Widget getPeopleTabWidget(){
  //   return PeopleTabWidget();
  // }
  //
  // Widget getGlossaryTabWidget(){
  //   return GlossaryTabWidget();
  // }
//endregion
}
