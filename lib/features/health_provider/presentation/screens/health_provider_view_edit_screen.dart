import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/health_provider/domain/domain.dart';
import 'package:teslo_shop/features/health_provider/presentation/providers/providers.dart';
import 'package:teslo_shop/features/health_provider/presentation/widgets/widgets.dart';
import 'package:teslo_shop/features/shared/shared.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';

final editModeProvider = StateProvider<bool>((ref) => false);

class HealthProviderEditViewScreen extends ConsumerWidget {
  final String healthProviderEmail;
  final String request;

  const HealthProviderEditViewScreen(
      {super.key, required this.healthProviderEmail, required this.request});

  void showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Tratante Actualizado')));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editMode = (request == 'PUT') ? ref.watch(editModeProvider) : true;
    final isAdmin = ref.watch(authProvider).user?.isAdmin ?? false;

    final healthProviderState =
        ref.watch(healthProviderProvider(healthProviderEmail));

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            (request == 'POST') ? 'Agregar Tratante' : 'Información de Tratante',
          ),
          backgroundColor: const Color.fromARGB(255, 29, 138, 146),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: healthProviderState.isLoading
            ? const FullScreenLoader()
            : _HealthProviderView(
                healthProvider: healthProviderState.healthProvider!,
                request: request,
              ),
        floatingActionButton: editMode
            ? FloatingActionButton(
                backgroundColor: const Color.fromARGB(255, 29, 138, 146),
                onPressed: () {
                  if (healthProviderState.healthProvider == null) return;

                  ref
                      .read(healthProviderFormProvider(
                              healthProviderState.healthProvider!)
                          .notifier)
                      .onFormSubmit(request, healthProviderEmail)
                      .then((value) {
                        if (!value) return;
                        showSnackbar(context);
                        if (isAdmin) {
                          Navigator.pop(context);
                        }
                        else{
                          Navigator.pop(context);
                          // GoRouter.of(context).go('/health_provider/$healthProviderEmail');
                        }
                      }).catchError((e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$e'),
                          ),
                        );
                      });
                },
                child: const Icon(
                  Icons.save_as,
                  color: Colors.white,
                ),
              )
            : null,
      ),
    );
  }
}

class _HealthProviderView extends ConsumerWidget {
  final HealthProvider healthProvider;
  final String request;

  const _HealthProviderView(
      {required this.healthProvider, required this.request});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: [
        const SizedBox(height: 30),
        _HealthProviderInformation(
            healthProvider: healthProvider, request: request),
      ],
    );
  }
}

class _HealthProviderInformation extends ConsumerWidget {
  final HealthProvider healthProvider;
  final String request;

  _HealthProviderInformation(
      {required this.healthProvider, required this.request});

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final rutController = TextEditingController();
  final sisController = TextEditingController();

  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    rutController.dispose();
    sisController.dispose();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editMode = (request == 'PUT') ? ref.watch(editModeProvider) : true;
    final healthProviderForm =
        ref.watch(healthProviderFormProvider(healthProvider));

    firstNameController.value = TextEditingValue(
        text: healthProviderForm.firstName.value,
        selection: TextSelection.fromPosition(
            TextPosition(offset: healthProviderForm.firstName.value.length)));
    lastNameController.value = TextEditingValue(
        text: healthProviderForm.lastName.value,
        selection: TextSelection.fromPosition(
            TextPosition(offset: healthProviderForm.lastName.value.length)));
    rutController.value = TextEditingValue(
        text: healthProviderForm.rut.value,
        selection: TextSelection.fromPosition(
            TextPosition(offset: healthProviderForm.rut.value.length)));
    sisController.value = TextEditingValue(
        text: healthProviderForm.national_registration_number.value,
        selection: TextSelection.fromPosition(TextPosition(
            offset: healthProviderForm.national_registration_number.value.length)));
    final healthInstitutionsAsyncValue = ref.watch(healthInstitutionsProvider);
    final isAdmin = ref.watch(authProvider).user?.isAdmin ?? false;

    final List<String> occupationOptions = [
      "Matron/a",
      "Pediatra",
      "Psicólogo/a",
      "Gineco-obstetra",
      "Otra, Otra",
    ];

    // Add current occupation to the list if it's not already present
    if (healthProviderForm.occupation.value.isNotEmpty && !occupationOptions.contains(healthProviderForm.occupation.value)) {
      occupationOptions.add(healthProviderForm.occupation.value);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: (request == 'PUT')
                ? Row(
                    children: [
                      Text(
                        (request == 'PUT') ? 'Editar Tratante' : 'Crear Tratante',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color.fromRGBO(89, 89, 89, 1)),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      _EditModeSwitch(),
                    ],
                  )
                : const SizedBox(
                    height: 5,
                  ),
          ),
          if (request == 'POST')
            Center(
              child: CustomFilledButton(
                text: 'Llenar formulario con datos del gobierno',
                buttonColor: const Color.fromARGB(255, 29, 138, 146),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    enableDrag: true,
                    builder: (context) => SizedBox(
                      height: MediaQuery.of(context).size.height * 0.65,
                      child: MedicalStaffBottomSheet(
                        healthProvider: healthProvider,
                        firstNameController: firstNameController,
                        lastNameController: lastNameController,
                        rutController: rutController,
                        sisController: sisController,
                      ),
                    ),
                    showDragHandle: true,
                    backgroundColor: Colors.white,
                  );
                },
              ),
            ),
          const SizedBox(height: 30),
          CustomAutofillTextFormField(
            label: 'Nombre',
            controller: firstNameController,
            suffixIcon:
                const Icon(Icons.person, color: Color.fromRGBO(89, 89, 89, 1)),
            labelColor: const Color.fromRGBO(89, 89, 89, 1),
            onChanged: ref
                .read(healthProviderFormProvider(healthProvider).notifier)
                .onFirstNameChanged,              
            errorMessage: healthProviderForm.firstName.errorMessage,
            enableWriting: editMode,
          ),
          const SizedBox(height: 30),
          CustomAutofillTextFormField(
            label: 'Apellido',
            controller: lastNameController,
            suffixIcon: const Icon(Icons.perm_identity,
                color: Color.fromRGBO(89, 89, 89, 1)),
            labelColor: const Color.fromRGBO(89, 89, 89, 1),
            onChanged: ref
                .read(healthProviderFormProvider(healthProvider).notifier)
                .onLastNameChanged,
            errorMessage: healthProviderForm.lastName.errorMessage,
            enableWriting: editMode,
          ),
          const SizedBox(height: 30),
          CustomTextFormField(
            label: 'Correo',
            initialValue: healthProviderForm.email.value,
            suffixIcon:
                const Icon(Icons.email, color: Color.fromRGBO(89, 89, 89, 1)),
            labelColor: const Color.fromRGBO(89, 89, 89, 1),
            onChanged: ref
                .read(healthProviderFormProvider(healthProvider).notifier)
                .onEmailChanged,
            errorMessage: healthProviderForm.email.errorMessage,
            enableWriting: editMode && isAdmin,
          ),
          const SizedBox(height: 30),
          CustomAutofillTextFormField(
            label: 'Rut',
            controller: rutController,
            suffixIcon: const Icon(Icons.perm_identity,
                color: Color.fromRGBO(89, 89, 89, 1)),
            labelColor: const Color.fromRGBO(89, 89, 89, 1),
            onChanged: ref
                .read(healthProviderFormProvider(healthProvider).notifier)
                .onRutChanged,
            errorMessage: healthProviderForm.rut.errorMessage,
            enableWriting: editMode,
          ),
          const SizedBox(height: 30),
          CustomTextFormField(
            label: 'Teléfono (56912345678)',
            initialValue: healthProviderForm.phone.value,
            suffixIcon: const Icon(Icons.phone_iphone,
                color: Color.fromRGBO(89, 89, 89, 1)),
            labelColor: const Color.fromRGBO(89, 89, 89, 1),
            onChanged: ref
                .read(healthProviderFormProvider(healthProvider).notifier)
                .onPhoneChanged,
            enableWriting: editMode,
            errorMessage: healthProviderForm.phone.errorMessage,
          ),
          const SizedBox(height: 30),
          CustomTextFormField(
            label: 'Código',
            initialValue: healthProviderForm.code,
            suffixIcon: const Icon(Icons.health_and_safety,
                color: Color.fromRGBO(89, 89, 89, 1)),
            labelColor: const Color.fromRGBO(89, 89, 89, 1),
            onChanged: ref
                .read(healthProviderFormProvider(healthProvider).notifier)
                .onCodeChanged,
            enableWriting: editMode,
          ),
          const SizedBox(height: 30),
          CustomAutofillTextFormField(
            label: 'Número de registro nacional',
            controller: sisController,
            suffixIcon: const Icon(Icons.check_circle,
                color: Color.fromRGBO(89, 89, 89, 1)),
            labelColor: const Color.fromRGBO(89, 89, 89, 1),
            onChanged: ref
                .read(healthProviderFormProvider(healthProvider).notifier)
                .onSisChanged,
            enableWriting: editMode,
            errorMessage: healthProviderForm.national_registration_number.errorMessage,
          ),
          const SizedBox(height: 30),
          CustomDropdownButtonFormField<String>(
            label: 'Ocupación',
            value:  healthProviderForm.occupation.value == '' ? null : healthProviderForm.occupation.value,
            items: occupationOptions
                .map((occupation) => DropdownMenuItem<String>(
                      value: occupation,
                      child: Text(
                        occupation,
                        style: const TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
                .toList(),
            onChanged: (editMode && isAdmin)
                ? (String? newValue) {
                    ref
                        .read(healthProviderFormProvider(healthProvider).notifier)
                        .onOccupationChanged(newValue!);
                  }
                : null,
            suffixIcon: const Icon(Icons.work,
                color: Color.fromRGBO(89, 89, 89, 1)),
            labelColor: const Color.fromRGBO(89, 89, 89, 1),
            errorMessage: healthProviderForm.occupation.errorMessage,
            enableWriting: editMode,
          ),
          const SizedBox(height: 30),
          healthInstitutionsAsyncValue.when(
            data: (institutions) {
              // Add current institutions to the list if they are not already present
              final List<String> institutionOptions = institutions.map((inst) => inst.name).toList();

              if (healthProviderForm.health_institution_1.isNotEmpty &&
                  !institutionOptions.contains(healthProviderForm.health_institution_1)) {
                institutionOptions.add(healthProviderForm.health_institution_1);
              }
              if (healthProviderForm.health_institution_2.isNotEmpty &&
                  !institutionOptions.contains(healthProviderForm.health_institution_2)) {
                institutionOptions.add(healthProviderForm.health_institution_2);
              }
              if (healthProviderForm.health_institution_3.isNotEmpty &&
                  !institutionOptions.contains(healthProviderForm.health_institution_3)) {
                institutionOptions.add(healthProviderForm.health_institution_3);
              }

              return Column(
                children: [
                  CustomDropdownButtonFormField<String>(
                    label: 'Institución de Salud 1',
                    value: healthProviderForm.health_institution_1.isNotEmpty
                        ? healthProviderForm.health_institution_1
                        : null,
                    items: institutionOptions
                        .map((institution) => DropdownMenuItem<String>(
                              value: institution,
                              child: Text(
                                institution,
                                style: const TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                    onChanged: editMode
                        ? (String? newValue) {
                            ref
                                .read(healthProviderFormProvider(healthProvider).notifier)
                                .onInstitution1Changed(newValue!);
                          }
                        : null,
                    suffixIcon: const Icon(Icons.local_hospital,
                        color: Color.fromRGBO(89, 89, 89, 1)),
                    labelColor: const Color.fromRGBO(89, 89, 89, 1),
                    enableWriting: editMode,
                  ),
                  const SizedBox(height: 30),
                  CustomDropdownButtonFormField<String>(
                    label: 'Institución de Salud 2',
                    value: healthProviderForm.health_institution_2.isNotEmpty
                        ? healthProviderForm.health_institution_2
                        : null,
                    items: institutionOptions
                        .map((institution) => DropdownMenuItem<String>(
                              value: institution,
                              child: Text(
                                institution,
                                style: const TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                    onChanged: editMode
                        ? (String? newValue) {
                            ref
                                .read(healthProviderFormProvider(healthProvider).notifier)
                                .onInstitution2Changed(newValue!);
                          }
                        : null,
                    suffixIcon: const Icon(Icons.local_hospital,
                        color: Color.fromRGBO(89, 89, 89, 1)),
                    labelColor: const Color.fromRGBO(89, 89, 89, 1),
                    enableWriting: editMode,
                  ),
                  const SizedBox(height: 30),
                  CustomDropdownButtonFormField<String>(
                    label: 'Institución de Salud 3',
                    value: healthProviderForm.health_institution_3.isNotEmpty
                        ? healthProviderForm.health_institution_3
                        : null,
                    items: institutionOptions
                        .map((institution) => DropdownMenuItem<String>(
                              value: institution,
                              child: Text(
                                institution,
                                style: const TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                    onChanged: editMode
                        ? (String? newValue) {
                            ref
                                .read(healthProviderFormProvider(healthProvider).notifier)
                                .onInstitution3Changed(newValue!);
                          }
                        : null,
                    suffixIcon: const Icon(Icons.local_hospital,
                        color: Color.fromRGBO(89, 89, 89, 1)),
                    labelColor: const Color.fromRGBO(89, 89, 89, 1),
                    enableWriting: editMode,
                  ),
                ],
              );
            },
            loading: () => Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
          ),
          const SizedBox(height: 30),
          _StatusSelector(
            selectedStatus: (healthProviderForm.status != '') ? healthProviderForm.status : 'Activo',
            onStatusChanged: ref
                .read(healthProviderFormProvider(healthProvider).notifier)
                .onStatusChanged,
            enableWriting: (editMode && isAdmin),
          ),
          const SizedBox(height: 30),
          if (request == 'PUT')
            PatientCard(
                title: 'Pacientes Actuales',
                pacientesNames: healthProvider.patients,
                hpEmail: healthProvider.email,
                isAdmin: isAdmin),
          const SizedBox(height: 30),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _EditModeSwitch extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editMode = ref.watch(editModeProvider);

    return Switch(
      value: editMode,
      activeColor: const Color.fromARGB(255, 29, 138, 146),
      onChanged: (value) {
        ref.read(editModeProvider.notifier).state = value;
      },
    );
  }
}

class _StatusSelector extends StatelessWidget {
  final String selectedStatus;
  final void Function(String selectedStatus) onStatusChanged;
  final bool enableWriting;

  final List<String> status = const ['Activo', 'Inactivo'];
  final List<IconData> statusIcons = const [
    Icons.check_circle,
    Icons.highlight_off,
  ];

  const _StatusSelector({
    required this.selectedStatus,
    required this.onStatusChanged,
    required this.enableWriting,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SegmentedButton(
        multiSelectionEnabled: false,
        showSelectedIcon: false,
        style: const ButtonStyle(visualDensity: VisualDensity.compact),
        segments: status.map((selection) {
          return ButtonSegment(
            icon: Icon(statusIcons[status.indexOf(selection)]),
            value: selection,
            label: Text(selection, style: const TextStyle(fontSize: 12)),
          );
        }).toList(),
        selected: {selectedStatus},
        onSelectionChanged: (newSelection) {
          if (enableWriting) {
            FocusScope.of(context).unfocus();
            onStatusChanged(newSelection.first);
          }
        },
      ),
    );
  }
}

void showConfirmation(BuildContext context, WidgetRef ref, HealthProvider healthProvider) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Eliminar Tratante'),
        content: Text('¿Está seguro que desea eliminar a ${healthProvider.firstName} ${healthProvider.lastName}?'),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Operación cancelada')),
              );
            },
          ),
          TextButton(
            child: const Text('Sí'),
            onPressed: () async {
              final navigator = Navigator.of(context);
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              navigator.pop();
              bool success = false;
              try {
                final repository = ref.read(healthProvidersRepositoryProvider);
                await repository.deleteHealthProvider(healthProvider.email);
                success = true;
              } catch (e) {
                success = false;
              }
              if (success) {
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text('Tratante eliminado exitosamente')),
                );
                await ref.read(healthProvidersProvider.notifier).refreshHealthProviders();
                navigator.pop();
              } else {
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text('Error al eliminar tratante')),
                );
              }
            },
          ),
        ],
      );
    },
  );
}
