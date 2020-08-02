import 'dart:async';

export 'package:flutter/material.dart'
    hide
        AppBar,
        SliverAppBar,
        Scaffold,
        ScaffoldState,
        ScaffoldGeometry,
        ScaffoldFeatureController,
        PersistentBottomSheetController;
export 'package:flutter/services.dart';

export 'src/app_bar/app_bar.dart';
export 'src/app_bar/sliver_app_bar.dart';
export 'src/app_bar/sliver_tab_bar.dart';

export 'src/extensions/route_extension.dart';

export 'src/scaffold/scaffold.dart';

//class Mui {
//  static const MethodChannel _channel =
//      const MethodChannel('mui');
//
//  static Future<String> get platformVersion async {
//    final String version = await _channel.invokeMethod('getPlatformVersion');
//    return version;
//  }
//}
