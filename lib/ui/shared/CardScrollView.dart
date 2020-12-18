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
      this.verticalSpacing = 15,
      this.horizontalSpacing = 17,
      this.height,
      this.title})
      : super(key: key);

  final bool loading;
  final int childCount;
  final double height;
  final String title;
  final double verticalSpacing;
  final double horizontalSpacing;
  final Widget Function(BuildContext, int) builder;

  @override
  Widget build(BuildContext context) {
    print(height);
    return CustomCard(
      height: height,
      padding: EdgeInsets.zero,
      builder: (context) => Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalSpacing),
            child: loading
                ? RepeatedShimmer(
                    repeated: 5,
                  )
                : _buildListView(),
          ),
          if (title != null) Container(
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(200),
              borderRadius: BorderRadius.circular(7),
            ),
            width: double.infinity,
            child: ClipRect(
              child: Padding(
                padding: EdgeInsets.only(top: verticalSpacing, bottom: 10, left: horizontalSpacing, right: horizontalSpacing),
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
            ? EdgeInsets.only(top: title != null ? 42.0 : verticalSpacing)
            : EdgeInsets.only(
                top: verticalSpacing, bottom: idx + 1 == childCount ? verticalSpacing : 0),
        child: builder(context, idx),
      ),
      itemCount: childCount,
    );
  }
}
