import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/health_provider/presentation/providers/health_providers_repository_provider.dart';
import 'package:teslo_shop/features/products/domain/entities/product.dart';
import 'package:teslo_shop/features/products/presentation/providers/products_provider.dart';

class PatientBottomSheet extends ConsumerStatefulWidget {
  final String healthProviderEmail;
  final Function showConfirmation;

  const PatientBottomSheet({
    super.key,
    required this.healthProviderEmail,
    required this.showConfirmation,
  });

  @override
  _PatientBottomSheetState createState() => _PatientBottomSheetState();
}

class _PatientBottomSheetState extends ConsumerState<PatientBottomSheet> {
  final ScrollController scrollController = ScrollController();
  TextEditingController searchController =
      TextEditingController(); // Controlador para el campo de búsqueda

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if ((scrollController.position.pixels + 400) >=
          scrollController.position.maxScrollExtent) {
        ref.read(productsProvider.notifier).loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose(); // Dispose del controlador de búsqueda
    super.dispose();
  }

  List<Patient> _getFilteredPatients(List<Patient> patients, String query) {
    if (query.isEmpty) {
      return patients;
    }
    final lowerQuery = query.toLowerCase();
    return patients.where((patient) {
      final nameMatch =
          patient.firstName.value.toLowerCase().contains(lowerQuery) ||
              patient.lastName.value.toLowerCase().contains(lowerQuery);
      final rutMatch = patient.rut.value.toLowerCase().contains(lowerQuery);
      final emailMatch = patient.email.value.toLowerCase().contains(lowerQuery);
      final fullNameMatch =
          '${patient.firstName.value} ${patient.lastName.value}'
              .toLowerCase()
              .contains(lowerQuery);
      return nameMatch || emailMatch || rutMatch || fullNameMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final patientState = ref.watch(productsProvider);
    final filteredPatients =
        _getFilteredPatients(patientState.products, searchController.text);

    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: searchController,
              style: const TextStyle(fontSize: 14.0),
              textAlign: TextAlign.left,
              decoration: const InputDecoration(
                hintText: 'Buscar: nombre, email o rut',
                filled: true,
                fillColor: Color.fromARGB(255, 230, 230, 230),
                hintStyle: TextStyle(fontSize: 15.0),
                prefixIcon: Icon(Icons.search),
                prefixIconConstraints:
                    BoxConstraints(minWidth: 40, minHeight: 40),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
              ),
              onChanged: (value) {
                setState(
                    () {});
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                itemCount: filteredPatients.length,
                itemBuilder: (context, index) {
                  final patient = filteredPatients[index];
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          widget.showConfirmation(
                              context,
                              ref.read(healthProvidersRepositoryProvider),
                              {
                                'first_name': patient.firstName.value,
                                'last_name': patient.lastName.value,
                                'email': patient.email.value,
                                'rut': patient.rut,
                                'due_date': patient.dueDate,
                                'phone': patient.phone,
                              },
                              widget.healthProviderEmail,
                              'link',
                              ref.watch(authProvider).user?.isAdmin);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '${patient.firstName.value} ${patient.lastName.value}'),
                              Text(patient.email.value),
                              const Divider(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ));
  }
}
