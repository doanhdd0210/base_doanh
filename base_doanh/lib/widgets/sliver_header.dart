import 'package:flutter/material.dart';

class SliverHeader extends SliverPersistentHeaderDelegate {
  final Widget _tabBar;

  SliverHeader(this._tabBar);

  @override
  double get minExtent => 60;

  @override
  double get maxExtent => 60;

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 16,right: 16),
          color: Colors.white,
          height: 44,
          child: Center(
            child: _tabBar,
          ),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(SliverHeader oldDelegate) {
    return false;
  }
}
