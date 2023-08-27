import 'package:formz/formz.dart';

enum MobileValidationError { empty, invalid }

class Mobile extends FormzInput<String, MobileValidationError> {
  const Mobile.pure([super.value = '']) : super.pure();

  const Mobile.dirty([super.value = '']) : super.dirty();

  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  @override
  MobileValidationError? validator(String? value) {
    return value!.trim().isEmpty
        ? MobileValidationError.empty
        : value.trim().length >=8
            ? null
            : MobileValidationError.invalid;
  }
}
