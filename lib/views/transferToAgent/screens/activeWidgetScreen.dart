import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/views/common/components/common_text_form_field.dart';
import 'package:flutter_instancy_2/views/discussion_forum/component/dicussionCard.dart';
import 'package:hive/hive.dart';

import '../../../utils/date_representation.dart';
import '../../common/components/common_cached_network_image.dart';

class ActiveWidgetScreen extends StatefulWidget {
  const ActiveWidgetScreen({super.key});

  @override
  State<ActiveWidgetScreen> createState() => _ActiveWidgetScreenState();
}

class _ActiveWidgetScreenState extends State<ActiveWidgetScreen> {
  late ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Scaffold(
      body: getMainWidget(),
    );
  }

  Widget getMainWidget() {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 24,
          ),
          getSearchTextFromField(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(24),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return getSingleActiveItem();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget getSingleActiveItem() {
    return Container(
      padding: const EdgeInsets.all(13),
      margin: const EdgeInsets.only(bottom: 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 1,
            blurRadius: 1,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: "QA Learning Bot",
              style: TextStyle(color: themeData.primaryColor, fontSize: 14, fontWeight: FontWeight.w500),
              children: const [
                TextSpan(
                  text: " • ",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                TextSpan(
                  text: "Site Bot",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
              ],
            ),
          ),
          profileView(),
          getOngoingConversation(),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              Icon(
                Icons.circle,
                size: 7,
                color: themeData.primaryColor,
              ),
              const SizedBox(
                width: 2,
              ),
              Text(
                "Active",
                style: TextStyle(color: themeData.primaryColor, fontSize: 13, fontWeight: FontWeight.w600),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget getSearchTextFromField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: CommonTextFormField(
        isOutlineInputBorder: true,
        borderRadius: 30,
        contentPadding: EdgeInsets.zero,
        hintText: "Search",
        prefixWidget: Icon(Icons.search),
      ),
    );
  }

  Widget profileView() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), border: Border.all(color: Colors.black)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: const CommonCachedNetworkImage(
                imageUrl: "https://picsum.photos/200/300",
                // imageUrl: imageUrl,
                height: 30,
                width: 30,
                fit: BoxFit.cover,
                errorIconSize: 30,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Visitor 01",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 2,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    size: 15,
                    color: Color(0xff858585),
                  ),
                  Text(
                    DatePresentation.activeDateFormat(DateTime.now()),
                    style: const TextStyle(color: Color(0xff858585), fontSize: 10),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget getOngoingConversation() {
    return Container(
      decoration: BoxDecoration(color: const Color(0xffF4F4F4), borderRadius: BorderRadius.circular(6)),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), border: Border.all(color: Colors.black)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: const CommonCachedNetworkImage(
                imageUrl: "https://picsum.photos/200/300",
                // imageUrl: imageUrl,
                height: 28,
                width: 28,
                fit: BoxFit.cover,
                errorIconSize: 30,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Paul C. Ramos (Agent) is currently having conversation.",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 15,
                      color: Color(0xffFF6D00),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Joined at ${DatePresentation.hhMM(Timestamp.now())}",
                      style: const TextStyle(color: Color(0xffFF6D00), fontSize: 10),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
