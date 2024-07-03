import 'package:formz/formz.dart';

// Define input validation errors
enum PartnerPhoneError {format }

// Extend FormzInput and provide the input type and error type.
class PartnerPhone extends FormzInput<String, PartnerPhoneError> {

  static final RegExp phoneRegExp = RegExp(
    r'^569\d{8}$'
  );

  // Call super.pure to represent an unmodified form input.
  const PartnerPhone.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const PartnerPhone.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == PartnerPhoneError.format) return 'El número de teléfono es inválido';

    return null;
  }
  @override
  PartnerPhoneError? validator(String value) {
    if (value.isEmpty) return null;
    if ( !phoneRegExp.hasMatch(value) ) return PartnerPhoneError.format;

    return null;
  }
}
