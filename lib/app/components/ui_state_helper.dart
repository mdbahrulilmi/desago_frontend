import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UIStateHelper {
  static Widget handleState({
    required bool isLoading,
    required bool isEmpty,
    required Widget content,
    Widget? loadingWidget,
    Widget? emptyWidget,
  }) {
    if (isLoading) {
      return loadingWidget ?? _defaultShimmer();
    }

    if (isEmpty) {
      return emptyWidget ??
          const Center(
            child: Text("Data tidak tersedia"),
          );
    }

    return content;
  }

  static Widget _defaultShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 3,
        itemBuilder: (_, __) => Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}