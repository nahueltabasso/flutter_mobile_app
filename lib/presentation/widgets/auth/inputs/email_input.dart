import 'package:formz/formz.dart';
import 'package:techconnect_mobile/config/shared/constans.dart';

enum EmailInputError { empty, invalid }

class EmailInput extends FormzInput<String, EmailInputError>{

  static final RegExp emailRegExp = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$',
  );

  const EmailInput.pure() : super.pure('');
  const EmailInput.dirty({String value = ''}) : super.dirty(value);


  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == EmailInputError.empty) return CommonConstant.EMPTY_FIELD_ERROR;
    if (displayError == EmailInputError.invalid) return CommonConstant.EMAIL_FIELD_ERROR;
    return null;
  }

  @override
  EmailInputError? validator(String? value) {
    if (value == null) return EmailInputError.empty;
    if (value.isEmpty || value.trim().isEmpty) return EmailInputError.empty;
    if (!emailRegExp.hasMatch(value)) return EmailInputError.invalid;
    return null;
  }

}