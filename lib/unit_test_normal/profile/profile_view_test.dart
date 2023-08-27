import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qaccess/app/modules/profile/profile_view/controllers/profile_view_controller.dart';
import 'package:qaccess/app/modules/profile/profile_view/models/get_profile_response.dart';
import 'package:qaccess/app/modules/profile/profile_view/models/update_profile_response.dart';

import '../webservice/api_client.dart';

main() {
  late ProfileViewController controller;
  late MockClient mockClient;
  late UpdateProfileResponse updateProfileResponse;
  late GetProfileResponse getProfileResponse;

  setUp(() async {
    controller = ProfileViewController();
    mockClient = MockClient();
    updateProfileResponse = UpdateProfileResponse();
    getProfileResponse = GetProfileResponse();
  });

  group("get_profile_response", () {
    test("initial_loading", () {
      controller.isLoading.value = true;
      var result = controller.isLoading.value;
      expect(result, true);
    });

    test("get_profile_success", () {
      getProfileResponse.status = true;
      when(() => mockClient.getUserProfile(
            "test_header",
          )).thenAnswer((_) async {
        return await getProfileResponse;
      });
      expect(getProfileResponse.status, true);
    });
    test("get_profile_failure", () {
      getProfileResponse.status = false;
      when(() => mockClient.getUserProfile(
            "test_header",
          )).thenAnswer((_) async {
        return await getProfileResponse;
      });
      expect(getProfileResponse.status, false);
    });
  });

  group("profile_validation_check", () {
    test("empty_name", () {
      controller.name.value = "me";
      var result = controller.validName(controller.name.value);
      expect(result, null);
    });
    test("empty_ph", () {
      controller.phoneNumber.value = "95672001";
      var result = controller.validMobileNumber(controller.phoneNumber.value);
      expect(result, null);
    });
    test("empty_email", () {
      controller.email.value = "me@gmail.com";
      var result = controller.validEmail(controller.email.value);
      expect(result, null);
    });
    test("empty_location", () {
      controller.locationEditingController.text = "test location";
      var result =
          controller.validLocation(controller.locationEditingController.text);
      expect(result, null);
    });
    test("empty_gender", () {
      var result = controller.genderId = 1;
      expect(result, 1);
    });
  });

  group("update_profile_response", () {
    test("initial_loading", () {
      controller.isLoading.value = true;
      var result = controller.isLoading.value;
      expect(result, true);
    });

    test("update_profile_success", () {
      updateProfileResponse.status = true;
      when(() => mockClient.updateProfile(
          name: controller.name.value,
          phone: int.parse(controller.phoneNumber.value),
          email: controller.email.value,
          cityId: controller.locationId ?? 0,
          gender: controller.genderId ?? 0,
          header: "Test header",
          image: File("test_path"))).thenAnswer((_) async {
        return await updateProfileResponse;
      });
      expect(updateProfileResponse.status, true);
    });

    test("update_profile_failure", () {
      updateProfileResponse.status = false;
      when(() => mockClient.updateProfile(
          name: controller.name.value,
          phone: int.parse(controller.phoneNumber.value),
          email: controller.email.value,
          cityId: controller.locationId ?? 0,
          gender: controller.genderId ?? 0,
          header: "Test header",
          image: File("test_path"))).thenAnswer((_) async {
        return await updateProfileResponse;
      });
      expect(updateProfileResponse.status, false);
    });
  });
}
