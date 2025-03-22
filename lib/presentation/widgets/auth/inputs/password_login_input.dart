import 'package:formz/formz.dart';

enum PasswordLoginInputError { empty }

class PasswordLoginInput extends FormzInput<String, PasswordLoginInputError>{

  const PasswordLoginInput.pure() : super.pure('');
  const PasswordLoginInput.dirty({String value = ''}) : super.dirty(value);


  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == PasswordLoginInputError.empty) return 'La contraseña no puede estar vacia';
    return null;
  }

  @override
  PasswordLoginInputError? validator(String? value) {
    if (value == null) return PasswordLoginInputError.empty;
    if (value.isEmpty || value.trim().isEmpty) return PasswordLoginInputError.empty;
    return null;
  }



}