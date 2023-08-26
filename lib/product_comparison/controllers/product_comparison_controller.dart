import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:haddad/generated/locales.g.dart';

import '../../../../utils/app_storage_keys.dart';
import '../../../../utils/snackbar_utils.dart';
import '../../product_detail/models/product_detail_resposne.dart';
import '../model/content_data.dart';
import '../model/label_model.dart';

class ProductComparisonController extends GetxController {
  RxList<ProductDetailsModel> mProducts = <ProductDetailsModel>[].obs;
  RxList<Labels> mCustomAttributesLabels = <Labels>[].obs;
  RxBool isLoading = true.obs;

  List<Labels> titleRowsList = [];
  List<ProductDetailsModel> titleColumnList = [];
  List<List<ContentData>> contentList = [];
  List<double> rowHeightList = [];

  @override
  void onInit() async {
    await getFilterProducts();
    makeTitleRow();
    makeTitleColumn();
    makeContentData();
    buildListOfContentHeight();
    super.onInit();
  }

  Future<void> getFilterProducts() async {
    if (AppStorageKeys().readComparedProducts().isNotEmpty) {
      List<dynamic> parsedListJson =
          jsonDecode(AppStorageKeys().readComparedProducts());
      mProducts.value = List<ProductDetailsModel>.from(
          parsedListJson.map((i) => ProductDetailsModel.fromJson(i)));

      if (AppStorageKeys().readLogInStatus()) {
        mCustomAttributesLabels.add(Labels(name: LocaleKeys.price.tr, id: -2));
        mProducts.forEach((pro) {
          pro.productSpecificationModel!.groups!.forEach((gro) {
            gro.attributes?.add(Attributes(
              name: LocaleKeys.price.tr,
              customProperties: null,
              id: -2,
              isColor: false,
              values: [
                Values(
                    attributeTypeId: -2,
                    valueRaw: pro.productPrice?.price ?? "",
                    customProperties: null,
                    colorSquaresRgb: null)
              ],
            ));
            gro.attributes!.forEach((attr) {
              mCustomAttributesLabels.add(Labels(id: attr.id, name: attr.name));
            });
          });
        });
      } else {
        mProducts.forEach((pro) {
          pro.productSpecificationModel!.groups!.forEach((gro) {
            gro.attributes!.forEach((attr) {
              mCustomAttributesLabels.add(Labels(id: attr.id, name: attr.name));
            });
          });
        });
      }

      List jsonList = mCustomAttributesLabels
          .map((element) => jsonEncode(element))
          .toList();
      List uniqueList = jsonList.toSet().toList();
      List result = uniqueList.map((e) => jsonDecode(e)).toList();
      mCustomAttributesLabels.clear();
      for (var data in result) {
        mCustomAttributesLabels
            .add(Labels(id: data['id'], name: data['name'], height: 70.0.obs));
      }
    }
    return;
  }

  ///Function to show row labels; memory, ram etc..
  void makeTitleRow() {
    titleRowsList.clear();
    titleRowsList = List.generate(mCustomAttributesLabels.length, (i) {
      return mCustomAttributesLabels[i];
    });
  }

  ///Function to show titles of products added to compare
  void makeTitleColumn() {
    titleColumnList.clear();
    titleColumnList = List.generate(mProducts.length, (i) => mProducts[i]);
  }

  void makeContentData() {
    List<ContentData> rowData = [];
    contentList.clear();
    rowData.clear();
    int count = 0;

    /// list of products
    titleColumnList.forEach((column) {
      ///list of attributes such as price ,memory etc..
      titleRowsList.forEach((row) {
        bool isLabelFound = false;

        column.productSpecificationModel?.groups?.forEach((gro) {
          gro.attributes?.forEach((attr) {
            if (row.id == attr.id) {
              isLabelFound = true;

              String value = "";
              String colors = "";
              attr.values?.forEach((val) {
                if (!attr.isColor) {
                  count = count + 1;
                  var lastItem = attr.values!.last;
                  if (lastItem.valueRaw == val.valueRaw) {
                    value = value + (val.valueRaw ?? "");
                  } else {
                    value = value + (val.valueRaw ?? "") + ",";
                  }
                } else if (attr.isColor) {
                  count = count + 1;
                  var lastItem = attr.values!.last;
                  if (lastItem.colorSquaresRgb == val.colorSquaresRgb) {
                    colors = colors + (val.colorSquaresRgb ?? "");
                  } else {
                    colors = colors + (val.colorSquaresRgb ?? "") + ",";
                  }
                }
              });
              if (colors.isNotEmpty) {
                rowData.add(ContentData(name: colors, isColor: true));
              } else {
                rowData.add(ContentData(name: value, isColor: false));
              }

              // print("Row value:- value ${json.encode(row)}");
            }
          });
        });
        if (!isLabelFound) {
          rowData.add(ContentData(name: "-", isColor: false));
          isLabelFound = false;
        }
      });
      contentList.add(rowData);
      // String out = jsonEncode(contentList);
      // print("String_output: $out");
      rowData = [];
    });
  }

  removeFromList(int pIndex, ProductDetailsModel products) {
    mProducts.removeAt(pIndex);
    if (AppStorageKeys().readComparedProducts().isNotEmpty) {
      String encodedProducts;
      List<ProductDetailsModel> fetchedProducts = [];
      List<dynamic> parsedListJson =
          jsonDecode(AppStorageKeys().readComparedProducts());
      fetchedProducts = List<ProductDetailsModel>.from(
          parsedListJson.map((i) => ProductDetailsModel.fromJson(i)));

      for (int i = 0; i < fetchedProducts.length; i++) {
        if (fetchedProducts[i].id == products.id) {
          fetchedProducts.remove(fetchedProducts[i]);
        }
      }
      encodedProducts = jsonEncode(fetchedProducts);
      GetStorage().write(AppStorageKeys.comparedProducts, encodedProducts);
    } else {
      GetStorage().write(AppStorageKeys.comparedProducts, "");
    }
    CustomSnackBar.showSuccessSnackBar(LocaleKeys.success.tr,
        LocaleKeys.successfullyRemovedFromComparisonList.tr);
  }

  void buildListOfContentHeight() {
    if (rowHeightList.isEmpty) {
      titleRowsList.forEach((element) {
        addDefaultHeightValue();
      });
    }
    for (int i = 0; i < contentList.length; i++) {
      String test = "";
      contentList[i].forEach((element) {
        test = test + "\n" + (element.name ?? "");
      });
      if (rowHeightList.length < contentList[i].length) {
        int balance = (rowHeightList.length - contentList[i].length);
        balance = balance.abs();
        // print("Balance: $balance");
        for (int i = 0; i < balance; i++) {
          addDefaultHeightValue();
        }
        if (titleRowsList.length < rowHeightList.length)
          titleRowsList.add(Labels(id: 0, name: "", height: 70.0.obs));
      }
      for (int j = 0; j < contentList[i].length; j++) {
        double height = 0.0;
        if (titleColumnList.length < 1) {
          height = contentList[i][j].name!.length * .5;
        } else {

          height = contentList[i][j].name!.length * .9;
        }
        try {
          if (rowHeightList[j] <= height) {
            rowHeightList[j] = height;
          }
        } catch (e) {
          print('exception: buildListOfContentHeight() $e');
        }
      }
    }
    isLoading(false);
  }

  void addDefaultHeightValue() {
    rowHeightList.add(50.0);
  }

  bool isAr() {
    if (AppStorageKeys().readCurrentLanguageCode() ==
        AppStorageKeys().readArabicLanguageCode()) {
      return true;
    }
    return false;
  }
}