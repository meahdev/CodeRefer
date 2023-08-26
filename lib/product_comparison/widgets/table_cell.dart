import 'package:flutter/material.dart';

import '../../../../utils/app_color.dart';
import '../src/custom_properties/cell_dimensions.dart';

class TableCell extends StatelessWidget {
  TableCell.content(
    this.name, {
    this.textStyle,
    required this.cellDimensions,
    this.colorBg = Colors.white,
    this.onTap,
  })  : cellWidth = cellDimensions.contentCellWidth,
        cellHeight = cellDimensions.contentCellHeight,
        _colorHorizontalBorder = Colors.black38,
        _colorVerticalBorder = Colors.black38,
        _textAlign = TextAlign.center,
        _padding = EdgeInsets.zero;

  TableCell.legend(
    this.name, {
    this.textStyle,
    this.cellDimensions = CellDimensions.base,
    this.onTap,
  })  : cellWidth = cellDimensions.stickyLegendWidth,
        cellHeight = cellDimensions.headerViewHeight,
        _colorHorizontalBorder = AppColor.colorPrimary.withOpacity(0.2),
        _colorVerticalBorder = AppColor.colorPrimary.withOpacity(0.2),
        colorBg = AppColor.colorPrimary.withOpacity(0.2),
        _textAlign = TextAlign.right,
        _padding = EdgeInsets.only(left: 0.0);

  TableCell.stickyColumn(
    this.name, {
    this.textStyle,
    required this.cellDimensions,
    this.colorBg = AppColor.colorPrimary,
    this.onTap,
  })  : cellWidth = cellDimensions.contentCellWidth,
        cellHeight = cellDimensions.headerViewHeight,
        _colorHorizontalBorder = Colors.white,
        _colorVerticalBorder = Colors.black38,
        _textAlign = TextAlign.center,
        _padding = EdgeInsets.zero;

  TableCell.stickyRow(
    this.name, {
    this.textStyle,
    required this.cellDimensions,
    this.colorBg = Colors.white,
    this.onTap,
  })  : cellWidth = cellDimensions.stickyLegendWidth,
        cellHeight = cellDimensions.contentCellHeight,
        _colorHorizontalBorder = Colors.black38,
        _colorVerticalBorder = Colors.black38,
        _textAlign = TextAlign.center,
        _padding = EdgeInsets.only(left: 0.0);

  final CellDimensions cellDimensions;

  final String name;
  final Function()? onTap;

  final double? cellWidth;
  final double? cellHeight;

  final Color colorBg;
  final Color _colorHorizontalBorder;
  final Color _colorVerticalBorder;

  final TextAlign _textAlign;
  final EdgeInsets _padding;

  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cellWidth,
        height: cellHeight,
        padding: _padding,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 3.0),
                child: Text(
                  name,
                  style: textStyle,
                  maxLines: null,
                  textAlign: _textAlign,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 1.1,
              color: _colorVerticalBorder,
            ),
          ],
        ),
        decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: _colorHorizontalBorder),
              right: BorderSide(color: _colorHorizontalBorder),
            ),
            color: colorBg),
      ),
    );
  }
}
