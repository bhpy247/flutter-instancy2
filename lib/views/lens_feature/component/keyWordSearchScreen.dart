import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../models/course/data_model/CourseDTOModel.dart';
import '../../common/components/common_text_form_field.dart';
import 'course_component.dart';

class KeyWordSearchScreen extends StatefulWidget {
  const KeyWordSearchScreen({super.key, this.onBackButtonTap});

  final Function()? onBackButtonTap;

  @override
  State<KeyWordSearchScreen> createState() => _KeyWordSearchScreenState();
}

class _KeyWordSearchScreenState extends State<KeyWordSearchScreen> {

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 20.0,
          sigmaY: 20.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 40,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    backButton(),
                    SizedBox(width: 20,),
                    Expanded(child: getSearchTextFormField()),
                  ],
                ),
              ),
              Divider(thickness: 2),
              // const BottomSheetDragger(color: Colors.white),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                shrinkWrap: true,
                itemCount: 8,
                itemBuilder: (BuildContext context, int index) {
                  return CourseComponent(model: CourseDTOModel(Title: "New Ar content"));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget backButton(){
    return InkWell(
      onTap: (){
        if(widget.onBackButtonTap != null){
          widget.onBackButtonTap!();
        }
      },
      child: Container(
        padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white) ,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white70,
                Colors.white.withOpacity(0),
              ],
            )
          ),
          child: Icon(Icons.arrow_back,color: Color(0xff3A3A3A),size: 20,)),
    );
  }



  Widget getSearchTextFormField() {
    return Container(
      child: CommonTextFormField(
        autoFocus : true,
        hintStyle: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
        controller: searchController,
        hintText: "Search Keywords...",
      ),
    );
  }
}
