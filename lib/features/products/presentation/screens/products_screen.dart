// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// import 'package:teslo_shop/features/products/presentation/providers/providers.dart';
// import 'package:teslo_shop/features/products/presentation/widgets/widgets.dart';
// import 'package:teslo_shop/features/shared/shared.dart';
// import 'package:teslo_shop/features/shared/widgets/side_menu.dart';
// import 'package:teslo_shop/features/products/domain/entities/product.dart';
// import 'package:teslo_shop/features/products/presentation/functions/side_bar_filter.dart';
// import 'package:teslo_shop/features/products/presentation/functions/upper_filter.dart';

// class PatientsScreen extends StatefulWidget {
//   final bool isAdmin;
//   const PatientsScreen({super.key, required this.isAdmin});

//   @override
//   _PatientsScreenState createState() => _PatientsScreenState();
// }

// class _PatientsScreenState extends State<PatientsScreen> {
//   final scaffoldKey = GlobalKey<ScaffoldState>();
//   final TextEditingController searchController = TextEditingController();
//   UpperFilterOption _selectedFilter = UpperFilterOption.seeAll; // Variable para almacenar el filtro seleccionado

//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }

//   void _updateFilter(UpperFilterOption filter) {
//     setState(() {
//       _selectedFilter = filter;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: SideMenu(
//         scaffoldKey: scaffoldKey,
//       ),
//       appBar: AppBar(
//         title: const Text('Mis Pacientes'),
//         centerTitle: true,
//         backgroundColor: const Color.fromARGB(255, 29, 138, 146),
//         iconTheme: const IconThemeData(color: Colors.white),
//         toolbarHeight: 80, // Establecer la altura del AppBar
//       ),
//       body: Column(
//         children: [
//           Container(
//             color: const Color.fromARGB(255, 29, 138, 146), // Usa el mismo color que el AppBar
//             padding: const EdgeInsets.symmetric(vertical: 10.0),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0), // Ajusta el padding según tu preferencia
//               child: Container(
//                 height: 40.0, // Altura de la barra de búsqueda
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(15.0),
//                   border: Border.all(color: Colors.grey.shade300),
//                 ),
//                 child: TextField(
//                   controller: searchController,
//                   style: const TextStyle(fontSize: 14.0), // Ajusta el tamaño del texto
//                   textAlign: TextAlign.left, // Centra el texto
//                   decoration: const InputDecoration(
//                     hintText: 'Buscar: Nombre, Apellido, Rut o Email',
//                     hintStyle: TextStyle(fontSize: 15.0), // Ajusta el tamaño del texto del hint
//                     prefixIcon: Icon(Icons.search),
//                     prefixIconConstraints: BoxConstraints(
//                       minWidth: 40, // Ajusta el tamaño del icono
//                       minHeight: 40, // Ajusta el tamaño del icono
//                     ),
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Ajusta el padding para centrar el texto
//                   ),
//                   onChanged: (value) {
//                     setState(() {});
//                   },
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//           const Padding(
//             padding: EdgeInsets.only(left: 35.0), // adjust the value as needed
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 'Categorías',
//                 style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 89, 89, 89)), // adjust the size as needed
//               ),
//             ),
//           ),
//           const SizedBox(height: 1),
//           _buildGridView(context),
//           const SizedBox(height: 12), // Espacio entre el GridView y la lista de pacientes
//           const Padding(
//             padding: EdgeInsets.only(left: 35.0), // Ajusta el valor de izquierda según tu preferencia
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: Text('Pacientes', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 89, 89, 89))),
//             ),
//           ),
//           const SizedBox(height: 6),
//           const Divider(),
//           Expanded(
//             child: _PatientsView(
//               searchQuery: searchController.text,
//               selectedFilter: _selectedFilter,
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: SizedBox(
//         width: 70.0, // Ancho del botón
//         height: 70.0, // Alto del botón
//         child: FloatingActionButton(
//           onPressed: () {
//             context.push('/patient_edit/new');
//           },
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(40.0),
//           ),
//           backgroundColor: const Color.fromARGB(255, 29, 138, 146),
//           child: const Icon(
//             Icons.person_add,
//             size: 38,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildGridView(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final buttonWidth = screenWidth * 0.3;
//     const buttonHeight = 40.0;
//     return SizedBox(
//         width: double.infinity,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           child: Wrap(
//             spacing: 10,
//             alignment: WrapAlignment.center,
//             children: [
//               Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () => _updateFilter(UpperFilterOption.postpartum),
//                         style: ElevatedButton.styleFrom(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           backgroundColor: const Color.fromARGB(255, 255, 255, 255),
//                           minimumSize: Size(buttonWidth, buttonHeight),
//                         ),
//                         child: const Text('Postparto', style: TextStyle(color: Color.fromARGB(255, 89, 89, 89), fontWeight: FontWeight.bold)),
//                       ),
//                       ElevatedButton(
//                         onPressed: () => _updateFilter(UpperFilterOption.pastDue),
//                         style: ElevatedButton.styleFrom(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           backgroundColor: const Color.fromARGB(255, 255, 255, 255),
//                           minimumSize: Size(buttonWidth, buttonHeight),
//                         ),
//                         child: const Text('Past Due', style: TextStyle(color: Color.fromARGB(255, 245, 176, 155), fontWeight: FontWeight.bold)),
//                       ),
//                       ElevatedButton(
//                         onPressed: () => _updateFilter(UpperFilterOption.lessThan14),
//                         style: ElevatedButton.styleFrom(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           minimumSize: Size(buttonWidth, buttonHeight),
//                           backgroundColor: const Color.fromARGB(255, 255, 255, 255),
//                         ),
//                         child: const Text('≤ 14 días', style: TextStyle(color: Color.fromARGB(255, 29, 138, 146), fontWeight: FontWeight.bold)),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () => _updateFilter(UpperFilterOption.lessThan30),
//                         style: ElevatedButton.styleFrom(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           minimumSize: Size(buttonWidth, buttonHeight),
//                           backgroundColor: const Color.fromARGB(255, 255, 255, 255),
//                         ),
//                         child: const Text('≤ 30 días', style: TextStyle(color: Color.fromARGB(255, 233, 162, 0), fontWeight: FontWeight.bold)),
//                       ),
//                       ElevatedButton(
//                         onPressed: () => _updateFilter(UpperFilterOption.moreThan30),
//                         style: ElevatedButton.styleFrom(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           backgroundColor: const Color.fromARGB(255, 255, 255, 255),
//                           minimumSize: Size(buttonWidth, buttonHeight),
//                         ),
//                         child: const Text('+ 30 días', style: TextStyle(color: Color.fromARGB(255, 65, 201, 255), fontWeight: FontWeight.bold)),
//                       ),
//                       ElevatedButton(
//                         onPressed: () => _updateFilter(UpperFilterOption.seeAll),
//                         style: ElevatedButton.styleFrom(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           minimumSize: Size(buttonWidth, buttonHeight),
//                           backgroundColor: const Color.fromARGB(255, 255, 255, 255),
//                         ),
//                         child: const Text('Ver todo', style: TextStyle(color: Color.fromARGB(255, 102, 187, 116), fontWeight: FontWeight.bold)),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ));
//   }
// }

// class _PatientsView extends ConsumerStatefulWidget {
//   final String searchQuery;
//   final UpperFilterOption selectedFilter;
//   const _PatientsView({required this.searchQuery, required this.selectedFilter});

//   @override
//   _PatientsViewState createState() => _PatientsViewState();
// }

// class _PatientsViewState extends ConsumerState<_PatientsView> {
//   final ScrollController scrollController = ScrollController();
//   final bool isAdmin;

//   @override
//   void initState() {
//     super.initState();

//     scrollController.addListener(() {
//       if ((scrollController.position.pixels + 400) >= scrollController.position.maxScrollExtent) {
//         ref.read(productsProvider.notifier).loadNextPage();
//       }
//     });
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     // Recargar pacientes cuando la vista se muestra de nuevo
//     ref.read(productsProvider.notifier).refreshPatients();
//   }

//   @override
//   void dispose() {
//     scrollController.dispose();
//     super.dispose();
//   }

//   DateTime parseDate(String dateStr) {
//     List<String> parts = dateStr.split('-');
//     if (parts.length != 3) {
//       throw const FormatException("Invalid date format");
//     }
//     int year = int.parse(parts[0]);
//     int month = int.parse(parts[1]);
//     int day = int.parse(parts[2]);
//     return DateTime(year, month, day);
//   }

//   List<Patient> _getSortedPatients(List<Patient> patients, FilterOption filter) {
//     List<Patient> sortedPatients = [...patients];
//     switch (filter) {
//       case FilterOption.alphabetical:
//         sortedPatients.sort((a, b) => a.lastName.value.toLowerCase().compareTo(b.lastName.value.toLowerCase()));
//         break;
//       case FilterOption.dueDateDesc:
//         sortedPatients.sort((a, b) => parseDate(b.dueDate.value).compareTo(parseDate(a.dueDate.value)));
//         break;
//       case FilterOption.dueDateAsc:
//         sortedPatients.sort((a, b) => parseDate(a.dueDate.value).compareTo(parseDate(b.dueDate.value)));
//         break;
//     }
//     return sortedPatients;
//   }

//   List<Patient> _getFilteredPatients(List<Patient> patients, String query) {
//     if (query.isEmpty) {
//       return patients;
//     }
//     final lowerQuery = query.toLowerCase();
//     return patients.where((patient) {
//       final nameMatch = patient.firstName.value.toLowerCase().contains(lowerQuery) ||
//           patient.lastName.value.toLowerCase().contains(lowerQuery);
//       final rutMatch = patient.rut.value.toLowerCase().contains(lowerQuery);
//       final emailMatch = patient.email.value.toLowerCase().contains(lowerQuery);
//       return nameMatch || rutMatch || emailMatch;
//     }).toList();
//   }

//   List<Patient> _getDoubleSortedPatients(List<Patient> patients, UpperFilterOption filter) {
//     List<Patient> sortedPatients = [...patients]; // Copia de la lista original

//     switch (filter) {
//       case UpperFilterOption.seeAll:
//         return sortedPatients; // Devuelve todos los pacientes

//       case UpperFilterOption.postpartum:
//         return sortedPatients.where((patient) => patient.category == 'Postparto').toList();

//       case UpperFilterOption.pastDue:
//         return sortedPatients.where((patient) => patient.category == 'Past Due').toList();

//       case UpperFilterOption.lessThan14:
//         return sortedPatients.where((patient) => patient.category == '≤ 14 dias').toList();

//       case UpperFilterOption.lessThan30:
//         return sortedPatients.where((patient) => patient.category == '≤ 30 dias').toList();

//       case UpperFilterOption.moreThan30:
//         return sortedPatients.where((patient) => patient.category == '+ 30 dias').toList();

//       default:
//         return sortedPatients; // Caso por defecto en caso de que no se reconozca el filtro
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final productsState = ref.watch(productsProvider);
//     final filter = ref.watch(filterProvider);
//     final upperFilter = widget.selectedFilter; // Utiliza el filtro seleccionado pasado como parámetro

//     final sortedPatients = _getSortedPatients(productsState.products, filter);
//     final doubleSortedPatients = _getDoubleSortedPatients(sortedPatients, upperFilter);
//     final filteredPatients = _getFilteredPatients(doubleSortedPatients, widget.searchQuery);

//     return ListView.builder(
//       controller: scrollController,
//       physics: const BouncingScrollPhysics(),
//       itemCount: filteredPatients.length,
//       itemBuilder: (context, index) {
//         final patient = filteredPatients[index];
//         return Column(
//           children: [
//             GestureDetector(
//               onTap: () => context.push('/patient/${patient.email.value}'),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0), // Ajusta el valor según sea necesario
//                 child: PatientCard(patient: patient, isAdmin: isAdmin),
//               ),
//             ),
//             const Divider(), // Divider to separate each ProductCard
//           ],
//         );
//       },
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:teslo_shop/features/products/presentation/providers/providers.dart';
import 'package:teslo_shop/features/products/presentation/widgets/widgets.dart';
import 'package:teslo_shop/features/shared/shared.dart';
import 'package:teslo_shop/features/shared/widgets/side_menu.dart';
import 'package:teslo_shop/features/products/domain/entities/product.dart';
import 'package:teslo_shop/features/products/presentation/functions/side_bar_filter.dart';
import 'package:teslo_shop/features/products/presentation/functions/upper_filter.dart';

class PatientsScreen extends StatefulWidget {
  final bool isAdmin;
  const PatientsScreen({super.key, required this.isAdmin});

  @override
  _PatientsScreenState createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  UpperFilterOption _selectedFilter = UpperFilterOption.seeAll; // Variable para almacenar el filtro seleccionado

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _updateFilter(UpperFilterOption filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(
        scaffoldKey: scaffoldKey,
      ),
      appBar: AppBar(
        title: const Text('Mis Pacientes'),
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
          const SizedBox(height: 12), // Espacio entre el GridView y la lista de pacientes
          const Padding(
            padding: EdgeInsets.only(left: 35.0), // Ajusta el valor de izquierda según tu preferencia
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Pacientes', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 89, 89, 89))),
            ),
          ),
          const SizedBox(height: 6),
          const Divider(),
          Expanded(
            child: _PatientsView(
              searchQuery: searchController.text,
              selectedFilter: _selectedFilter,
              isAdmin: widget.isAdmin, // Pass isAdmin here
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 70.0, // Ancho del botón
        height: 70.0, // Alto del botón
        child: FloatingActionButton(
          onPressed: () {
            context.push('/patient_edit/new');
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
                        onPressed: () => _updateFilter(UpperFilterOption.postpartum),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                          minimumSize: Size(buttonWidth, buttonHeight),
                        ),
                        child: const Text('Postparto', style: TextStyle(color: Color.fromARGB(255, 89, 89, 89), fontWeight: FontWeight.bold)),
                      ),
                      ElevatedButton(
                        onPressed: () => _updateFilter(UpperFilterOption.pastDue),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                          minimumSize: Size(buttonWidth, buttonHeight),
                        ),
                        child: const Text('Past Due', style: TextStyle(color: Color.fromARGB(255, 245, 176, 155), fontWeight: FontWeight.bold)),
                      ),
                      ElevatedButton(
                        onPressed: () => _updateFilter(UpperFilterOption.lessThan14),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          minimumSize: Size(buttonWidth, buttonHeight),
                          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                        ),
                        child: const Text('≤ 14 días', style: TextStyle(color: Color.fromARGB(255, 29, 138, 146), fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _updateFilter(UpperFilterOption.lessThan30),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          minimumSize: Size(buttonWidth, buttonHeight),
                          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                        ),
                        child: const Text('≤ 30 días', style: TextStyle(color: Color.fromARGB(255, 233, 162, 0), fontWeight: FontWeight.bold)),
                      ),
                      ElevatedButton(
                        onPressed: () => _updateFilter(UpperFilterOption.moreThan30),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                          minimumSize: Size(buttonWidth, buttonHeight),
                        ),
                        child: const Text('+ 30 días', style: TextStyle(color: Color.fromARGB(255, 65, 201, 255), fontWeight: FontWeight.bold)),
                      ),
                      ElevatedButton(
                        onPressed: () => _updateFilter(UpperFilterOption.seeAll),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          minimumSize: Size(buttonWidth, buttonHeight),
                          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                        ),
                        child: const Text('Ver todo', style: TextStyle(color: Color.fromARGB(255, 102, 187, 116), fontWeight: FontWeight.bold)),
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

class _PatientsView extends ConsumerStatefulWidget {
  final String searchQuery;
  final UpperFilterOption selectedFilter;
  final bool isAdmin; // Add isAdmin here
  const _PatientsView({required this.searchQuery, required this.selectedFilter, required this.isAdmin});

  @override
  _PatientsViewState createState() => _PatientsViewState();
}

class _PatientsViewState extends ConsumerState<_PatientsView> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if ((scrollController.position.pixels + 400) >= scrollController.position.maxScrollExtent) {
        ref.read(productsProvider.notifier).loadNextPage();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Recargar pacientes cuando la vista se muestra de nuevo
    ref.read(productsProvider.notifier).refreshPatients();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  DateTime parseDate(String dateStr) {
    List<String> parts = dateStr.split('-');
    if (parts.length != 3) {
      throw const FormatException("Invalid date format");
    }
    int year = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int day = int.parse(parts[2]);
    return DateTime(year, month, day);
  }

  List<Patient> _getSortedPatients(List<Patient> patients, FilterOption filter) {
    List<Patient> sortedPatients = [...patients];
    switch (filter) {
      case FilterOption.alphabetical:
        sortedPatients.sort((a, b) => a.lastName.value.toLowerCase().compareTo(b.lastName.value.toLowerCase()));
        break;
      case FilterOption.dueDateDesc:
        sortedPatients.sort((a, b) => parseDate(b.dueDate.value).compareTo(parseDate(a.dueDate.value)));
        break;
      case FilterOption.dueDateAsc:
        sortedPatients.sort((a, b) => parseDate(a.dueDate.value).compareTo(parseDate(b.dueDate.value)));
        break;
    }
    return sortedPatients;
  }

  List<Patient> _getFilteredPatients(List<Patient> patients, String query) {
    if (query.isEmpty) {
      return patients;
    }
    final lowerQuery = query.toLowerCase();
    return patients.where((patient) {
      final nameMatch = patient.firstName.value.toLowerCase().contains(lowerQuery) ||
          patient.lastName.value.toLowerCase().contains(lowerQuery);
      final rutMatch = patient.rut.value.toLowerCase().contains(lowerQuery);
      final emailMatch = patient.email.value.toLowerCase().contains(lowerQuery);
      final fullNameMatch = '${patient.firstName.value} ${patient.lastName.value}'.toLowerCase().contains(lowerQuery);
      return nameMatch || rutMatch || emailMatch || fullNameMatch;
    }).toList();
  }

  List<Patient> _getDoubleSortedPatients(List<Patient> patients, UpperFilterOption filter) {
    List<Patient> sortedPatients = [...patients]; // Copia de la lista original

    switch (filter) {
      case UpperFilterOption.seeAll:
        return sortedPatients; // Devuelve todos los pacientes

      case UpperFilterOption.postpartum:
        return sortedPatients.where((patient) => patient.category == 'Postparto').toList();

      case UpperFilterOption.pastDue:
        return sortedPatients.where((patient) => patient.category == 'Past Due').toList();

      case UpperFilterOption.lessThan14:
        return sortedPatients.where((patient) => patient.category == '≤ 14 dias').toList();

      case UpperFilterOption.lessThan30:
        return sortedPatients.where((patient) => patient.category == '≤ 30 dias').toList();

      case UpperFilterOption.moreThan30:
        return sortedPatients.where((patient) => patient.category == '+ 30 dias').toList();

      default:
        return sortedPatients; // Caso por defecto en caso de que no se reconozca el filtro
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsProvider);
    final filter = ref.watch(filterProvider);
    final upperFilter = widget.selectedFilter; // Utiliza el filtro seleccionado pasado como parámetro

    final sortedPatients = _getSortedPatients(productsState.products, filter);
    final doubleSortedPatients = _getDoubleSortedPatients(sortedPatients, upperFilter);
    final filteredPatients = _getFilteredPatients(doubleSortedPatients, widget.searchQuery);

    return ListView.builder(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      itemCount: filteredPatients.length,
      itemBuilder: (context, index) {
        final patient = filteredPatients[index];
        return Column(
          children: [
            GestureDetector(
              onTap: () => context.push('/patient/${patient.email.value}'),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0), // Ajusta el valor según sea necesario
                child: PatientCard(patient: patient, isAdmin: widget.isAdmin), // Pass isAdmin here
              ),
            ),
            const Divider(), // Divider to separate each ProductCard
          ],
        );
      },
    );
  }
}

// class PatientCard extends StatelessWidget {
//   final Patient patient;
//   final bool isAdmin;

//   const PatientCard({
//     Key? key,
//     required this.patient,
//     required this.isAdmin,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: ListTile(
//         title: Text('${patient.firstName.value} ${patient.lastName.value}'),
//         subtitle: Text('Email: ${patient.email.value}'),
//         trailing: isAdmin
//             ? IconButton(
//                 icon: const Icon(Icons.edit),
//                 onPressed: () {
//                   // Implement your edit functionality here
//                 },
//               )
//             : null,
//       ),
//     );
//   }
// }
