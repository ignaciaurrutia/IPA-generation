import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

import 'package:teslo_shop/features/health_provider/domain/domain.dart';
import 'package:teslo_shop/features/health_provider/presentation/providers/providers.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/inputs.dart';
import 'package:teslo_shop/features/shared/shared.dart';


final healthProviderFormProvider = StateNotifierProvider.autoDispose.family<HealthProviderFormNotifier, HealthProviderFormState, HealthProvider>(
  (ref, healthProvider) {

    // final createUpdateCallback = ref.watch( productsRepositoryProvider ).createUpdateProduct;
    final createUpdateCallback = ref.watch( healthProvidersProvider.notifier ).createOrUpdateHealthProvider;

    return HealthProviderFormNotifier(
      healthProvider: healthProvider,
      onSubmitCallback: createUpdateCallback,
    );
  }
);





class HealthProviderFormNotifier extends StateNotifier<HealthProviderFormState> {

  final Future<bool> Function(Map<String, dynamic> healthProviderLike)? onSubmitCallback;

  HealthProviderFormNotifier({
    this.onSubmitCallback,
    required HealthProvider healthProvider,
  })  : super(
    HealthProviderFormState(
      firstName: FirstName.dirty(healthProvider.firstName),
      lastName: LastName.dirty(healthProvider.lastName),
      rut: Rut.dirty(healthProvider.rut),
      email: Email.dirty(healthProvider.email),
      phone: Phone.dirty(healthProvider.phone),
      code: healthProvider.code,
      national_registration_number: Required.dirty(healthProvider.national_registration_number),
      occupation: Required.dirty(healthProvider.occupation),
      health_institution_1: healthProvider.health_institution_1,
      health_institution_2: healthProvider.health_institution_2,
      health_institution_3: healthProvider.health_institution_3,
      status: healthProvider.status,
      // patients: healthProvider.patients,
    )
  );

  Future<bool> onFormSubmit(String request, String originalEmail) async {
    _touchedEverything();
    if (!state.isFormValid) return false;

    if (onSubmitCallback == null) return false;

    Map<String, String?> healthProviderLike;

    if (request == 'POST') {
      healthProviderLike = {
        'request': request,
        'first_name': state.firstName.value,
        'last_name': state.lastName.value,
        'email': state.email.value,
        'rut': state.rut.value,
        'phone': state.phone.value,
        'code': state.code,
        'national_registration_number': state.national_registration_number.value,
        'occupation': state.occupation.value,
        'health_institution_1': state.health_institution_1,
        'health_institution_2': state.health_institution_2,
        'health_institution_3': state.health_institution_3,
        'status': state.status,
        // 'patients': state.patients.toString(), // Revisar como mandar los pacintes
      };
    } else {
      healthProviderLike = {
        'request': request,
        'original_email': originalEmail.toString(),
        'first_name': state.firstName.value,
        'last_name': state.lastName.value,
        'email': state.email.value,
        'rut': state.rut.value,
        'phone': state.phone.value,
        'code': state.code,
        'national_registration_number': state.national_registration_number.value,
        'occupation': state.occupation.value,
        'health_institution_1': state.health_institution_1,
        'health_institution_2': state.health_institution_2,
        'health_institution_3': state.health_institution_3,
        'status': state.status,
        // 'patients': state.patients.toString(), // Revisar como mandar los pacintes
      };
    }

    try {
      return await onSubmitCallback!(healthProviderLike);
    } catch (e) {
      throw Exception(e);
      // return false;
    }
  }

  void _touchedEverything() {
    state = state.copyWith(
      isFormValid: Formz.validate([
        FirstName.dirty(state.firstName.value),
        LastName.dirty(state.lastName.value),
        Email.dirty(state.email.value),
        Rut.dirty(state.rut.value),
        Phone.dirty(state.phone.value),
        Required.dirty(state.occupation.value),
        Required.dirty(state.national_registration_number.value),
      ]),
    );
  }

  void onFirstNameChanged(String value) {
    state = state.copyWith(
      firstName: FirstName.dirty(value),
      isFormValid: Formz.validate([
        FirstName.dirty(value),
        LastName.dirty(state.lastName.value),
        Email.dirty(state.email.value),
        Rut.dirty(state.rut.value),
        Phone.dirty(state.phone.value),
        Required.dirty(state.occupation.value),
        Required.dirty(state.national_registration_number.value),
      ]),
    );
  }

  void onLastNameChanged(String value) {
    state = state.copyWith(
      lastName: LastName.dirty(value),
      isFormValid: Formz.validate([
        FirstName.dirty(state.firstName.value),
        LastName.dirty(value),
        Email.dirty(state.email.value),
        Rut.dirty(state.rut.value),
        Phone.dirty(state.phone.value),
        Required.dirty(state.occupation.value),
        Required.dirty(state.national_registration_number.value),
      ]),
    );
  }

  void onRutChanged(String value) {
    state = state.copyWith(
      rut: Rut.dirty(value),
      isFormValid: Formz.validate([
        FirstName.dirty(state.firstName.value),
        LastName.dirty(state.lastName.value),
        Rut.dirty(value),
        Email.dirty(state.email.value),
        Phone.dirty(state.phone.value),
        Required.dirty(state.occupation.value),
        Required.dirty(state.national_registration_number.value),
      ]),
    );
  }

  void onEmailChanged(String email) {
    state = state.copyWith(
      email: Email.dirty(email),
      isFormValid: Formz.validate([
        FirstName.dirty(state.firstName.value),
        LastName.dirty(state.lastName.value),
        Rut.dirty(state.rut.value),
        Email.dirty(email),
        Phone.dirty(state.phone.value),
        Required.dirty(state.occupation.value),
        Required.dirty(state.national_registration_number.value),
      ]),
    );
  }

  void onPhoneChanged(String phone) {
    state = state.copyWith(
      phone: Phone.dirty(phone),
      isFormValid: Formz.validate([
        FirstName.dirty(state.firstName.value),
        LastName.dirty(state.lastName.value),
        Rut.dirty(state.rut.value),
        Email.dirty(state.email.value),
        Phone.dirty(phone),
        Required.dirty(state.occupation.value),
        Required.dirty(state.national_registration_number.value),
      ]),
    );
  }

  void onCodeChanged(String code) {
    state = state.copyWith(
      code: code,
    );
  }

  void onSisChanged(String national_registration_number) {
    state = state.copyWith(
      national_registration_number: Required.dirty(national_registration_number),
      isFormValid: Formz.validate([
        FirstName.dirty(state.firstName.value),
        LastName.dirty(state.lastName.value),
        Rut.dirty(state.rut.value),
        Email.dirty(state.email.value),
        Phone.dirty(state.phone.value),
        Required.dirty(state.occupation.value),
        Required.dirty(national_registration_number),
      ]),
    );
  }

  void onOccupationChanged(String occupation) {
    state = state.copyWith(
      occupation: Required.dirty(occupation),
      isFormValid: Formz.validate([
        FirstName.dirty(state.firstName.value),
        LastName.dirty(state.lastName.value),
        Rut.dirty(state.rut.value),
        Email.dirty(state.email.value),
        Phone.dirty(state.phone.value),
        Required.dirty(occupation),
        Required.dirty(state.national_registration_number.value),
      ]),
    );
  }

  void onInstitution1Changed(String health_institution_1) {
    state = state.copyWith(
      health_institution_1: health_institution_1,
    );
  }

  void onInstitution2Changed(String health_institution_2) {
    state = state.copyWith(
      health_institution_2: health_institution_2,
    );
  }

  void onInstitution3Changed(String health_institution_3) {
    state = state.copyWith(
      health_institution_3: health_institution_3,
    );
  }

  void onStatusChanged(String status) {
    state = state.copyWith(
      status: status,
    );
  }

  // void onPatientsChanged( String patient ) {
  //   state = state.copyWith(
  //     patients: [...state.patients, patient]
  //   );
  // }

}


class HealthProviderFormState {

  final bool isFormValid;
  final FirstName firstName;
  final LastName lastName;
  final Rut rut;
  final Email email;
  final Phone phone;
  final String code;
  final Required national_registration_number;
  final Required occupation;
  final String health_institution_1;
  final String health_institution_2;
  final String health_institution_3;
  final String status;
  // final List<String> patients;


  HealthProviderFormState({
    this.isFormValid = false, 
    this.firstName = const FirstName.dirty(''),
    this.lastName = const LastName.dirty(''),
    this.email = const Email.dirty(''), 
    this.rut = const Rut.dirty(''),
    this.phone = const Phone.dirty(''),
    this.code = '',
    this.national_registration_number = const Required.dirty(''),
    this.occupation = const Required.dirty(''),
    this.health_institution_1 = '',
    this.health_institution_2 = '',
    this.health_institution_3 = '',
    this.status = '',
    // this.patients = const[]
  });

  HealthProviderFormState copyWith({
    bool? isFormValid,
    FirstName? firstName,
    LastName? lastName,
    Email? email,
    Rut? rut,
    Phone? phone,
    String? code,
    Required? national_registration_number,
    Required? occupation,
    String? health_institution_1,
    String? health_institution_2,
    String? health_institution_3,
    String? status,
    List<String>? patients,
  }) => HealthProviderFormState(
    isFormValid: isFormValid ?? this.isFormValid,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    email: email ?? this.email,
    rut: rut ?? this.rut,
    phone: phone ?? this.phone,
    code: code ?? this.code,
    national_registration_number: national_registration_number ?? this.national_registration_number,
    occupation: occupation ?? this.occupation,
    health_institution_1: health_institution_1 ?? this.health_institution_1,
    health_institution_2: health_institution_2 ?? this.health_institution_2,
    health_institution_3: health_institution_3 ?? this.health_institution_3,
    status: status ?? this.status,
    // patients: patients ?? this.patients,
  );


}