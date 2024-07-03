import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:teslo_shop/features/products/domain/domain.dart';
// import 'package:teslo_shop/features/products/domain/entities/product.dart';
import 'package:teslo_shop/features/products/presentation/providers/providers.dart';
import 'package:teslo_shop/features/products/presentation/widgets/patient_card_info.dart';
// import 'package:teslo_shop/features/products/presentation/widgets/widgets.dart';
import 'package:teslo_shop/features/shared/shared.dart';
//import 'package:http/http.dart' as http;
//import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

class PatientScreen extends ConsumerWidget {
  final Email patientEmail;
  final bool isAdmin;

  const PatientScreen({super.key, required this.patientEmail, required this.isAdmin});


  // void showSnackbar(BuildContext context) {
  //   ScaffoldMessenger.of(context).clearSnackBars();
  //   ScaffoldMessenger.of(context)
  //       .showSnackBar(const SnackBar(content: Text('Producto Actualizado')));
  // }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientState = ref.watch(patientProvider(patientEmail));

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Información Paciente'),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color.fromARGB(255, 29, 138, 146),
        ),
        body: patientState.isLoading
            ? const FullScreenLoader()
            : ListView(
                children: [
                  const SizedBox(height: 10),
                  _PacientInformation(patient: patientState.patient!, isAdmin: isAdmin),
                ],
              ),
      ),
    );
  }
}

class _PacientInformation extends ConsumerWidget {
  final Patient patient;
  final bool isAdmin;

  const _PacientInformation({required this.patient, required this.isAdmin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),

          // Paciente

          Padding(
            padding: const EdgeInsets.all(16),
            child: PatientCardInfo(
                // image: productForm.images,
                name: patient.firstName,
                lastname: patient.lastName,
                email: patient.email,
                phone: patient.phone),
          ),
          // Información Paciente

          const Text(
            'Información del embarazo',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),

          const SizedBox(height: 15),

          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: PillInformation(
                          '${patient.pregnancyWeek}s y ${patient.pregnancyWeekDay}d',
                          // patient.pregnancyWeek == 1
                          //     ? patient.pregnancyWeekDay == 1
                          //         ? '${patient.pregnancyWeek} semana ${patient.pregnancyWeekDay} día'
                          //         : '${patient.pregnancyWeek} semana ${patient.pregnancyWeekDay} días'
                          //     : patient.pregnancyWeekDay == 1
                          //         ? '${patient.pregnancyWeek} semanas ${patient.pregnancyWeekDay} día'
                          //         : '${patient.pregnancyWeek} semanas ${patient.pregnancyWeekDay} días',
                          'Edad gestacional',
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: PillInformation(DateFormat('dd/MM/yyyy').format(DateTime.parse(patient.dueDate.value)), 'Fecha de parto'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: PillInformation(DateFormat('dd/MM/yyyy').format(DateTime.parse(patient.lastPeriodDate.value)), 'Fecha último periodo'),
                      ),
                    ),
                    if (patient.babyIsBorn == true)
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: PillInformation(babyAge(patient), 'Edad del bebé'),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          if (patient.babyIsBorn == true) ...[
            BabyInformationCard(title: 'Información del bebé',
              babyName: patient.babyName!,
              bornDate: patient.bornDate!.value),
            const SizedBox(height: 30),
          ],

          PersonalInformationCard(
            title: 'Información Personal',
            height: patient.height,
            communeLiving: patient.comuneLiving,
            rut: patient.rut,
            planType: isAdmin ? patient.planType : null,
            healthInsurance: patient.healthInsurance,
            subscriptionDate: patient.subscriptionDate,
            group: isAdmin ? patient.group : null,
            address: isAdmin ? patient.address : null,
            region: isAdmin ? patient.region : null,
            province: isAdmin ? patient.province : null,
            midwife: isAdmin? patient.midwife : null,
            isAdmin: isAdmin,
          ),

          const SizedBox(height: 30),

          TratantesCard(
            title: 'Tratantes Actuales',
            // tratantesNames: productForm.sizes,
            tratantesNames: patient.medicalStaff,
            // midwife: isAdmin ? patient.midwife : null,
          ),
          const SizedBox(height: 30),

          PartnerInformationCard(
            title: 'Información de Acompañante',
            partnerFirstName: patient.partnerFirstName.value,
            partnerLastName: patient.partnerLastName.value,
            partnerPhone: patient.partnerPhone.value,
          ),
          const SizedBox(height: 30),

          const Text(
            'Historial de la paciente: acceso a documentos',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: () async {
              await _downloadMyprogressPdf(context, ref, patient.email);
            },
            child: const TestCard(
              title: 'Checklist del embarazo',
              subtitle: 'Progreso y fechas más importantes',
              progress: 100,
              completed: true,
              barColor: Color(0xFFEE99AA),
            ),
          ),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: () async {
              await _downloadEdinnburgPdf(context, ref, patient.email);
            },
            child: const TestCard(
              title: 'Tests de Edimburgo',
              subtitle: 'Acceder al historial',
              progress: 100,
              completed: false,
              barColor: Color(0xFF5DB6D2),
            ),
          ),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: () async {
              await _downloadWeightTrackerPdf(context, ref, patient.email);
            },
            child: const TestCard(
              title: 'Seguimiento de peso',
              subtitle: 'De la paciente',
              progress:  100,
              completed: false,
              barColor: Color(0xFFE9A200),
            ),
          ),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: () => context.push('/'),
            child: const TestCard(
              title: 'Seguimiento de peso',
              subtitle: 'Del bebé',
              progress: 100,
              completed: true,
              barColor: Color(0xFF359D9E),
            ),
          ),
          const SizedBox(height: 15),

          // Acciones Adicionales

          const Text(
            'Acciones adicionales',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 15),
          Center(
            child: MyFlatButton(
              icon: Icons.account_circle_outlined,
              label: 'Editar información',
              onPressed: () async {
                final result = await context.push<bool>('/patient_edit/${patient.email.value}');
                if (result == true) {
                  // Recargar los datos del paciente si la edición fue exitosa
                  ref.read(patientProvider(patient.email).notifier).loadPatient();
                }
              },
            ),
          ),
          const Divider(),
          Center(
            child: MyFlatButton(
              icon: Icons.remove_circle_outline,
              label: 'Desvincular paciente',
              onPressed: () {
                showConfirmation(context, ref, patient);
              },
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Future<void> _downloadMyprogressPdf(BuildContext context, WidgetRef ref, Email email) async {
    // Check and request permissions
    print("Requesting permissions...");
    PermissionStatus status = await Permission.storage.request();
    print("Permission status: $status");

    if (status.isGranted) {
      try {
        final repository = ref.read(productsRepositoryProvider);
        final pdfData = await repository.getMyProgressPDF(email);

        // Get the downloads directory
        final downloadsDir = Directory('/storage/emulated/0/Download'); 

        // Check if the directory exists, if not create it
        if (!await downloadsDir.exists()) {
          await downloadsDir.create(recursive: true);
        }

        final file = File('${downloadsDir.path}/my_progress.pdf');
        await file.writeAsBytes(pdfData.codeUnits);  // Use codeUnits to get the byte data

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF descargado exitosamente en el directorio de descargas!')),
        );

        // Open the file
        final result = await OpenFile.open(file.path);
        print(result.message); // Check the result of the open file action
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se puede generar el documento puesto que la paciente aún no ha ingresado su estado pre-gestacional (peso y altura pre-embarazo).')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permiso denegado para acceder al almacenamiento')),
      );
    }
  }

  Future<void> _downloadWeightTrackerPdf(BuildContext context, WidgetRef ref, Email email) async {
    // Check and request permissions
    print("Requesting permissions...");
    PermissionStatus status = await Permission.storage.request();
    print("Permission status: $status");

    if (status.isGranted) {
      try {
        final repository = ref.read(productsRepositoryProvider);
        final pdfData = await repository.getPatientWeightTrackerPDF(email);

        // Get the downloads directory
        final downloadsDir = Directory('/storage/emulated/0/Download'); 

        // Check if the directory exists, if not create it
        if (!await downloadsDir.exists()) {
          await downloadsDir.create(recursive: true);
        }

        final file = File('${downloadsDir.path}/weight_tracker.pdf');
        await file.writeAsBytes(pdfData.codeUnits);  // Use codeUnits to get the byte data

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF descargado exitosamente en el directorio de descargas!')),
        );

        // Open the file
        final result = await OpenFile.open(file.path);
        print(result.message); // Check the result of the open file action
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se puede generar el documento puesto que la paciente aún no ha ingresado su estado pre-gestacional (peso y altura pre-embarazo).')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permiso denegado para acceder al almacenamiento')),
      );
    }
  }



  Future<void> _downloadEdinnburgPdf(BuildContext context, WidgetRef ref, Email email) async {
    // Check and request permissions
    print("Requesting permissions...");
    PermissionStatus status = await Permission.storage.request();
    print("Permission status: $status");

    if (status.isGranted) {
      try {
        final repository = ref.read(productsRepositoryProvider);
        final pdfData = await repository.getEdimburghTestPDF(email);
        
        // Get the downloads directory
        final downloadsDir = Directory('/storage/emulated/0/Download'); 
        
        // Check if the directory exists, if not create it
        if (!await downloadsDir.exists()) {
          await downloadsDir.create(recursive: true);
        }

        final file = File('${downloadsDir.path}/edinburgh_test.pdf');
        await file.writeAsBytes(pdfData.codeUnits);  // Use codeUnits to get the byte data
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF descargado exitosamente en el directorio de descargas!')),
        );

        // Open the file
        final result = await OpenFile.open(file.path);
        print(result.message); // Check the result of the open file action
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se puede generar el documento puesto que la paciente aún no ha completado ningún Test de Edimburgo')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permiso denegado para acceder al almacenamiento')),
      );
    }
  }
  void showConfirmation(BuildContext context, WidgetRef ref, Patient patient) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Desvincular paciente'),
          content: Text('¿Está seguro que desea desvincular a ${patient.firstName.value} ${patient.lastName.value}?'),
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
                  final repository = ref.read(productsRepositoryProvider);
                  await repository.unlinkPatient(patient.email);
                  success = true;
                } catch (e) {
                  success = false;
                }
                if (success) {
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(content: Text('Paciente desvinculado exitosamente')),
                  );
                  await ref.read(productsProvider.notifier).refreshPatients();
                  navigator.pop();
                } else {
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(content: Text('Error al desvincular mi paciente')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  String babyAge(Patient patient){
    List<String> bornDateParts = patient.bornDate!.value.split('-');
    int bornYear = 0;
    int bornMonth = 0;
    int bornDay = 0;
    bornYear = int.parse(bornDateParts[0]);
    bornMonth = int.parse(bornDateParts[1]);
    bornDay = int.parse(bornDateParts[2]);

    DateTime now = DateTime.now();
    DateTime bornDate = DateTime(bornYear, bornMonth, bornDay);
    Duration difference = now.difference(bornDate);

    int weeks = difference.inDays ~/ 7;
    int days = difference.inDays % 7;

    return '${weeks}s, ${days}d';
  }
}
