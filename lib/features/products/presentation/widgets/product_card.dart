import 'package:flutter/material.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';

class PatientCard extends StatelessWidget {

  final Patient patient;
  final bool isAdmin;
  const PatientCard({
    super.key, 
    required this.patient,
    required this.isAdmin,
  });

  static Map<String, String> pregnancyImages = {
    'still_pregnant': 'assets/images/pregnant-tribu.png',
    'born': 'assets/images/baby-tribu.png',
  };

  String _getPregnancyStageImage() {
    if (patient.babyIsBorn != false) {
      return pregnancyImages['born']!;
    } else {
      return pregnancyImages['still_pregnant']!;
    }
  }

  Color _getPregnancyStageColor() {
    if (patient.babyIsBorn != false) {
      return const Color.fromARGB(255, 89, 89, 89); // Color para postparto
    } else {
      int totalWeeks = patient.pregnancyWeek;
      List<String> dateParts = patient.dueDate.value.split('-');
      if (dateParts.length == 3) {
        int year = 0;
        int month = 0;
        int day = 0;
        if (isAdmin) {
          year = int.parse(dateParts[0]);
          month = int.parse(dateParts[1]);
          day = int.parse(dateParts[2]);
        } else {
          year = int.parse(dateParts[0]);
          month = int.parse(dateParts[1]);
          day = int.parse(dateParts[2]);
        }

        DateTime now = DateTime.now();
        DateTime dueDate = DateTime(year, month, day);
        Duration difference = dueDate.difference(now);

        int remainingDays = difference.inDays;

        if (totalWeeks >= 40) {
          return const Color.fromARGB(255, 245, 176, 155); // Más de 40 semanas (ya pasó la fecha de parto)
        } else if (remainingDays <= 14) {
          return const Color.fromARGB(255, 29, 138, 146); // Menos de 14 días
        } else if (remainingDays <= 30) {
          return const Color.fromARGB(255, 233, 162, 0); // Menos de 30 días pero más de 14 días
        } else {
          return const Color.fromARGB(255, 65, 201, 255); // Más de 30 días
        }
      }
      return Colors.black; // Color por defecto en caso de error
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ImageViewer(images: [_getPregnancyStageImage()], 
        borderColor: _getPregnancyStageColor()),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${patient.firstName.value.toString()} ${patient.lastName.value.toString()}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 89, 89, 89)),
              ),
              const SizedBox(height: 5),
              RichText(
                text: TextSpan(
                  children: [
                     TextSpan(
                      text: patient.babyIsBorn != false ? 'Fecha de nacimiento: ' : 'Fecha probable de parto: ',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    TextSpan(
                      text: patient.babyIsBorn != false ? patient.bornDate!.value : patient.dueDate.value,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              //const SizedBox(height: 5),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: patient.babyIsBorn != false ? 'Edad bebé: ' : 'Edad Gestacional: ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _getPregnancyStageColor(),
                    ),
                    ),
                    TextSpan(
                      text: (patient.babyIsBorn != false)
                        ? (() {
                            // Comprueba si bornDate es nulo
                            if (patient.bornDate != null) {
                              // Divide la fecha de nacimiento en partes
                              List<String> bornDateParts = patient.bornDate!.value.split('-');
                              if (bornDateParts.length == 3) {
                                int bornYear = 0;
                                int bornMonth = 0;
                                int bornDay = 0;
                                if (isAdmin){
                                  bornYear = int.parse(bornDateParts[2]);
                                  bornMonth = int.parse(bornDateParts[1]);
                                  bornDay = int.parse(bornDateParts[0]);
                                } else {
                                  bornYear = int.parse(bornDateParts[0]);
                                  bornMonth = int.parse(bornDateParts[1]);
                                  bornDay = int.parse(bornDateParts[2]);
                                }

                                // Calcula la diferencia entre la fecha actual y la fecha de nacimiento
                                DateTime now = DateTime.now();
                                DateTime bornDate = DateTime(bornYear, bornMonth, bornDay);
                                Duration difference = now.difference(bornDate);

                                // Convierte la diferencia en semanas y días
                                int weeks = difference.inDays ~/ 7;
                                int days = difference.inDays % 7;

                                // Devuelve el texto formateado para el tiempo POSTPARTO
                                return '${weeks}s, ${days}d';
                              }
                              return 'Fecha inválida';
                            }
                            return 'Fecha de nacimiento no disponible';
                          })()
                        : (() {
                            int weeks = patient.pregnancyWeek;
                            int days = patient.pregnancyWeekDay;
                            return '${weeks}s, ${days}d';
                          })(),

                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: (() {
                          if (patient.babyIsBorn != false) {
                            // Condición para el postparto
                            return const Color.fromARGB(255, 89, 89, 89);
                          } else {
                            return _getPregnancyStageColor();
                          }
                        })(),
                      ),
                    )]
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}


class _ImageViewer extends StatelessWidget {
  final List<String> images;
  final Color borderColor;
  const _ImageViewer({ required this.images, required this.borderColor });

  @override
  Widget build(BuildContext context) {
    
    if ( images.isEmpty ) {
      return _buildImageWidget(
        child: Image.asset('assets/images/no-image.jpg', 
          fit: BoxFit.contain,
          height: 250,
          width: 250, // Making width and height equal for perfect circle
        ),
        borderColor: borderColor,
      );
    }

    return _buildImageWidget(
      child: FadeInImage(
        fit: BoxFit.contain,
        height: 80,
        width: 80, // Making width and height equal for perfect circle
        fadeOutDuration: const Duration(milliseconds: 100),
        fadeInDuration: const Duration(milliseconds: 200),
        image: AssetImage( images.first ),
        placeholder: const AssetImage('assets/loaders/bottle-loader.gif'),
      ),
      borderColor: borderColor,
    );

  }

  Widget _buildImageWidget({required Widget child, required Color borderColor}) {
    return Container(
      width: 80, // Making width and height equal for perfect circle
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor, // Color del borde basado en la etapa del embarazo
          width: 3.5,
        ),
      ),
      child: ClipOval(
        child: child,
      ),
    );
  }
}

