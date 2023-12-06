import 'package:flutter/material.dart';

import '../../backend/navigation/navigation_controller.dart';

class MainNavigatorScreen extends StatefulWidget {
  const MainNavigatorScreen({super.key});

  @override
  State<MainNavigatorScreen> createState() => _MainNavigatorScreenState();
}

class _MainNavigatorScreenState extends State<MainNavigatorScreen> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: NavigationController.mainNavigatorKey,
      onGenerateRoute: NavigationController.onMainGeneratedRoutes,
    );
  }
}
