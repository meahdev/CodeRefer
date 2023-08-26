import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:haddad/app/modules/dashboard/model/dashbaord_response.dart';

import '../../../../utils/navigation_utils.dart';
import '../../../common_views/broken_image.dart';
import '../../product_detail/models/product_detail_resposne.dart';
import '../src/custom_properties/cell_dimensions.dart';

class ImageCell extends StatelessWidget {
  ImageCell.stickyColumn(
    this.products, {
    this.cellDimensions = CellDimensions.base,
  })  : cellWidth = cellDimensions.contentCellWidth,
        cellHeight = cellDimensions.headerViewHeight,
        _colorHorizontalBorder = Colors.transparent;

  final CellDimensions cellDimensions;

  final ProductDetailsModel products;

  final double? cellWidth;
  final double? cellHeight;

  final Color _colorHorizontalBorder;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        NavigationUtils().callProductDetails(productId: products.id);
      },
      child: Container(
        width: cellWidth,
        height: 100,
        child: CachedNetworkImage(
          width: cellWidth,
          height: 100,
          imageUrl: products.defaultPictureModel?.imageUrl ?? "",
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          errorWidget: (context, url, error) => BrokenImage(
            height: 80,
            width: cellWidth,
          ),
          filterQuality: FilterQuality.high,
        ),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: _colorHorizontalBorder),
            right: BorderSide(color: _colorHorizontalBorder),
          ),
        ),
      ),
    );
  }
}
