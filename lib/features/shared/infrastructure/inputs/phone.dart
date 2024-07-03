import 'package:formz/formz.dart';

// Define input validation errors
enum PhoneError { empty, format }

// Extend FormzInput and provide the input type and error type.
class Phone extends FormzInput<String, PhoneError> {

  static final RegExp emailRegExp = RegExp(
    r'^569\d{8}$'
  );

  // Call super.pure to represent an unmodified form input.
  const Phone.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const Phone.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == PhoneError.empty) return 'El campo es requerido';
    if (displayError == PhoneError.format) return 'El número de teléfono es inválido';

    return null;
  }

  // String? get errorMessage {
  //   if ( isValid || isPure ) return null;

  //   if ( displayError == RutError.empty ) return 'El campo es requerido';
  //   if ( displayError == RutError.format ) return 'No tiene formato de rut';

  //   return null;
  // }

  // Override validator to handle validating a given input value.
  // @override
  // PhoneError? validator(String value) {
  //   if (value.isEmpty || value.trim().isEmpty) return PhoneError.empty;
  //   if (!_validatePhone(value)) return PhoneError.invalid;

  //   return null;
  // }

  // // Método privado para validar el teléfono
  // bool _validatePhone(String phone) {
  //   // Regex para validar que el teléfono sea del tipo +56912345678
  //   final regex = RegExp(r'^\+569\d{8}$');
  //   return regex.hasMatch(phone);
  // }
  @override
  PhoneError? validator(String value) {
    
    if ( value.isEmpty || value.trim().isEmpty ) return PhoneError.empty;
    if ( !emailRegExp.hasMatch(value) ) return PhoneError.format;

    return null;
  }
}
