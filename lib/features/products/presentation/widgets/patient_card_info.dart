import 'package:flutter/material.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/inputs.dart';
import 'package:teslo_shop/features/shared/shared.dart';
import 'package:intl/intl.dart';

class PatientCardInfo extends StatelessWidget {
  // final List<String> image;
  final FirstName name;
  final LastName lastname;
  final Email email;
  final Phone phone;

  const PatientCardInfo(
      {super.key, 
      // required this.image, 
      required this.name, required this.lastname, required this.email, required this.phone});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // _PatientImageViewer(images: image),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${name.value.toString()} ${lastname.value.toString()}',
                style:
                    const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: email.value.toString(),
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF595959)),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '+${phone.value.toString()}',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF595959)),
                    ),
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

class _PatientImageViewer extends StatelessWidget {
  final List<String> images;

  const _PatientImageViewer({required this.images});

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return _buildImageWidget(
        child: Image.asset(
          'assets/images/no-image.jpg',
          fit: BoxFit.cover,
          height: 100,
          width: 100,
        ),
      );
    }

    return _buildImageWidget(
      child: FadeInImage(
        fit: BoxFit.cover,
        height: 100,
        width: 100,
        fadeOutDuration: const Duration(milliseconds: 100),
        fadeInDuration: const Duration(milliseconds: 200),
        image: NetworkImage(images.first),
        placeholder: const AssetImage('assets/loaders/bottle-loader.gif'),
      ),
    );
  }

  Widget _buildImageWidget({required Widget child}) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF359D9E),
          width: 4,
        ),
      ),
      child: ClipOval(
        child: child,
      ),
    );
  }
}

class PillInformation extends StatelessWidget {
  final String info;
  final String title;

  const PillInformation(this.info, this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: const Color(0xFF359D9E), width: 2.0),
            color: Colors.white.withOpacity(0),
          ),
          child: info == ''
              ? const Icon(
                  Icons.assessment_rounded,
                  color: Color(0xFF359D9E),
                )
              : Text(
                  info,
                  style: const TextStyle(
                      color: Color(0xFF359D9E), fontWeight: FontWeight.bold),
                ),
        ),
        const SizedBox(height: 5.0),
        Text(title, style: const TextStyle(fontWeight: FontWeight.normal)),
      ],
    );
  }
}


class TratantesCard extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> tratantesNames;

  const TratantesCard({
    super.key,
    required this.title,
    required this.tratantesNames,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double itemWidth = 100;
        final crossAxisCount = (constraints.maxWidth / itemWidth).floor(); 
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 2, color: const Color(0xFF359D9E)),
            color: Colors.white.withOpacity(0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF359D9E),
                  ),
                ),
                const SizedBox(height: 8),
                tratantesNames.isEmpty
                  ? const Center(
                      child: Text(
                        'No tiene tratantes asociados',
                        style: TextStyle(fontSize: 16, color: Color(0xFF7F7F7F)),
                      ),
                    )
                  : GridView.count(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(tratantesNames.length, (index) {
                        return Column(
                          children: [
                            const CircleAvatar(
                              radius: 30,
                              backgroundColor: Color(0xFFBFBFBF),
                              backgroundImage: AssetImage('assets/images/miTribu.png'),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${tratantesNames[index]['first_name']} ${tratantesNames[index]['last_name']}',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.visible,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        );
                      }
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}


class PersonalInformationCard extends StatelessWidget {
  final String title;
  final Height height;
  final String communeLiving;
  final Rut rut;
  final String? planType;
  final String healthInsurance;
  final String subscriptionDate;
  final String? group;
  final String? address;
  final String? region;
  final String? province;
  final bool isAdmin;
  final String? midwife;

  const PersonalInformationCard({
    super.key,
    required this.title,
    required this.height,
    required this.communeLiving,
    required this.rut,
    this.planType,
    required this.healthInsurance,
    required this.subscriptionDate,
    this.group,
    this.address,
    this.region,
    this.province,
    this.midwife,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = isAdmin
        ? communeLiving.isEmpty &&
            height.value.toString().isEmpty &&
            rut.value.isEmpty &&
            healthInsurance.isEmpty &&
            (planType?.isEmpty ?? true) &&
            (group?.isEmpty ?? true) &&
            (address?.isEmpty ?? true) &&
            (region?.isEmpty ?? true) &&
            (province?.isEmpty ?? true)
        : communeLiving.isEmpty &&
            height.value.toString().isEmpty &&
            rut.value.isEmpty &&
            healthInsurance.isEmpty;
        
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(width: 2, color: const Color(0xFF359D9E)),
        color: Colors.white.withOpacity(0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF359D9E),
              ),
            ),
            const SizedBox(height: 8),

            if (isEmpty)
              const Center(
                child: Text(
                  'No hay información personal disponible',
                  style: TextStyle(fontSize: 16, color: Color(0xFF7F7F7F)),
                ),
              )
            else ...[
              if (height.value.toString().isNotEmpty)
                _buildInfoRow(16.0, 'Altura:', '${height.value.toString()} cm'),
              if (rut.value.isNotEmpty && rut.validator(rut.value) != null)
                _buildInfoRow(16.0, 'Rut:', rut.value),
              if (midwife != null && midwife!.isNotEmpty)
                _buildInfoRow(16.0, 'Matrona:', midwife),
              if (communeLiving.isNotEmpty)
                _buildInfoRow(16.0, 'Comuna:', communeLiving),
              if (planType?.isNotEmpty ?? false) 
                _buildInfoRow(16.0, 'Tipo de plan:', planType),
              if (healthInsurance.isNotEmpty)
                _buildInfoRow(16.0, 'Seguro de salud:', healthInsurance),
              if (subscriptionDate.isNotEmpty) 
                _buildInfoRow(16.0, 'Fecha de suscripción en Mi Tribu:', DateFormat('dd/MM/yyyy').format(DateTime.parse(subscriptionDate))),
              if (group?.isNotEmpty ?? false) 
                _buildInfoRow(16.0, 'Grupo:', group),
              if (address?.isNotEmpty ?? false)
                _buildInfoRow(16.0, 'Dirección:', address!),
              if (region?.isNotEmpty ?? false)
                _buildInfoRow(16.0, 'Región:', region!),
              if (province?.isNotEmpty ?? false)
                _buildInfoRow(16.0, 'Provincia:', province!),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(double size, String label, [String? value]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Wrap(
        spacing: 10,
        runSpacing: 2,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: size),
          ),
          if (value != null) 
            Text(
              value,
              style: TextStyle(fontSize: size),
            ),
        ],
      ),
    );
  }
}

class BabyInformationCard extends StatelessWidget {
  final String title;
  final String babyName;
  final String bornDate;

  const BabyInformationCard({
    super.key,
    required this.title,
    required this.babyName,
    required this.bornDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(width: 2, color: const Color(0xFF359D9E)),
        color: Colors.white.withOpacity(0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF359D9E),
              ),
            ),
            const SizedBox(height: 8),
            if ((babyName.isEmpty) && (bornDate.isEmpty))
              const Center(
                child: Text(
                  'No se ha registrado información del bebé',
                  style: const TextStyle(fontSize: 16, color: Color(0xFF7F7F7F)),
                ),
              )
            else ...[
              if(babyName.isNotEmpty)
                _buildInfoRow(18.0, 'Nombre:', babyName),
              if (bornDate.isNotEmpty)
                const SizedBox(height: 2),
                _buildInfoRow(18.0, 'Fecha de nacimiento del bebé:', DateFormat('dd/MM/yyyy').format(DateTime.parse(bornDate))),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(double size, String label, [String? value]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Wrap(
        spacing: 10,
        runSpacing: 2,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: size),
          ),
          if (value != null) 
            Text(
              value,
              style: TextStyle(fontSize: size),
            ),
        ],
      ),
    );
  }
}

class PartnerInformationCard extends StatelessWidget {
  final String title;
  final String partnerFirstName;
  final String partnerLastName;
  final String partnerPhone;

  const PartnerInformationCard({
    super.key,
    required this.title,
    required this.partnerFirstName,
    required this.partnerLastName,
    required this.partnerPhone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(width: 2, color: const Color(0xFF359D9E)),
        color: Colors.white.withOpacity(0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF359D9E),
              ),
            ),
            const SizedBox(height: 8),
            if (partnerFirstName.isEmpty)
              const Center(
                child: Text(
                  'No hay acompañante asociado',
                  style: const TextStyle(fontSize: 16, color: Color(0xFF7F7F7F)),
                ),
              )
            else ...[
              _buildInfoRow(18.0, 'Nombre: $partnerFirstName $partnerLastName'),
              if (partnerPhone.isNotEmpty) ...[
                const SizedBox(height: 2),
                _buildInfoRow(16.0, 'Teléfono:', '+${partnerPhone}'),
              ]
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(double size, String label, [String? value]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Wrap(
        spacing: 10,
        runSpacing: 2,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: size),
          ),
          if (value != null) 
            Text(
              value,
              style: TextStyle(fontSize: size),
            ),
        ],
      ),
    );
  }
}

class MyFlatButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const MyFlatButton(
      {super.key,
      required this.icon,
      required this.label,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6.0),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF7F7F7F),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12.0),
              Text(label,
                  style: const TextStyle(
                      color: Color(0xFF7F7F7F), fontWeight: FontWeight.bold)),
            ],
          ),
          const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF7F7F7F)),
        ],
      ),
    );
  }
}

class TestCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progress;
  final bool completed;
  final Color barColor;

  const TestCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.completed,
    required this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 4,
        color: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 14, color: Color(0xFF7F7F7F)),
              ),
              // const SizedBox(height: 16),
              // Row(
              //   children: [
              //     completed
              //         ? const Icon(Icons.check_circle, color: Color(0xFF7F7F7F))
              //         : const Icon(Icons.radio_button_unchecked,
              //             color: Color(0xFF7F7F7F)),
              //     const SizedBox(width: 8),
              //     Text(
              //       completed ? 'Completado' : 'En progreso',
              //       style:
              //           const TextStyle(fontSize: 12, color: Color(0xFF7F7F7F)),
              //     ),
              //     const Spacer(),
              //     Text(
              //       'Etapa $progress% completada',
              //       style:
              //           const TextStyle(fontSize: 12, color: Color(0xFF7F7F7F)),
              //     ),
              //   ],
              // ),
              const SizedBox(
                height: 8,
              ),
              LinearProgressIndicator(
                minHeight: 8,
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                value: progress / 100, // Assuming progress is between 0 and 100
                backgroundColor: Colors.grey[300],
                color: barColor,
              ),
            ],
          ),
        ));
  }
}
