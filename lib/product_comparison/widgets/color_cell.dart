import 'package:flutter/material.dart';

import '../src/custom_properties/cell_dimensions.dart';

class ColorCell extends StatelessWidget {
  const ColorCell({Key? key, required this.color, required this.cellDimensions})
      : super(key: key);
  final String color;
  final CellDimensions cellDimensions;

  @override
  Widget build(BuildContext context) {
    List<String> replacedColor = color.split(",");
    return Container(
      width: cellDimensions.contentCellWidth,
      height: cellDimensions.contentCellHeight,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 3.0),
                child: Wrap(
                  children: replacedColor
                      .map((e) => e.isNotEmpty ? buildColor(e) : SizedBox())
                      .toList(),
                )),
          ),
          Container(
            width: double.infinity,
            height: 1.1,
            color: Colors.black38,
          ),
        ],
      ),
      decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: Colors.black38,
            ),
            right: BorderSide(
              color: Colors.black38,
            ),
          ),
          color: Colors.white),
    );
  }

  Padding buildColor(String color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Container(
        height: 18,
        width: 18,
        decoration: BoxDecoration(
            color: Color(int.parse(color.replaceAll('#', '0xff'))),
            shape: BoxShape.circle),
      ),
      // child: Text(color),
    );
  }
}
