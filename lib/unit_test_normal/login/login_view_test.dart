import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qaccess/app/modules/login/controllers/login_controller.dart';
import 'package:qaccess/app/modules/login/model/login_response.dart';

import '../webservice/api_client.dart';

main() {
  late LoginController controller;
  late MockClient mockClient;
  late LoginResponse loginResponse;
  setUp(() {
    registerFallbackValue(Uri());
    controller = LoginController();
    mockClient = MockClient();
    loginResponse = LoginResponse(message: "success",status: true,);
  });

  group("login_validation_check", () {
    test("Initial_loading", () {
      var result = controller.isLoading.value;
      expect(result, false);
    });

    test("empty_fields", () {
      controller.mobileNumber = "95672001";
      controller.password = "password";
      controller.validMobileNumber(controller.mobileNumber);
      controller.validPassword(controller.password);
      var result = controller.isNotValid();
      print('The current result $result'
          '${controller.mobNumberError.value}'
          '${controller.passwordError.value}');
      expect(result, false);
    });
  });

  group("login_response", () {
    test("Initial_loading", () {
      controller.isLoading.value = true;
      var result = controller.isLoading.value;
      expect(result, true);
    });
    test("login_success", () {
      loginResponse.status = true;
      when(() => mockClient.login("86868686", "password", "test", "test"))
          .thenAnswer((_) async {
        return await loginResponse;
      });
      expect(loginResponse.status, true);
    });

    test("login_failure", () {
      loginResponse.status = false;
      when(() => mockClient.login("86868686", "wrong_password", "test", "test"))
          .thenAnswer((value) async {
        print('value is $value');
        loginResponse.status = false;
        return await loginResponse;
      });
      expect(loginResponse.status, false);
    });
  });

}
