import 'package:formz/formz.dart';

// Define input validation errors
enum MedicalStaffEmailError { empty, format }

// Extend FormzInput and provide the input type and error type.
class MedicalStaffEmail extends FormzInput<String, MedicalStaffEmailError> {

  static final RegExp emailRegExp = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  // Call super.pure to represent an unmodified form input.
  const MedicalStaffEmail.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const MedicalStaffEmail.dirty( super.value ) : super.dirty();



  String? get errorMessage {
    if ( isValid || isPure ) return null;

    if ( displayError == MedicalStaffEmailError.empty ) return 'El campo es requerido';
    if ( displayError == MedicalStaffEmailError.format ) return 'No tiene formato de correo electrónico';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  MedicalStaffEmailError? validator(String value) {
    
    if ( value.isEmpty || value.trim().isEmpty ) return MedicalStaffEmailError.empty;
    if ( !emailRegExp.hasMatch(value) ) return MedicalStaffEmailError.format;

    return null;
  }
}