import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_scale_multiple_indicator.dart';
import 'package:loading/loading.dart';

class CircularLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Loading(
        indicator: BallScaleMultipleIndicator(),
        color: Colors.blue,
      ),
    );
  }
}
