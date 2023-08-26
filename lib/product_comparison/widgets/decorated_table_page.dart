import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:haddad/app/modules/product_comparison/model/label_model.dart';
import 'package:haddad/app/modules/product_detail/models/product_detail_resposne.dart';
import '../../../../generated/locales.g.dart';
import '../../../../utils/config.dart';
import '../../../common_views/empty_list_view.dart';
import '../controllers/product_comparison_controller.dart';
import '../model/content_data.dart';
import '../src/custom_properties/cell_dimensions.dart';
import '../src/sticky_headers_table.dart';
import 'color_cell.dart';
import 'image_cell.dart';
import 'table_cell.dart' as table;
import 'package:haddad/utils/app_color.dart';

class DecoratedTablePage extends StatefulWidget {
  DecoratedTablePage({
    required this.data,
    required this.titleColumn,
    required this.titleRow,
    required this.controller,
    required this.heightList,
  });

  final List<List<ContentData>> data;
  final List<ProductDetailsModel> titleColumn;
  final List<Labels> titleRow;
  final ProductComparisonController controller;
  final List<double> heightList;

  @override
  State<DecoratedTablePage> createState() => _DecoratedTablePageState();
}

class _DecoratedTablePageState extends State<DecoratedTablePage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return widget.titleColumn.isNotEmpty
        ? StickyHeadersTable(
            tableDirection: getTableDirection(),
            cellDimensions: buildCellDimensions(context),
            headerWidgetBuilder: (i) => buildImageCell(i, context),
            buttonName: LocaleKeys.removeHeading.tr,
            onTapRemove: onTapRemove,
            columnsLength: widget.titleColumn.length,
            rowsLength: widget.titleRow.length,
            columnsTitleBuilder: (i) => buildTableColumn(i, textTheme, context),
            rowsTitleBuilder: (i) => buildTableRow(i, context, textTheme),
            contentCellBuilder: (i, j) {
              return buildTableContent(i, j, textTheme, context);
            },
            showVerticalScrollbar: false,
            showHorizontalScrollbar: false,
          )
        : EmptyListView(
            subTitle: LocaleKeys.comparisonSubtitle.tr,
            title: LocaleKeys.comparisonEmptyTitle.tr);
  }

  TextDirection getTableDirection() {
    return widget.controller.isAr() ? TextDirection.rtl : TextDirection.ltr;
  }

  /// To remove items
  onTapRemove(int i) {
    widget.controller.removeFromList(i, widget.titleColumn[i]);
    setState(() {
      widget.titleColumn.removeAt(i);
      widget.data.removeAt(i);
    });
  }

  ///Product Attribute Values
  buildTableContent(int i, int j, TextTheme textTheme, BuildContext context) {
    // print('colorRgb == ${widget.data[i][j]}');
    return widget.data[i][j].isColor
        ? ColorCell(
            color: widget.data[i][j].name ?? "",
            cellDimensions: buildCellDimensions(context),
          )
        : table.TableCell.content(
            widget.data[i][j].name ?? "",
            textStyle: textTheme.bodyText2!.copyWith(fontSize: 12.0),
            cellDimensions: buildCellDimensions(context),
          );
  }

  ///Product Attribute
  table.TableCell buildTableRow(
      int i, BuildContext context, TextTheme textTheme) {
    return table.TableCell.stickyRow(
      widget.titleRow[i].name ?? "",
      cellDimensions: buildCellDimensions(context),
      textStyle: textTheme.button!.copyWith(fontSize: 11),
    );
  }

  ///Product title
  table.TableCell buildTableColumn(
      int i, TextTheme textTheme, BuildContext context) {
    return table.TableCell.stickyColumn(
      widget.titleColumn[i].name ?? "",
      textStyle: textTheme.button!.copyWith(
        fontSize: 12,
        color: Colors.white,
      ),
      cellDimensions: buildCellDimensions(context),
    );
  }

  ///Product Image
  ImageCell buildImageCell(int i, BuildContext context) {
    return ImageCell.stickyColumn(
      widget.titleColumn[i],
      cellDimensions: buildImageCellDimensions(context),
    );
  }

  ///Product Image Width
  CellDimensions buildImageCellDimensions(BuildContext context) {
    return CellDimensions.uniform(
        contentCellWidthValue: buildImageCellWidth(),
        stickyLegendWidth: buildStickWidth());
  }

  ///Row Cell-Width and Height
  CellDimensions buildCellDimensions(BuildContext context) {
    return CellDimensions.variableColumnWidthAndRowHeight(
        columnWidths: buildWidth(),
        stickyLegendWidth: buildStickWidth(),
        rowHeights: widget.heightList,
        headerViewHeight: widget.titleColumn.length > 1 ? 65 : 50);
  }

  /// returns build ImageCell width
  double buildImageCellWidth() {
    return widget.titleColumn.length > 1
        ? MediaQuery.of(context).size.width * .4
        : MediaQuery.of(context).size.width * .6;
  }

  /// returns Sticky width
  double buildStickWidth() {
    return widget.titleColumn.length > 1
        ? MediaQuery.of(context).size.width * .22
        : MediaQuery.of(context).size.width * .3;
  }

  /// returns list of width
  List<double> buildWidth() {
    List<double> widthList = [];

    for (int i = 0; i < widget.titleColumn.length; i++) {
      if (widget.titleColumn.length > 1) {
        widthList.add(MediaQuery.of(context).size.width * .4);
      } else {
        widthList.add(MediaQuery.of(context).size.width * .7);
      }
    }
    return widthList;
  }

  /// returns list of height
  List<double> buildListOfContentHeight() {
    List<double> heightList = [];
    widget.titleRow.forEach((element) {
      heightList.add(50.0);
    });
    print("Height list length: ${heightList.length}");
    for (int i = 0; i < widget.data.length; i++) {
      print("widget.data[i] length: ${widget.data[i].length}");

      for (int j = 0; j < widget.data[i].length; j++) {
        // print('data leng:- ${widget.data[i].length}');
        double height = 0.0;
        if (widget.titleColumn.length < 1) {
          // print('height:- if');
          height = widget.data[i][j].name!.length * .5;
        } else {
          // print('height:- else ${widget.data[i][j].name}');

          height = widget.data[i][j].name!.length * .9;
        }

        // print("taken height: $height");
        try {
          if (heightList[j] <= height) {
            heightList[j] = height;
          }
        } catch (e) {
          print('exception:buildListOfContentHeight() $e');
        }
      }
    }
    return heightList;
  }
}