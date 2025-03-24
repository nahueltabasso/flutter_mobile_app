import 'package:formz/formz.dart';
import 'package:techconnect_mobile/config/shared/constans.dart';

enum PhoneNumberInputError { empty, invalid }

class PhoneNumberInput extends FormzInput<String, PhoneNumberInputError>{

  static final RegExp regex = RegExp(r'[a-zA-Z]');

  const PhoneNumberInput.pure() : super.pure('');
  const PhoneNumberInput.dirty({String value = ''}) : super.dirty(value);


  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == PhoneNumberInputError.empty) return CommonConstant.TELEPHONE_NUMBER_ERROR;
    if (displayError == PhoneNumberInputError.invalid) return CommonConstant.TELEPHONE_NUMBER_ERROR_LETTERS;
    return null;
  }

  @override
  PhoneNumberInputError? validator(String? value) {
    if (value == null) return PhoneNumberInputError.empty;
    if (value.isEmpty || value.trim().isEmpty) return PhoneNumberInputError.empty;
    if (regex.hasMatch(value)) return PhoneNumberInputError.invalid;
    return null;
  }

}