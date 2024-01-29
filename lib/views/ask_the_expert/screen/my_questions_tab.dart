import 'package:flutter/material.dart';

class MyQuestionsTab extends StatefulWidget {
  final int componentId;
  final int componentInstanceId;

  const MyQuestionsTab({super.key, required this.componentId, required this.componentInstanceId});

  @override
  State<MyQuestionsTab> createState() => _MyQuestionsTabState();
}

class _MyQuestionsTabState extends State<MyQuestionsTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
