import 'package:formz/formz.dart';

enum UsernameLoginInputError { empty }

class UsernameLoginInput extends FormzInput<String, UsernameLoginInputError>{

  const UsernameLoginInput.pure() : super.pure('');
  const UsernameLoginInput.dirty({String value = ''}) : super.dirty(value);


  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == UsernameLoginInputError.empty) return 'El nombre de usuario no puede estar vacio';
    return null;
  }

  @override
  UsernameLoginInputError? validator(String? value) {
    if (value == null) return UsernameLoginInputError.empty;
    if (value.isEmpty || value.trim().isEmpty) return UsernameLoginInputError.empty;
    return null;
  }



}