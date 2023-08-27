import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qaccess/app/modules/profile/sub_profile/add_or_edit_sub_profile/controllers/sub_profile_view_controller.dart';
import 'package:qaccess/app/modules/profile/sub_profile/add_or_edit_sub_profile/models/add_profile/sub_profile_add_response.dart';
import 'package:qaccess/app/modules/profile/sub_profile/add_or_edit_sub_profile/models/profile_detail_response_model.dart';
import 'package:qaccess/app/modules/profile/sub_profile/add_or_edit_sub_profile/models/update_profile/sub_profile_update_response.dart';

import '../webservice/api_client.dart';

main() {
  late SubProfileViewController controller;
  late MockClient mockClient;
  late ProfileDetailResponse subProfileGetResponse;
  late SubProfileAddResponse subProfileAddResponse;
  late SubProfileUpdateResponse subProfileUpdateResponse;
  setUp(() {
    controller = SubProfileViewController();
    subProfileGetResponse = ProfileDetailResponse();
    subProfileUpdateResponse = SubProfileUpdateResponse();
    subProfileAddResponse = SubProfileAddResponse();
    mockClient = MockClient();
  });

  group("sub_profile_response", () {
    test("initial_loading", () {
      controller.isLoading.value = true;
      var result = controller.isLoading.value;
      expect(result, true);
    });

    test("get_sub_profile_success", () {
      subProfileGetResponse.status = true;
      when(() => mockClient.getSubProfile(
        "test_header",
        1
      )).thenAnswer((_) async {
        return await subProfileGetResponse;
      });
      expect(subProfileGetResponse.status, true);
    });
    test("get_sub_profile_failure", () {
      subProfileGetResponse.status = false;
      when(() => mockClient.getSubProfile(
          "test_header",
          2
      )).thenAnswer((_) async {
        return await subProfileGetResponse;
      });
      expect(subProfileGetResponse.status, false);
    });
    test("initial_loading", () {
      controller.isLoading.value = false;
      var result = controller.isLoading.value;
      expect(result, false);
    });

  });

  group("sub_profile_validation_check", () {
    test("empty_fields", () {
      controller.name.value = "me";
      controller.phoneNumber.value = "95672001";
      controller.locationController.text = "test location";

      var result = controller.checkWhetherHasError();
      print('The current result $result'
          '${controller.mobNumberError.value}'
          '${controller.mobNumberError.value}'
          '${controller.locationError.value}');
      expect(result, false);
    });
  });


  group("sub_profile_add_response", () {
    test("initial_loading", () {
      controller.isLoading.value = true;
      var result = controller.isLoading.value;
      expect(result, true);
    });

    test("sub_profile_add_success", () {
      subProfileAddResponse.status = true;
      when(() => mockClient.addSubProfile(
        header: "test header",
        name: controller.name.value,
        cityId: controller.locationId??0,
        gender: controller.genderId??0,
        phone:int.parse( controller.phoneNumber.value),
        image: File("test_path")

      )).thenAnswer((_) async {
        return await subProfileAddResponse;
      });
      expect(subProfileGetResponse.status, true);
    });
    test("sub_profile_add_failure", () {
      subProfileAddResponse.status = false;
      when(() => mockClient.addSubProfile(
          header: "test header",
          name: controller.name.value,
          cityId: controller.locationId??0,
          gender: controller.genderId??0,
          phone:int.parse( controller.phoneNumber.value),
          image: File("test_path")

      )).thenAnswer((_) async {
        return await subProfileAddResponse;
      });
      expect(subProfileGetResponse.status, false);
    });
    test("initial_loading", () {
      controller.isLoading.value = false;
      var result = controller.isLoading.value;
      expect(result, false);
    });

  });
}
