import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/providers.dart';
import 'package:teslo_shop/features/shared/shared.dart';
import 'package:teslo_shop/features/health_provider/domain/domain.dart';
import 'package:teslo_shop/features/health_provider/presentation/providers/health_providers_provider.dart';  // Asegúrate de que este archivo contiene HealthProvidersProvider
import 'package:teslo_shop/features/shared/widgets/custom_text_form_field.dart';
import 'package:teslo_shop/features/shared/widgets/full_screen_loader.dart';

class PatientEditScreen extends ConsumerWidget {
  final Email patientEmail;
  final String request;

  const PatientEditScreen({super.key, required this.patientEmail, required this.request});

  void showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    request == 'POST' ?
        ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Paciente Agregada Correctamente'))) : 
        ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Paciente Actualizada')));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientState = ref.watch(patientProvider(patientEmail));
    final healthProvidersState = ref.watch(healthProvidersProvider);
    final sortedHealthProviders = _getSortedHP(healthProvidersState.healthProviders);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Imagen_portada.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: patientState.isLoading
            ? const FullScreenLoader()
            : _PatientFormDetails(
                patient: patientState.patient!, request: request, sortedHealthProviders: sortedHealthProviders,),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (patientState.patient == null) return;
            bool isSuccess = await ref.read(patientFormProvider(patientState.patient!).notifier)
                .onFormSubmit(request, patientEmail);
            if (isSuccess) {
              showSnackbar(context);
              Navigator.pop(context, true);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Error al guardar los datos del paciente'),
                ),
              );
            }
          },
          child: const Icon(Icons.save),
        ),
      ),
    );
  }
  List<HealthProvider> _getSortedHP(List<HealthProvider> healthProviders) {
    List<HealthProvider> sortedPatients = [...healthProviders];
    sortedPatients.sort((a, b) => a.lastName.compareTo(b.lastName));
    return sortedPatients;
  }
}

class _PatientFormDetails extends ConsumerWidget {
  final Patient patient;
  final String request;
  final List<HealthProvider> sortedHealthProviders;
  const _PatientFormDetails({required this.patient, required this.request, required this.sortedHealthProviders,});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientForm = ref.watch(patientFormProvider(patient));
    final isAdmin = ref.watch(authProvider).user?.isAdmin;

    return ListView(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Text(
              request == 'POST' ? 'Registrar Nueva Paciente' : 'Editar Paciente',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: const Color.fromRGBO(89, 89, 89, 1),
              ),
            ),
            const SizedBox(height: 30),
            CustomTextFormField(
              label: 'Nombre',
              initialValue: patientForm.firstName.value,
              suffixIcon: const Icon(Icons.person, color: Color.fromRGBO(89, 89, 89, 1)),
              labelColor: const Color.fromRGBO(89, 89, 89, 1),
              onChanged:
                  ref.read(patientFormProvider(patient).notifier).onFirstNameChanged,
              errorMessage: patientForm.firstName.errorMessage,
            ),
            const SizedBox(height: 30),
            CustomTextFormField(
              label: 'Apellidos',
              initialValue: patientForm.lastName.value,
              suffixIcon: const Icon(Icons.perm_identity, color: Color.fromRGBO(89, 89, 89, 1)),
              labelColor: const Color.fromRGBO(89, 89, 89, 1),
              onChanged:
                  ref.read(patientFormProvider(patient).notifier).onLastNameChanged,
              errorMessage: patientForm.lastName.errorMessage,
            ),
            const SizedBox(height: 30),
            if (isAdmin!) 
            Column(children: [
              CustomTextFormField(
              label: 'Correo',
              initialValue: patientForm.email.value,
              suffixIcon: const Icon(Icons.email, color: Color.fromRGBO(89, 89, 89, 1)),
              labelColor: const Color.fromRGBO(89, 89, 89, 1),
              onChanged:
                  ref.read(patientFormProvider(patient).notifier).onEmailChanged,
              errorMessage: patientForm.email.errorMessage,
            ),
            const SizedBox(height: 30),]),
            if (isAdmin! == false && request == 'POST') 
            Column(children: [
              CustomTextFormField(
              label: 'Correo',
              initialValue: patientForm.email.value,
              suffixIcon: const Icon(Icons.email, color: Color.fromRGBO(89, 89, 89, 1)),
              labelColor: const Color.fromRGBO(89, 89, 89, 1),
              onChanged:
                  ref.read(patientFormProvider(patient).notifier).onEmailChanged,
              errorMessage: patientForm.email.errorMessage,
            ),
            const SizedBox(height: 30),]),
            DatePickerFormField(
              label: 'Fecha probable de parto',
              initialValue: patientForm.dueDate.value,
              labelColor: const Color.fromRGBO(89, 89, 89, 1),
              onChanged:
                  ref.read(patientFormProvider(patient).notifier).onDueDateChanged,
              errorMessage: patientForm.dueDate.errorMessage,
            ),
            const SizedBox(height: 30),
            CustomTextFormField(
              label: 'Altura en centímetros',
              initialValue: patientForm.height.value.toString(),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              suffixIcon:
                  const Icon(Icons.height, color: Color.fromRGBO(89, 89, 89, 1)),
              labelColor: const Color.fromRGBO(89, 89, 89, 1),
              onChanged: (value) => ref.read(patientFormProvider(patient).notifier).onHeightChanged( double.tryParse(value) ?? -1),
              errorMessage: patientForm.height.errorMessage,
            ),
            const SizedBox(height: 30),
            CustomTextFormField(
              label: 'Número de teléfono (ejemplo: 56912345678)',
              initialValue: patientForm.phone.value,
              suffixIcon: const Icon(Icons.phone, color: Color.fromRGBO(89, 89, 89, 1)),
              labelColor: const Color.fromRGBO(89, 89, 89, 1),
              onChanged:
                  ref.read(patientFormProvider(patient).notifier).onPhoneChanged,
              errorMessage: patientForm.phone.errorMessage,
            ),
            const SizedBox(height: 30),
            CustomTextFormField(
              label: 'Rut: 12345678-9',
              initialValue: patientForm.rut.value,
              labelColor: const Color.fromRGBO(89, 89, 89, 1),
              onChanged:
                  ref.read(patientFormProvider(patient).notifier).onRutChanged,
              errorMessage: patientForm.rut.errorMessage,
            ),
            const SizedBox(height: 30),
            if (isAdmin! && request == 'POST') 
            Column(children: [
              CustomDropdownButtonFormField<HealthProvider>(
                label: 'Seleccionar Tratante Asociado',
                value: null,
                items: sortedHealthProviders.map((hp) {
                  return DropdownMenuItem<HealthProvider>(
                    value: hp,
                    child: Text('${hp.firstName} ${hp.lastName}'),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    ref.read(patientFormProvider(patient).notifier).onMedicalStaffEmailChanged(value.email);
                  }
                },
                labelColor: const Color.fromRGBO(89, 89, 89, 1),
                enableWriting: true,
              ),
            const SizedBox(height: 30),]),
            if (request == 'PUT') 
            Column(
              children: [
                  const Text(
                  'Información del Bebé',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                  const SizedBox(height: 30),
                CustomTextFormField(
                label: 'Nombre del Bebé',
                initialValue: patientForm.babyName ?? '',
                suffixIcon: const Icon(Icons.child_care, color: Color.fromRGBO(89, 89, 89, 1)),
                labelColor: const Color.fromRGBO(89, 89, 89, 1),
                onChanged:
                    ref.read(patientFormProvider(patient).notifier).onBabyNameChanged,
              ),
                  const SizedBox(height: 30),
                  const Text(
                  'Información de Acompañante',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                  const SizedBox(height: 30),
                  CustomTextFormField(
                label: 'Nombre',
                initialValue: patientForm.partnerFirstName.value,
                  suffixIcon: const Icon(Icons.man, color: Color.fromRGBO(89, 89, 89, 1)),
                labelColor: const Color.fromRGBO(89, 89, 89, 1),
                onChanged:
                  ref.read(patientFormProvider(patient).notifier).onPartnerFirstNameChanged,
              ),
                  const SizedBox(height: 30),
                  CustomTextFormField(
                label: 'Apellido',
                initialValue: patientForm.partnerLastName.value,
                  suffixIcon: const Icon(Icons.man_outlined, color: Color.fromRGBO(89, 89, 89, 1)),
                labelColor: const Color.fromRGBO(89, 89, 89, 1),
                onChanged:
                  ref.read(patientFormProvider(patient).notifier).onPartnerLastNameChanged,
              ),
                  const SizedBox(height: 30),
                  CustomTextFormField(
                label: 'Teléfono (ejemplo: 56912345678)',
                initialValue: patientForm.partnerPhone.value,
                  suffixIcon: const Icon(Icons.phone_iphone_outlined, color: Color.fromRGBO(89, 89, 89, 1)),
                labelColor: const Color.fromRGBO(89, 89, 89, 1),
                onChanged:
                  ref.read(patientFormProvider(patient).notifier).onPartnerPhoneChanged,
                errorMessage: patientForm.partnerPhone.errorMessage,
              ),
                const SizedBox(height: 30),
            ],
            ),
            const SizedBox(height: 100),
          ],
        ),
      )
    ]);
  }
}
