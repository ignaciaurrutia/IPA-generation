import 'package:flutter/material.dart';
import 'package:teslo_shop/features/health_provider/domain/domain.dart';

class HealthProviderCard extends StatelessWidget {
  final HealthProvider healthProvider;

  const HealthProviderCard({super.key, required this.healthProvider});

  // Imagen del Tratante

  static Map<String, String> healthProviderImages = {
    'Active': 'assets/images/tratante.jpg',
    'Inactive': 'assets/images/no-image.jpg',
  };

  String _getHealthProviderImage() {
    if (healthProvider.status != 'Active') {
      return healthProviderImages['Active']!;
    } else {
      return healthProviderImages['Inactive']!;
    }
  }

  Color _getHealthProviderColor() {
    if (healthProvider.occupation == 'Pediatra') {
      return const Color.fromARGB(255, 29, 138, 146); // Color para los activos
    } else if (healthProvider.occupation == 'Matron/a') {
      return const Color.fromARGB(255, 245, 176, 155); // Color para los activos
    } else if (healthProvider.occupation == 'Psicólogo/a') {
      return const Color.fromARGB(255, 233, 162, 0); // Color para los activos
    } else if (healthProvider.occupation == 'Gineco-obstetra') {
      return const Color.fromARGB(255, 65, 201, 255); // Color para los activos
    } else {
      return const Color.fromARGB(255, 89, 89, 89); // Color para los inactivos
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ImageViewer(
          images: [_getHealthProviderImage()],
          borderColor: _getHealthProviderColor(),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${healthProvider.firstName} ${healthProvider.lastName}',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 89, 89, 89)),
              ),
              const SizedBox(height: 5),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Rut: ',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    TextSpan(
                      text: healthProvider.rut,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Ocupación: ${healthProvider.occupation}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: (() {
                          if (healthProvider.occupation == 'Matron/a') {
                            return const Color.fromARGB(255, 245, 176, 155);
                          } else if (healthProvider.occupation ==
                              'Pediatra') {
                            return const Color.fromARGB(255, 29, 138, 146);
                          } else if (healthProvider.occupation ==
                              'Psicólogo/a') {
                            return const Color.fromARGB(255, 233, 162, 0);
                          } else if (healthProvider.occupation ==
                              'Gineco-obstetra') {
                            return const Color.fromARGB(255, 65, 201, 255);
                          } else {
                            return const Color.fromARGB(255, 89, 89, 89);
                          } // Color por defecto en caso de error
                        })(),
                      ),
                    )
                  ],
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
  const _ImageViewer({required this.images, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return _buildImageWidget(
        child: Image.asset(
          'assets/images/no-image.jpg',
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
        image: AssetImage(images.first),
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
