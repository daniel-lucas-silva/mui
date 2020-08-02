import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'sliver_app_bar.dart';
import 'sliver_app_bar_delegate.dart';

class SliverAppBar extends StatefulWidget {
  @override
  _SliverAppBarState createState() => _SliverAppBarState();
}

class _SliverAppBarState extends State<SliverAppBar>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final toolbarHeight = kToolbarHeight - 7;
    return SliverPersistentHeader(
      pinned: true,
      floating: true,
      delegate: SliverAppBarDelegate(
        minHeight: toolbarHeight + statusBarHeight,
        maxHeight: 140.0,
        snapConfiguration: FloatingHeaderSnapConfiguration(
          vsync: this,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 200),
        ),
        builder: (context, shrinkOffset, overlapsContent) {
          return Container(
            color: Theme.of(context).primaryColor,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Positioned(
                  left: 0.0,
                  right: 0.0,
                  top: statusBarHeight,
                  bottom: toolbarHeight,
                  child: ClipRect(
                    child: OverflowBox(
                      minHeight: 0.0,
                      maxHeight: double.infinity,
                      alignment: AlignmentDirectional.bottomStart,
                      child: Card(
                        margin:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Container(
                          height: toolbarHeight,
                          child: Text("Search for apps"),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0.0,
                  right: 0.0,
                  bottom: 0.0,
                  child: DefaultTabController(
                    length: 4,
                    child: TabBar(
                      isScrollable: true,
                      labelPadding: EdgeInsets.symmetric(horizontal: 28),
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: [
                        Tab(text: "For you"),
                        Tab(text: "Top charts"),
                        Tab(text: "Events"),
                        Tab(text: "Premium"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
