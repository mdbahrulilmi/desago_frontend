import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerHelper {
  static Widget box({
    required double width,
    required double height,
    double radius = 8,
    Color? baseColor,
    Color? highlightColor,
  }) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? Colors.grey.shade300,
      highlightColor: highlightColor ?? Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  static Widget text({
    required double width,
    required double height,
    Color? baseColor,
    Color? highlightColor,
  }) {
    return box(
      width: width,
      height: height,
      radius: 6,
      baseColor: baseColor,
      highlightColor: highlightColor,
    );
  }
}