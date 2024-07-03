import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/health_provider/domain/entities/health_provider.dart';
import 'package:teslo_shop/features/health_provider/presentation/providers/providers.dart';


class MedicalStaffBottomSheet extends ConsumerStatefulWidget {
  final HealthProvider healthProvider;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController rutController;
  final TextEditingController sisController;

  const MedicalStaffBottomSheet({
    super.key,
    required this.healthProvider,
    required this.firstNameController,
    required this.lastNameController,
    required this.rutController,
    required this.sisController,
  });

  @override
  _MedicalStaffBottomSheetState createState() =>
      _MedicalStaffBottomSheetState();
}

class _MedicalStaffBottomSheetState
    extends ConsumerState<MedicalStaffBottomSheet> {
  final ScrollController scrollController = ScrollController();
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }


  void searchButtonPressed() {
    ref
        .read(csvhealthProvidersProvider.notifier)
        .loadCSVNextPage(searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  style: const TextStyle(fontSize: 14.0),
                  textAlign: TextAlign.left,
                  decoration: const InputDecoration(
                    hintText: 'Buscar: nombre',
                    filled: true,
                    fillColor: Color.fromARGB(255, 230, 230, 230),
                    hintStyle: TextStyle(fontSize: 15.0),
                    prefixIcon: Icon(Icons.abc),
                    prefixIconConstraints:
                        BoxConstraints(minWidth: 40, minHeight: 40),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(
                      255, 29, 138, 146), // Background color of the icon button
                ),
                child: IconButton(
                  icon: const Icon(Icons.search,
                      color: Colors.white), // Icon color
                  onPressed: searchButtonPressed,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Consumer(
              builder: (context, watch, child) {
                final healthProvidersState =
                    ref.watch(csvhealthProvidersProvider);
                if (healthProvidersState.isLoading &&
                    healthProvidersState.healthProviders.isEmpty) {
                  return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                } else if (healthProvidersState.errorMessage.isNotEmpty) {
                  return Center(child: Text(healthProvidersState.errorMessage));
                } else if (healthProvidersState.healthProviders.isEmpty) {
                  return const Center(
                    child: Text('Busca a un tratante.'),
                  );
                } else {
                  return ListView.builder(
                    controller: scrollController,
                    physics: const BouncingScrollPhysics(),
                    itemCount: healthProvidersState.healthProviders.length,
                    itemBuilder: (context, index) {
                      final medicalStaff =
                          healthProvidersState.healthProviders[index];
                      String firstName = medicalStaff['first_name'];
                      String lastName = medicalStaff['last_name'];
                      String rut = medicalStaff['rut'];
                      String nationalRegistrationNumber =
                          medicalStaff['National Registration Number']
                              .toString();

                      return GestureDetector(
                        onTap: () {
                          widget.firstNameController.text = firstName;
                          widget.lastNameController.text =
                              lastName.split(' ').first;
                          widget.rutController.text = rut.replaceAll('.', '');
                          widget.sisController.text =
                              nationalRegistrationNumber;

                          ref
                              .read(
                                healthProviderFormProvider(
                                        widget.healthProvider)
                                    .notifier,
                              )
                              .onFirstNameChanged(firstName);
                          ref
                              .read(
                                healthProviderFormProvider(
                                        widget.healthProvider)
                                    .notifier,
                              )
                              .onLastNameChanged(lastName.split(' ').first);
                          ref
                              .read(
                                healthProviderFormProvider(
                                        widget.healthProvider)
                                    .notifier,
                              )
                              .onRutChanged(rut.replaceAll('.', ''));
                          ref
                              .read(
                                healthProviderFormProvider(
                                        widget.healthProvider)
                                    .notifier,
                              )
                              .onSisChanged(nationalRegistrationNumber);

                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('$firstName $lastName'),
                              Text(rut),
                              const Divider(),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
