import 'package:flutter/material.dart';
import 'DefaultShimmer.dart';

class RepeatedShimmer extends StatelessWidget {
  const RepeatedShimmer({
    Key key,
    this.repeated = 2,
    this.color,
  }) : super(key: key);

  final int repeated;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          for (int i = 0; i < repeated; i++) ...[
            ..._getShimmerPair(context),
            if (i != repeated - 1)
              SizedBox(
                height: 15,
              )
          ],
        ],
      ),
    );
  }

  List<Widget> _getShimmerPair(BuildContext context) {
    return [
      _buildFlexibleShimmers(
        context,
        shimmerFlex: 5,
        spacerFlex: 5,
      ),
      _buildFlexibleShimmers(
        context,
        shimmerFlex: 7,
        spacerFlex: 3,
        height: 14,
      )
    ];
  }

  Widget _buildFlexibleShimmers(
    BuildContext context, {
    @required int shimmerFlex,
    @required int spacerFlex,
    double height,
  }) {
    return Row(
      children: [
        Flexible(
          child: DefaultShimmer(
            height: height,
            color: color,
          ),
          flex: shimmerFlex,
        ),
        Spacer(
          flex: spacerFlex,
        )
      ],
    );
  }
}
