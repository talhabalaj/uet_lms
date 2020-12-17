import 'dart:ui';

import 'package:flutter/material.dart';
import 'CustomCard.dart';
import 'RepeatedShimmer.dart';

class CardScrollView extends StatelessWidget {
  CardScrollView(
      {Key key,
      this.loading = false,
      @required this.childCount,
      @required this.builder,
      @required this.title})
      : super(key: key);

  final bool loading;
  final int childCount;
  final String title;
  final Widget Function(BuildContext, int) builder;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: EdgeInsets.zero,
      builder: (context) => Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: loading
                ? RepeatedShimmer(
                    repeated: 5,
                  )
                : _buildListView(),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(200),
              borderRadius: BorderRadius.circular(7),
            ),
            width: double.infinity,
            child: ClipRect(
              child: Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 10, left: 15),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ListView _buildListView() {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, idx) => Padding(
        padding: idx == 0
            ? const EdgeInsets.only(top: 42.0)
            : EdgeInsets.only(
                top: 15.0, bottom: idx + 1 == childCount ? 25 : 0),
        child: builder(context, idx),
      ),
      itemCount: childCount,
    );
  }
}
