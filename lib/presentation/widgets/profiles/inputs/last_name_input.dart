import 'package:formz/formz.dart';
import 'package:techconnect_mobile/config/shared/constans.dart';

enum LastNameInputError { empty, invalid }

class LastNameInput extends FormzInput<String, LastNameInputError>{

  static final RegExp regex = RegExp(r'[0-9]');

  const LastNameInput.pure() : super.pure('');
  const LastNameInput.dirty({String value = ''}) : super.dirty(value);


  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == LastNameInputError.empty) return CommonConstant.LAST_NAME_ERROR;
    if (displayError == LastNameInputError.invalid) return CommonConstant.LAST_NAME_ERROR_NUMBER;
    return null;
  }

  @override
  LastNameInputError? validator(String? value) {
    if (value == null) return LastNameInputError.empty;
    if (value.isEmpty || value.trim().isEmpty) return LastNameInputError.empty;
    if (regex.hasMatch(value)) return LastNameInputError.invalid;
    return null;
  }

}