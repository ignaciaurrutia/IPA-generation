import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/shared/shared.dart';
import 'products_repository_provider.dart';


final patientProvider = StateNotifierProvider.autoDispose
    .family<PatientNotifier, PatientState, Email>((ref, patientEmail) {
    
    final productsRepository = ref.watch(productsRepositoryProvider);
  
  return PatientNotifier(
      productsRepository: productsRepository, 
      patientEmail: patientEmail
    );
});



class PatientNotifier extends StateNotifier<PatientState> {

  final ProductsRepository productsRepository;


  PatientNotifier({
    required this.productsRepository,
    required Email patientEmail,
  }) : super(PatientState(email: patientEmail)) {
    loadPatient();
  }

  Patient newEmptyPatient() {
    return Patient(
      email: const Email.pure(),
      babyIsBorn: false,
      firstName: const FirstName.pure(),
      lastName: const LastName.pure(),
      dueDate: const DueDate.pure(),
      bornDate: const BornDate.pure(),
      height: const Height.pure(),
      images: [],
      medicalStaff: [],
      phone: const Phone.pure(),
      comuneLiving: '',
      rut: const Rut.pure(),
      lastPeriodDate: const LastPeriodDate.pure(),
      pregnancyWeek: 0,
      pregnancyWeekDay: 0,
      subscriptionDate: '',
      planType: '',
      healthInsurance: '',
      babyName: '',
      partnerFirstName: const FirstName.pure(),
      partnerLastName: const LastName.pure(),
      partnerPhone: const PartnerPhone.pure(),
      gestationalAge: '',
      category: '',
      region: '',
      province: '',
      address: '',
      midwife: '',
      group: '',
      medicalStaffEmail: const MedicalStaffEmail.pure(),
    );
  }


  Future<void> loadPatient() async {

    try {

      if (state.email.value.toString() == 'new') {
        state = state.copyWith(
          isLoading: false,
          patient: newEmptyPatient(),
        ); 
        return;
      }
      state = state.copyWith(
        isLoading: false,
        patient: await productsRepository.getPatientByEmail(state.email)
      );

    } catch (e) {
      // 404 patient not found
      print(e);
    }

  }

}



class PatientState {

  final Email email;
  final Patient? patient;
  final bool isLoading;
  final bool isSaving;

  PatientState({
    required this.email,
    this.patient, 
    this.isLoading = true, 
    this.isSaving = false,
  });

  PatientState copyWith({
    Email? email,
    Patient? patient,
    bool? isLoading,
    bool? isSaving,
  }) =>
      PatientState(
        email: email ?? this.email,
        patient: patient ?? this.patient,
    isLoading: isLoading ?? this.isLoading,
    isSaving: isSaving ?? this.isSaving,
  );
  
}

