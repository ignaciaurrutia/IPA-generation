import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/providers.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/inputs.dart';
import 'package:teslo_shop/features/shared/shared.dart';


final patientFormProvider = StateNotifierProvider.autoDispose.family<PatientFormNotifier, PatientFormState, Patient>(
  (ref, patient) {

    // final createUpdateCallback = ref.watch( productsRepositoryProvider ).createUpdateProduct;
    final createUpdateCallback = ref.watch( productsProvider.notifier ).createOrUpdateProduct;

    return PatientFormNotifier(
      patient: patient,
      onSubmitCallback: createUpdateCallback,
    );
  }
);

class PatientFormNotifier extends StateNotifier<PatientFormState> {

  final Future<bool> Function( Map<String,dynamic> patientLike )? onSubmitCallback;

  PatientFormNotifier({
    this.onSubmitCallback,
    required Patient patient,
  }): super(
    PatientFormState(
      firstName: patient.firstName,
      lastName: patient.lastName,
      email: patient.email,
      dueDate: patient.dueDate,
      bornDate: patient.bornDate,
      height: patient.height,
      phone: patient.phone,
      rut: patient.rut,
      medicalStaffEmail: patient.medicalStaffEmail,
      babyName: patient.babyName,
      partnerFirstName: patient.partnerFirstName,
      partnerLastName: patient.partnerLastName,
      partnerPhone: patient.partnerPhone,

    )
  );

  Future<bool> onFormSubmit(String request, Email originalEmail) async {
    _touchedEverything();
    if ( !state.isFormValid ) return false;
    if ( onSubmitCallback == null ) return false;

    Map<String, String?> patientLike;

    if (request == 'POST') {
      patientLike = {
        'request': request,
        'email': state.email.value.toString(),
        'first_name': state.firstName.value.toString(),
        'last_name': state.lastName.value.toString(),
        'due_date': state.dueDate.value.toString(),
        'code': 'no-code',
        // 'edinburgh_filled': '0',
        // 'life_cycle': 'pregnant',
        // 'user_status': 'active',
        'height': state.height.value.toString(),
        'phone' : state.phone.value.toString(),
        'rut' : state.rut.value.toString(),
        'medical_staff': state.medicalStaffEmail.value.toString(),
      };
    } else {
      patientLike = {
        'request': request,
        'original_email': originalEmail.value.toString(),
        'email': state.email.value.toString(),
        'first_name': state.firstName.value.toString(),
        'last_name': state.lastName.value.toString(),
        'due_date': state.dueDate.value.toString(),
        'height': state.height.value.toString(),
        'phone' : state.phone.value.toString(),
        'rut' : state.rut.value.toString(),
        'baby_name' : state.babyName.toString(),
        'partner_first_name' : state.partnerFirstName.value.toString(),
        'partner_last_name' : state.partnerLastName.value.toString(),
        'partner_phone' : state.partnerPhone.value.toString(),
      };
    }

    try {
      return await onSubmitCallback!( patientLike );
    } catch (e) {
      return false;
    }

  }


  void _touchedEverything() {
    state = state.copyWith(
      isFormValid: Formz.validate([
        FirstName.dirty(state.firstName.value),
        LastName.dirty(state.lastName.value),
        DueDate.dirty(state.dueDate.value),
        Height.dirty(state.height.value),
        Email.dirty(state.email.value),
        Phone.dirty(state.phone.value),
        Rut.dirty(state.rut.value),
        PartnerPhone.dirty(state.partnerPhone.value),
        // MedicalStaffEmail.dirty(state.medicalStaffEmail.value),
      ]),
    );
  }


  void onFirstNameChanged( String value ) {
    state = state.copyWith(
      firstName: FirstName.dirty(value),
      isFormValid: Formz.validate([
        FirstName.dirty(value),
        LastName.dirty(state.lastName.value),
        DueDate.dirty(state.dueDate.value),
        Height.dirty(state.height.value),
        Email.dirty(state.email.value),
        Phone.dirty(state.phone.value),
        Rut.dirty(state.rut.value),
        PartnerPhone.dirty(state.partnerPhone.value),
        // MedicalStaffEmail.dirty(state.medicalStaffEmail.value),
      ])
    );
  }

  void onLastNameChanged( String value ) {
    state = state.copyWith(
      lastName: LastName.dirty(value),
      isFormValid: Formz.validate([
        FirstName.dirty(state.firstName.value),
        LastName.dirty(value),
        DueDate.dirty(state.dueDate.value),
        Height.dirty(state.height.value),
        Email.dirty(state.email.value),
        Phone.dirty(state.phone.value),
        Rut.dirty(state.rut.value),
        PartnerPhone.dirty(state.partnerPhone.value),
        // MedicalStaffEmail.dirty(state.medicalStaffEmail.value),
      ])
    );
  }

  void onDueDateChanged( String value ) {
    state = state.copyWith(
      dueDate: DueDate.dirty(value),
      isFormValid: Formz.validate([
        FirstName.dirty(state.firstName.value),
        LastName.dirty(state.lastName.value),
        DueDate.dirty(value),
        Height.dirty(state.height.value),
        Email.dirty(state.email.value),
        Phone.dirty(state.phone.value),
        Rut.dirty(state.rut.value),
        PartnerPhone.dirty(state.partnerPhone.value),
        // MedicalStaffEmail.dirty(state.medicalStaffEmail.value),
      ])
    );
  }

  void onHeightChanged( double value ) {
    state = state.copyWith(
      height: Height.dirty(value),
      isFormValid: Formz.validate([
        FirstName.dirty(state.firstName.value),
        LastName.dirty(state.lastName.value),
        DueDate.dirty(state.dueDate.value),
        Height.dirty(value),
        Email.dirty(state.email.value),
        Phone.dirty(state.phone.value),
        Rut.dirty(state.rut.value),
        PartnerPhone.dirty(state.partnerPhone.value),
        // MedicalStaffEmail.dirty(state.medicalStaffEmail.value),
      ])
    );
  }

  void onEmailChanged( String email ) {
    state = state.copyWith(
      email: Email.dirty(email),
      isFormValid: Formz.validate([
        FirstName.dirty(state.firstName.value),
        LastName.dirty(state.lastName.value),
        DueDate.dirty(state.dueDate.value),
        Height.dirty(state.height.value),
        Email.dirty(email),
        Phone.dirty(state.phone.value),
        Rut.dirty(state.rut.value),
        PartnerPhone.dirty(state.partnerPhone.value),
        // MedicalStaffEmail.dirty(state.medicalStaffEmail.value),
      ])
    );
  }

  void onPhoneChanged( String phone ) {
    state = state.copyWith(
      phone: Phone.dirty(phone),
      isFormValid: Formz.validate([
        FirstName.dirty(state.firstName.value),
        LastName.dirty(state.lastName.value),
        DueDate.dirty(state.dueDate.value),
        Height.dirty(state.height.value),
        Email.dirty(state.email.value),
        Phone.dirty(phone),
        Rut.dirty(state.rut.value),
        PartnerPhone.dirty(state.partnerPhone.value),
        // MedicalStaffEmail.dirty(state.medicalStaffEmail.value),
      ])
    );
  }

  void onRutChanged( String rut ) {
    state = state.copyWith(
      rut: Rut.dirty(rut),
      isFormValid: Formz.validate([
        FirstName.dirty(state.firstName.value),
        LastName.dirty(state.lastName.value),
        DueDate.dirty(state.dueDate.value),
        Height.dirty(state.height.value),
        Email.dirty(state.email.value),
        Phone.dirty(state.phone.value),
        Rut.dirty(rut),
        PartnerPhone.dirty(state.partnerPhone.value),
        
        // MedicalStaffEmail.dirty(state.medicalStaffEmail.value),
      ])
    );
  }

  // void onMedicalStaffEmailChanged( String medicalStaffEmail ) {
  //   state = state.copyWith(
  //     medicalStaffEmail: MedicalStaffEmail.dirty(medicalStaffEmail),
  //     isFormValid: Formz.validate([
  //       FirstName.dirty(state.firstName.value),
  //       LastName.dirty(state.lastName.value),
  //       DueDate.dirty(state.dueDate.value),
  //       Height.dirty(state.height.value),
  //       Email.dirty(state.email.value),
  //       Phone.dirty(state.phone.value),
  //       Rut.dirty(state.rut.value),
  //       MedicalStaffEmail.dirty(medicalStaffEmail),
  //     ])
  //   );
  // }

  void onMedicalStaffEmailChanged( String medicalStaffEmail ) {
    state = state.copyWith(
      medicalStaffEmail: MedicalStaffEmail.dirty(medicalStaffEmail)
    );
  }

  void onBabyNameChanged( String babyName ) {
    state = state.copyWith(
      babyName: babyName,
      isFormValid: Formz.validate([
        FirstName.dirty(state.firstName.value),
        LastName.dirty(state.lastName.value),
        DueDate.dirty(state.dueDate.value),
        Height.dirty(state.height.value),
        Email.dirty(state.email.value),
        Phone.dirty(state.phone.value),
        Rut.dirty(state.rut.value),
        PartnerPhone.dirty(state.partnerPhone.value),
      ])
    );
  }

  void onPartnerFirstNameChanged( String value ) {
    state = state.copyWith(
      partnerFirstName: FirstName.dirty(value),
      isFormValid: Formz.validate([
        FirstName.dirty(state.firstName.value),
        LastName.dirty(state.lastName.value),
        DueDate.dirty(state.dueDate.value),
        Height.dirty(state.height.value),
        Email.dirty(state.email.value),
        Phone.dirty(state.phone.value),
        Rut.dirty(state.rut.value),
        PartnerPhone.dirty(state.partnerPhone.value),
      ])
    );
  }

  void onPartnerLastNameChanged( String value ) {
    state = state.copyWith(
      partnerLastName: LastName.dirty(value),
      isFormValid: Formz.validate([
        FirstName.dirty(state.firstName.value),
        LastName.dirty(state.lastName.value),
        DueDate.dirty(state.dueDate.value),
        Height.dirty(state.height.value),
        Email.dirty(state.email.value),
        Phone.dirty(state.phone.value),
        Rut.dirty(state.rut.value),
        PartnerPhone.dirty(state.partnerPhone.value),
      ])
    );
  }

  void onPartnerPhoneChanged( String phone ) {
    state = state.copyWith(
      partnerPhone: PartnerPhone.dirty(phone),
      isFormValid: Formz.validate([
        FirstName.dirty(state.firstName.value),
        LastName.dirty(state.lastName.value),
        DueDate.dirty(state.dueDate.value),
        Height.dirty(state.height.value),
        Email.dirty(state.email.value),
        Phone.dirty(state.phone.value),
        Rut.dirty(state.rut.value),
        PartnerPhone.dirty(phone),
      ])
    );
  }



  void onBornDateChanged( String bornDate ) {
    state = state.copyWith(
      bornDate: BornDate.dirty(bornDate)
    );
  }
}



class PatientFormState {

  final bool isFormValid;
  final FirstName firstName;
  final LastName lastName;
  final DueDate dueDate;
  final BornDate? bornDate;
  final Email email;
  final Height height;
  final Phone phone;
  final Rut rut;
  final String? babyName;
  final FirstName partnerFirstName;
  final LastName partnerLastName;
  final PartnerPhone partnerPhone;

  final MedicalStaffEmail medicalStaffEmail;

  PatientFormState({
    this.isFormValid = false, 
    this.email = const Email.dirty(''), 
    this.firstName = const FirstName.dirty(''),
    this.lastName = const LastName.dirty(''),
    this.dueDate = const DueDate.dirty(''),
    this.bornDate,
    this.height = const Height.dirty(0),
    this.phone = const Phone.dirty(''),
    this.rut = const Rut.dirty(''),
    this.babyName = '',
    this.partnerFirstName = const FirstName.dirty(''),
    this.partnerLastName = const LastName.dirty(''),
    this.partnerPhone = const PartnerPhone.dirty(''),

    this.medicalStaffEmail = const MedicalStaffEmail.dirty(''),
  });

  PatientFormState copyWith({
    bool? isFormValid,
    Email? email,
    FirstName? firstName,
    LastName? lastName,
    DueDate? dueDate,
    // LastPeriodDate? lastPeriodDate,
    BornDate? bornDate,
    Height? height,
    Phone? phone,
    Rut? rut,
    String? babyName,
    FirstName? partnerFirstName,
    LastName? partnerLastName,
    PartnerPhone? partnerPhone,

    MedicalStaffEmail? medicalStaffEmail,
  }) => PatientFormState(
    isFormValid: isFormValid ?? this.isFormValid,
    email: email ?? this.email,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    dueDate: dueDate ?? this.dueDate,
    // lastPeriodDate: lastPeriodDate ?? this.lastPeriodDate,
    bornDate: bornDate ?? this.bornDate,
    height: height ?? this.height,
    phone: phone ?? this.phone,
    rut: rut ?? this.rut,
    babyName: babyName ?? this.babyName,
    partnerFirstName: partnerFirstName ?? this.partnerFirstName,
    partnerLastName: partnerLastName ?? this.partnerLastName,
    partnerPhone: partnerPhone ?? this.partnerPhone,
    medicalStaffEmail: medicalStaffEmail ?? this.medicalStaffEmail,

  );


}