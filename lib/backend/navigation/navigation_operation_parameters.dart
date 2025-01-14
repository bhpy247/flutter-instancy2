import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';

import 'navigation_type.dart';

class NavigationOperationParameters<ResultType> {
  final BuildContext context;
  final NavigationType navigationType;
  final String? routeName;
  final Route? route;
  final dynamic arguments;
  final RoutePredicate? predicate;
  final ResultType? result;

  const NavigationOperationParameters({
    required this.context,
    required this.navigationType,
    this.routeName,
    this.route,
    this.arguments,
    this.predicate,
    this.result,
  });

  NavigationOperationParameters copyWith({
    BuildContext? context,
    NavigationType? navigationType,
    String? routeName,
    Route? route,
    dynamic arguments,
    RoutePredicate? predicate,
    ResultType? result,
  }) {
    return NavigationOperationParameters(
      context: context ?? this.context,
      navigationType: navigationType ?? this.navigationType,
      routeName: routeName ?? this.routeName,
      route: route ?? this.route,
      arguments: arguments ?? this.arguments,
      predicate: predicate ?? this.predicate,
      result: result ?? this.result,
    );
  }

  @override
  String toString() {
    return MyUtils.encodeJson({
      "context" : context.toString(),
      "navigationType" : navigationType.toString(),
      "routeName" : routeName,
      "route" : route?.toString(),
      "arguments" : arguments?.toString(),
      "predicate" : predicate?.toString(),
      "result" : result?.toString(),
    });
  }
}