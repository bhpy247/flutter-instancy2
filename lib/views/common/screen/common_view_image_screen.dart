import 'package:flutter/material.dart';

import '../../../backend/navigation/navigation_arguments.dart';
import '../components/common_cached_network_image.dart';

class CommonViewImageScreen extends StatelessWidget {
  static const String routeName = "/commonViewImageScreen";
  final CommonViewImageScreenNavigationArguments arguments;

  const CommonViewImageScreen({super.key, required this.arguments});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          // title: Text("View Image"),
          ),
      body: Center(
        child: CommonCachedNetworkImage(
          imageUrl: arguments.imageUrl,
        ),
      ),
    );
  }
}
