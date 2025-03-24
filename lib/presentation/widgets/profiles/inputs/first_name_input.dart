import 'package:formz/formz.dart';
import 'package:techconnect_mobile/config/shared/constans.dart';

enum FisrtNameInputError { empty, invalid }

class FirstNameInput extends FormzInput<String, FisrtNameInputError>{

  static final RegExp regex = RegExp(r'[0-9]');

  const FirstNameInput.pure() : super.pure('');
  const FirstNameInput.dirty({String value = ''}) : super.dirty(value);


  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == FisrtNameInputError.empty) return CommonConstant.FIRST_NAME_ERROR;
    if (displayError == FisrtNameInputError.invalid) return CommonConstant.FIRST_NAME_ERROR_NUMBER;
    return null;
  }

  @override
  FisrtNameInputError? validator(String? value) {
    if (value == null) return FisrtNameInputError.empty;
    if (value.isEmpty || value.trim().isEmpty) return FisrtNameInputError.empty;
    if (regex.hasMatch(value)) return FisrtNameInputError.invalid;
    return null;
  }

}