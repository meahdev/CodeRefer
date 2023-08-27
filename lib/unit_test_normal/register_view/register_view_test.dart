import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qaccess/app/modules/home/models/settings_response.dart';
import 'package:qaccess/app/modules/register/controllers/register_controller.dart';
import 'package:qaccess/app/modules/register/models/register_model.dart';
import 'package:qaccess/app/modules/register/models/registeration_response.dart';
import 'package:qaccess/app/modules/register/models/valid_mobile_number_response.dart';
import '../webservice/api_client.dart';

main() {
  late RegisterController controller;
  late RegisterModel registerModel;
  late MockClient mockClient;
  late RegisterResponse registerResponse;
  late ValidMobileNumberResponse mobileNumberResponse;
  late SettingsResponse settingsResponse;

  setUp(() async {
    controller = RegisterController();
    registerModel = RegisterModel();
    registerModel.mobileNumber = "12345678";
    mockClient = MockClient();
    registerResponse = RegisterResponse();
    mobileNumberResponse = ValidMobileNumberResponse();
    settingsResponse = SettingsResponse();
  });

  group("terms_and_other_condition_response", () {
    test("initial_loading", () {
      controller.isLoading.value = true;
      var result = controller.isLoading.value;
      expect(result, true);
    });
    test("setting_response_success", () {
      settingsResponse.status = "true";
      when(() => mockClient.getSettings()).thenAnswer((_) async {
        return await settingsResponse;
      });
      expect(settingsResponse.status, "true");
    });
    test("setting_response_failure", () {
      settingsResponse.status = "false";
      when(() => mockClient.getSettings()).thenAnswer((_) async {
        return await settingsResponse;
      });
      expect(settingsResponse.status, "false");
    });
  });

  group("register_validation_check", () {
    test("empty_fields", () {
      registerModel.name = "me";
      registerModel.emailAddress = "me@gmail.com";
      registerModel.password = "password";
      registerModel.confirmPassword = "password";
      registerModel.agreeTermsAndCondition = false;

      //checking location text field has value in frontend
      controller.locationEditingController.text = "test location";

      //optional
      registerModel.deviceName = "android";
      registerModel.deviceToken = "test_token";
      registerModel.genderId = 1;

      controller.validName(registerModel.name);
      controller.validMobileNumber(registerModel.mobileNumber);
      controller.validEmail(registerModel.emailAddress);
      controller.validLocation();
      controller.validPassword(registerModel.password);
      controller.validConfirmPassword(registerModel.confirmPassword);
      var result = controller.checkWhetherHasError();

      print('current result $result '
          '${controller.firstNameError.value} '
          '${controller.mobNumberError.value}'
          '${controller.emailError.value}'
          '${controller.locationError.value}'
          '${controller.passwordError.value}'
          '${controller.confirmPasswordError.value}'
          '${controller.termsAndConditionsError.value}');
      expect(result, false);
    });
  });

  group("registration_response", () {
    test("valid_mobile_number", () {
      mobileNumberResponse.status = true;
      when(() => mockClient.validMobileNumber(registerModel.mobileNumber))
          .thenAnswer((_) async {
        return await mobileNumberResponse;
      });
      expect(mobileNumberResponse.status, true);
    });
    test("invalid_mobile_number", () {
      mobileNumberResponse.status = false;
      when(() => mockClient.validMobileNumber(registerModel.mobileNumber))
          .thenAnswer((_) async {
        return await mobileNumberResponse;
      });
      expect(mobileNumberResponse.status, false);
    });

    test("register_success", () {
      registerResponse.status = true;
      when(() => mockClient.register(registerModel)).thenAnswer((_) async {
        return await registerResponse;
      });
      expect(registerResponse.status, true);
    });
    test("register_fail", () {
      registerResponse.status = false;
      when(() => mockClient.register(registerModel)).thenAnswer((_) async {
        return await registerResponse;
      });
      expect(registerResponse.status, false);
    });
  });
}
