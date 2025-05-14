import 'dart:math' show min;

import 'package:flutter/rendering.dart';

class PickerPlusPickerGridDelegate extends SliverGridDelegate {
  const PickerPlusPickerGridDelegate({
    required this.columnCount,
    required this.rowCount,
  });

  final int rowCount;

  final int columnCount;

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    final double tileWidth = constraints.crossAxisExtent / columnCount;
    final double calculatedTileHeight =
        (constraints.viewportMainAxisExtent - rowCount * 4) / rowCount;

    final double tileHeight = min(calculatedTileHeight, tileWidth);

    return SliverGridRegularTileLayout(
      crossAxisCount: columnCount,
      childCrossAxisExtent: _zeroOrGreater(tileWidth),
      crossAxisStride: _zeroOrGreater(tileWidth),
      childMainAxisExtent: _zeroOrGreater(tileHeight),
      mainAxisStride: _zeroOrGreater(tileHeight + 4),
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(PickerPlusPickerGridDelegate oldDelegate) => false;

  double _zeroOrGreater(double number) {
    return number >= 0 ? number : 0;
  }
}
