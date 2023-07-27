import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreenView extends StatefulWidget {
  static const String routeName = "/homeScreenView";
  const HomeScreenView({Key? key}) : super(key: key);

  @override
  State<HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView> {
  late ThemeData themeData;
  String imageUrl = "assets/user.gif";
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: themeData.primaryColor,
      ),
      backgroundColor: themeData.primaryColor,
      body: getMainBody(),
    );
  }

 Widget getMainBody() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          getProfileInfo(),
          Expanded(child:getTabBar()
          )
        ],
      ),
    );
 }

 Widget getProfileInfo(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getProfileImageWidget(),
          const SizedBox(width: 6,),
          Expanded(
            child : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Dishant Agrawal"),
                const SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Advance",
                      style: TextStyle(color:Colors.grey,fontWeight: FontWeight.w600,fontSize: 14),
                    ),
                    backgroundColorText(text:"Points 1425,", color:Colors.green, ),
                    backgroundColorText(text:"Badges 106", color:Colors.blue, )
                  ],
                ),
              ],
            ),
          )
        ],
      )
    );
 }



 Widget getTabBar(){
    return DefaultTabController(
      length: 4,
      initialIndex: currentIndex,
      child: Scaffold(
        appBar: AppBar(
          elevation: 2,
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Colors.black45,
            tabs: [
              Padding(padding: EdgeInsets.only(top: 12, bottom: 12), child: Text('Dashboard')),
              Padding(padding: EdgeInsets.only(top: 12, bottom: 12), child: Text('In Progress')),
              Padding(padding: EdgeInsets.only(top: 12, bottom: 12), child: Text('Attending')),
              Padding(padding: EdgeInsets.only(top: 12, bottom: 12), child: Text('Waiting List')),
            ],
          ),
        ),
        body: TabBarView(

          physics: const NeverScrollableScrollPhysics(),
          children: [
            Center(
              child: Container(
                color: Colors.white,
                child: myLearningCard(),

              ),
            ),
            Container(color: Colors.white),
            Container(color: Colors.white),
            Container(color: Colors.white),
          ],
        ),
        // bottomNavigationBar: ,
      ),
    );
 }

 Widget backgroundColorText({required String text, required Color color}){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: color.withOpacity(0.1),
      ),
      child: Text(
        text,
        style: TextStyle(color:color,fontWeight: FontWeight.bold,fontSize: 11),
      ),
    );
 }

 Widget getProfileImageWidget(){
    return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.green)
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.asset(imageUrl,height: 80,width: 80,fit: BoxFit.cover,)),
    );
  }

 Widget myLearningCard(){
    return Container(
      height: 242,width: 232,
      child: Card(
        color: Color(0xffD7F0B6),
        child: Stack(
          clipBehavior: Clip.none,
          // mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/Upload_file.png",height: 242,width: 232,),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                    bottom: 25,
                    child: imageBackDrop()),

                Positioned(
                  bottom: -40,
                    child: detailView()),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget detailView(){
    return Container(
      height: 72,
        width: 232,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15)
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Progess Event", style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600),),
                SizedBox(height: 5,),
                Row(
                  children: [
                    Icon(FontAwesomeIcons.filePdf,size: 13,),
                    SizedBox(width: 2,),
                    Text("PDF", style: TextStyle(fontSize: 10),),
                  ],
                )
              ],
            ),
          ),

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
            ),
            elevation: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xffECF6FF),
                borderRadius: BorderRadius.circular(15)
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5),
                child: Row(
                  children: [
                    Icon(FontAwesomeIcons.download,size: 10,color: Color(0xff5FA1D5)),
                    Text("Download", style: TextStyle(fontSize: 7,color: Color(0xff5FA1D5)),),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget imageBackDrop(){
    return Container(
      // height: 50,
      width: 232,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5.0,
              sigmaY: 5.0,
            ),
            child:Container(
              color: Colors.black12,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8,horizontal: 10),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset(imageUrl, height: 25,width: 25,)),
                        SizedBox(width: 5,),
                        Expanded(child: Text("Manoj kumar", style: TextStyle(color: Colors.white),)),
                        Text("4",style: TextStyle(color: Colors.white),)
                      ],
                    ),
                    // SizedBox(height: 10,)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget getThreeDot(){
  //   return Container(
  //     child: ,
  //   );
  // }
}
