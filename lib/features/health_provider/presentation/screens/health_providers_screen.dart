import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:teslo_shop/features/health_provider/presentation/providers/providers.dart';
import 'package:teslo_shop/features/health_provider/presentation/widgets/widgets.dart';
import 'package:teslo_shop/features/shared/widgets/hp_side_menu.dart';
import 'package:teslo_shop/features/health_provider/domain/entities/health_provider.dart';
import 'package:teslo_shop/features/products/presentation/functions/hp_upper_filter.dart';


class HealthProvidersScreen extends StatefulWidget {
  const HealthProvidersScreen({super.key});

  @override
  _HealthProvidersScreenState createState() => _HealthProvidersScreenState();
}

class _HealthProvidersScreenState extends State<HealthProvidersScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  HPUpperFilterOption _selectedHPFilter = HPUpperFilterOption.seeAll;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _updateHPFilter(HPUpperFilterOption filter) {
    setState(() {
      _selectedHPFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HPSideMenu(
        scaffoldKey: scaffoldKey,
      ),
      appBar: AppBar(
        title: const Text('Tratantes'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 29, 138, 146),
        iconTheme: const IconThemeData(color: Colors.white),
        toolbarHeight: 80, // Establecer la altura del AppBar
      ),
      body: Column(
        children: [
          Container(
            color: const Color.fromARGB(255, 29, 138, 146), // Usa el mismo color que el AppBar
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0), // Ajusta el padding según tu preferencia
              child: Container(
                height: 40.0, // Altura de la barra de búsqueda
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  controller: searchController,
                  style: const TextStyle(fontSize: 14.0), // Ajusta el tamaño del texto
                  textAlign: TextAlign.left, // Centra el texto
                  decoration: const InputDecoration(
                    hintText: 'Buscar: nombre, rut o email',
                    hintStyle: TextStyle(fontSize: 15.0), // Ajusta el tamaño del texto del hint
                    prefixIcon: Icon(Icons.search),
                    prefixIconConstraints: BoxConstraints(
                      minWidth: 40, // Ajusta el tamaño del icono
                      minHeight: 40, // Ajusta el tamaño del icono
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Ajusta el padding para centrar el texto
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.only(left: 35.0), // adjust the value as needed
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Categorías',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 89, 89, 89)), // adjust the size as needed
              ),
            ),
          ),
          const SizedBox(height: 1),
          _buildGridView(context),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.only(left: 35.0), // Ajusta el valor de izquierda según tu preferencia
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Tratantes', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 89, 89, 89))),
            ),
          ),
          const SizedBox(height: 6),
          const Divider(),
          Expanded(
            child: _HealthProvidersView(
              searchQuery: searchController.text,
              selectedHPFilter: _selectedHPFilter,
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 70.0, // Ancho del botón
        height: 70.0, // Alto del botón
        child: FloatingActionButton(
          onPressed: () {
            context.push('/health_provider/new');
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          backgroundColor: const Color.fromARGB(255, 29, 138, 146),
          child: const Icon(
            Icons.person_add,
            size: 38,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildGridView(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = screenWidth * 0.3;
    const buttonHeight = 40.0;
    return SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Wrap(
            spacing: 10,
            alignment: WrapAlignment.center,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _updateHPFilter(HPUpperFilterOption.psychologist),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          minimumSize: Size(buttonWidth, buttonHeight),
                          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                        ),
                        child: const Text('Psicólogo/a', style: TextStyle(color: Color.fromARGB(255, 233, 162, 0), fontWeight: FontWeight.bold)),
                      ),
                      ElevatedButton(
                        onPressed: () => _updateHPFilter(HPUpperFilterOption.pediatrician),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          minimumSize: Size(buttonWidth, buttonHeight),
                          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                        ),
                        child: const Text('Pediatra', style: TextStyle(color: Color.fromARGB(255, 29, 138, 146), fontWeight: FontWeight.bold)),
                      ),
                      ElevatedButton(
                        onPressed: () => _updateHPFilter(HPUpperFilterOption.midwife),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                          minimumSize: Size(buttonWidth, buttonHeight),
                        ),
                        child: const Text('Matron/a', style: TextStyle(color: Color.fromARGB(255, 245, 176, 155), fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      
                      ElevatedButton(
                        onPressed: () => _updateHPFilter(HPUpperFilterOption.obstetrician),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                          minimumSize: Size(buttonWidth, buttonHeight),
                        ),
                        child: const Text('Gineco-obstetra', style: TextStyle(color: Color.fromARGB(255, 65, 201, 255), fontWeight: FontWeight.bold)),
                      ),
                      ElevatedButton(
                        onPressed: () => _updateHPFilter(HPUpperFilterOption.other),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                          minimumSize: Size(buttonWidth*0.8, buttonHeight),
                        ),
                        child: const Text('Otra', style: TextStyle(color: Color.fromARGB(255, 89, 89, 89), fontWeight: FontWeight.bold)),
                      ),
                      ElevatedButton(
                        onPressed: () => _updateHPFilter(HPUpperFilterOption.seeAll),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          minimumSize: Size(buttonWidth*0.8, buttonHeight),
                          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                        ),
                        child: const Text('Todo', style: TextStyle(color: Color.fromARGB(255, 102, 187, 116), fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ));
  }
  }


class _HealthProvidersView extends ConsumerStatefulWidget {
  final String searchQuery;
  final HPUpperFilterOption selectedHPFilter;
  const _HealthProvidersView({required this.searchQuery, required this.selectedHPFilter});

  @override
  _HealthProvidersViewState createState() => _HealthProvidersViewState();
}

class _HealthProvidersViewState extends ConsumerState<_HealthProvidersView> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if ((scrollController.position.pixels + 400) >= scrollController.position.maxScrollExtent) {
        ref.read(healthProvidersProvider.notifier).loadNextPage(true);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ref.read(healthProvidersProvider.notifier).refreshHealthProviders();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  List<HealthProvider> _getFilteredHealthProviders(List<HealthProvider> healthProviders, String query) {
    if (query.isEmpty) {
      return healthProviders;
    }
    final lowerQuery = query.toLowerCase();
    return healthProviders.where((provider) {
      final nameMatch = provider.firstName.toLowerCase().contains(lowerQuery) ||
          provider.lastName.toLowerCase().contains(lowerQuery);
      final emailMatch = provider.email.toLowerCase().contains(lowerQuery);
      final rutMatch = provider.rut.toLowerCase().contains(lowerQuery);
      final fullNameMatch = '${provider.firstName} ${provider.lastName}'.toLowerCase().contains(lowerQuery);
      return nameMatch || emailMatch || rutMatch || fullNameMatch;
    }).toList();
  }

  List<HealthProvider> _getSortedHP(List<HealthProvider> patients) {
    List<HealthProvider> sortedPatients = [...patients];
    sortedPatients.sort((a, b) => a.lastName.compareTo(b.lastName));
    return sortedPatients;
  }

  List<HealthProvider> _getDoubleSortedHP(List<HealthProvider> healthProviders, HPUpperFilterOption filter) {
    List<HealthProvider> sortedHP = [...healthProviders]; // Copia de la lista original

    switch (filter) {
      case HPUpperFilterOption.seeAll:
        return sortedHP; // Devuelve todos los pacientes

      case HPUpperFilterOption.other:
        return sortedHP.where((hp) => (hp.occupation == 'Otra')).toList();

      case HPUpperFilterOption.midwife:
        return sortedHP.where((hp) => hp.occupation == 'Matron/a').toList();

      case HPUpperFilterOption.obstetrician:
        return sortedHP.where((hp) => hp.occupation == 'Gineco-obstetra').toList();

      case HPUpperFilterOption.pediatrician:
        return sortedHP.where((hp) => hp.occupation == 'Pediatra').toList();

      case HPUpperFilterOption.psychologist:
        return sortedHP.where((hp) => hp.occupation == 'Psicólogo/a').toList();

      default:
        return sortedHP; // Caso por defecto en caso de que no se reconozca el filtro
    }
  }

  @override
  Widget build(BuildContext context) {
    final healthProvidersState = ref.watch(healthProvidersProvider);
    final upperHPFilter = widget.selectedHPFilter;
    final sortedHP = _getSortedHP(healthProvidersState.healthProviders);
    final doubleSortedHP = _getDoubleSortedHP(sortedHP, upperHPFilter);
    final filteredHealthProviders = _getFilteredHealthProviders(doubleSortedHP, widget.searchQuery);

    return ListView.builder(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      itemCount: filteredHealthProviders.length,
      itemBuilder: (context, index) {
        final healthProvider = filteredHealthProviders[index];
        return Column(
          children: [
            GestureDetector(
              onTap: () => context.push('/health_provider/${healthProvider.email}'),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0), // Ajusta el valor según sea necesario
                child: HealthProviderCard(healthProvider: healthProvider),
              ),
            ),
            const Divider(), // Divider to separate each HealthProviderCard
          ],
        );
      },
    );
  }
}
