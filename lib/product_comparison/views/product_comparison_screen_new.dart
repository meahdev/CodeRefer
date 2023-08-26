import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haddad/app/widgets/loaders/loading_view.dart';

import '../../../../generated/locales.g.dart';
import '../../../widgets/buttons/back_icon_button.dart';
import '../../../widgets/toolbar/custom_appbar.dart';
import '../controllers/product_comparison_controller.dart';
import '../widgets/decorated_table_page.dart';

class ProductComparisonNew extends StatefulWidget {
  const ProductComparisonNew({Key? key}) : super(key: key);

  @override
  State<ProductComparisonNew> createState() => _ProductComparisonNewState();
}

class _ProductComparisonNewState extends State<ProductComparisonNew> {
  late ProductComparisonController controller;

  @override
  void initState() {
    super.initState();
    Get.delete<ProductComparisonController>();
    controller = Get.put(ProductComparisonController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbar(
          strTitle: LocaleKeys.productComparison.tr,
          isHasLeading: true,
          leading:  CustomBackIcon(
              isDefaultBackPress: false,
              onPressed: () {
                Get.back(closeOverlays: true);
              },
            )
        ),
        body: Obx(() => LoadingView(
              isLoading: controller.isLoading.value,
              child: !controller.isLoading.value
                  ? DecoratedTablePage(
                      controller: controller,
                      data: controller.contentList,
                      titleColumn: controller.titleColumnList,
                      titleRow: controller.titleRowsList,
                      heightList: controller.rowHeightList,
                    )
                  : Container(),
            )));
  }
}