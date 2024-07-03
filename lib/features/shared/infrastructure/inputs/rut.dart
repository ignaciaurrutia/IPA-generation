import 'package:formz/formz.dart';

// Define input validation errors
enum RutError { empty, format, invalid }

// Extend FormzInput and provide the input type and error type.
class Rut extends FormzInput<String, RutError> {
  static final RegExp rutRegExp = RegExp(
    r'^[0-9]{7,8}-[0-9Kk]$', // Adjusted to accept 7 to 8 digits followed by a dash and a digit or 'K'
  );

  // Call super.pure to represent an unmodified form input.
  const Rut.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const Rut.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == RutError.empty) return 'El campo es requerido';
    if (displayError == RutError.format) return 'El RUT debe estar sin puntos y con guión';
    if (displayError == RutError.invalid) return 'El RUT es inválido';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  RutError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return RutError.empty;
    if (!rutRegExp.hasMatch(value)) return RutError.format;
    if (!_isValidRut(value)) return RutError.invalid;

    return null;
  }

  bool _isValidRut(String rut) {
    // Remove dots and dash
    rut = rut.replaceAll('.', '').replaceAll('-', '');

    // Split the RUT into the number and the verifier
    String number = rut.substring(0, rut.length - 1);
    String verifier = rut.substring(rut.length - 1).toUpperCase();

    // Calculate the verifier
    int sum = 0;
    int multiplier = 2;

    for (int i = number.length - 1; i >= 0; i--) {
      sum += int.parse(number[i]) * multiplier;
      multiplier = (multiplier == 7) ? 2 : multiplier + 1;
    }

    int remainder = 11 - (sum % 11);
    String calculatedVerifier;

    if (remainder == 10) {
      calculatedVerifier = 'K';
    } else if (remainder == 11) {
      calculatedVerifier = '0';
    } else {
      calculatedVerifier = remainder.toString();
    }

    // Check if the calculated verifier matches the provided verifier
    return calculatedVerifier == verifier;
  }
}
