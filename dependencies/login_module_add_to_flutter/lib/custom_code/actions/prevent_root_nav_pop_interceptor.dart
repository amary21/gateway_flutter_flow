// Automatic FlutterFlow imports
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/scheduler.dart';

// Key: routeName
// Value: boolean value indicating if it is the root page in the nav stack
// At any given point of time, only 1 key can have a true value
Map<String, bool> routePositionTracker = <String, bool>{};

GlobalKey<NavigatorState>? _navigatorKey;

Future preventRootNavPopInterceptor(BuildContext context) async {
  final _router = GoRouter.of(context);
  _navigatorKey = _router.configuration.navigatorKey;
  final _name = _router.getCurrentLocation();

  // Get the current route
  final _currentRoute = BackButtonInterceptor.getCurrentNavigatorRoute(context);
  final _isFirst = _currentRoute?.isFirst ?? false;

  if (_currentRoute == null) {
    return;
  }

  // Update the map
  if (_isFirst) {
    // Check if there is any existing true value
    final _currentFirst = routePositionTracker.entries.firstWhere(
      (entry) => entry.value,
      orElse: () => const MapEntry('-1', false),
    );
    if (_currentFirst.key != '-1') {
      routePositionTracker[_currentFirst.key] = false;
    }
  }

  routePositionTracker[_name] = _isFirst;

  BackButtonInterceptor.add(
    defaultPopInterceptor,
    name: 'rootPopCheck-$_name',
    context: context,
  );
}

bool popComplete = false;

bool defaultPopInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
  if (popComplete) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (popComplete) popComplete = false;
    });
    return false;
  }
  final _name =
      GoRouter.of(_navigatorKey!.currentContext!).getCurrentLocation();
  final _isFirst = routePositionTracker[_name] ?? false;
  if (!_isFirst) {
    _navigatorKey!.currentState?.pop();
    routePositionTracker.remove(_name);
    BackButtonInterceptor.removeByName('rootPopCheck-$_name');
    popComplete = true;
    return true;
  } else {
    routePositionTracker.remove(_name);
    BackButtonInterceptor.removeByName('rootPopCheck-$_name');
    return false;
  }
}
