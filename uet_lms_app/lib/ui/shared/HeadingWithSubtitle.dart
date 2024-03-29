import 'package:flutter/material.dart';
import 'DefaultShimmer.dart';

class HeadingWithSubtitle extends StatelessWidget {
  HeadingWithSubtitle({Key key, this.heading, this.subtitle}) : super(key: key);

  final String heading;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        heading == null
            ? DefaultShimmer(
                height: Theme.of(context).textTheme.headline1.fontSize,
                width: MediaQuery.of(context).size.width * .75,
              )
            : FittedBox(
                child: Text(
                  heading,
                  style: Theme.of(context).textTheme.headline1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
        SizedBox(
          height: 4,
        ),
        subtitle == null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultShimmer(
                    height: Theme.of(context).textTheme.bodyText1.fontSize,
                    width: double.infinity,
                  ),
                  DefaultShimmer(
                    height: Theme.of(context).textTheme.bodyText1.fontSize,
                    width: 280,
                  ),
                ],
              )
            : Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Theme.of(context).primaryColor.withAlpha(100),
                    ),
              ),
      ],
    );
  }
}
