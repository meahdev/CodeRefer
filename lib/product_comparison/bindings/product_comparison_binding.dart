import 'package:get/get.dart';
import 'package:haddad/app/modules/product_comparison/controllers/product_comparison_controller.dart';

class ProductComparisonBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductComparisonController>(
      () => ProductComparisonController(),
    );
  }
}
