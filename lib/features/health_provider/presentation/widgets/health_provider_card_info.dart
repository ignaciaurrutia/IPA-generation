import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/health_provider/domain/repositories/health_providers_repository.dart';
import 'package:teslo_shop/features/health_provider/presentation/providers/health_providers_repository_provider.dart';
import 'package:teslo_shop/features/health_provider/presentation/widgets/patients_list_popup.dart';
import 'package:teslo_shop/features/products/presentation/providers/providers.dart';

class PatientCard extends ConsumerStatefulWidget {
  final String title;
  final List<Map<String, dynamic>> pacientesNames;
  final String hpEmail;
  final bool isAdmin;

  const PatientCard({
    super.key,
    required this.title,
    required this.pacientesNames,
    required this.hpEmail,
    required this.isAdmin,
  });

  @override
  _PatientCardState createState() => _PatientCardState();
}

class _PatientCardState extends ConsumerState<PatientCard> {
  bool _showEditMode = false;

  void showConfirmation(
      BuildContext context,
      HealthProvidersRepository repository,
      Map<String, dynamic> patient,
      String hpEmail,
      String operation,
      bool isAdmin) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text((operation == 'unlink')
              ? 'Desvincular paciente'
              : 'Vincular paciente'),
          content: Text((operation == 'unlink')
              ? '¿Está seguro que desea desvincular a ${patient['first_name']} ${patient['last_name']} de este tratante?'
              : '¿Está seguro que desea vincular a ${patient['first_name']} ${patient['last_name']} a este tratante?'),
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
                  await repository.unlinkPatientHealthProvider(
                      patient['email'], hpEmail, operation, isAdmin);
                  success = true;
                } catch (e) {
                  success = false;
                }
                if (success) {
                  await ref.read(productsProvider.notifier).refreshPatients();
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                        content: Text((operation == 'unlink')
                            ? 'Paciente desvinculada exitosamente'
                            : 'Paciente vinculada exitosamente')),
                  );
                  if (operation == 'unlink') {
                    setState(() {
                      widget.pacientesNames.removeWhere(
                          (element) => element['email'] == patient['email']);
                    });
                  } else {
                    setState(() {
                      widget.pacientesNames.add(patient);
                    });
                  }
                  
                } else {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                        content: Text((operation == 'unlink')
                            ? 'Error al desvincular paciente'
                            : 'Error al vincular paciente')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.read(healthProvidersRepositoryProvider);
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
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF359D9E),
                ),
              ),
              Row(children: [
                const Text(
                  'Editar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF359D9E),
                  ),
                ),
                const SizedBox(width: 10),
                Switch(
                  value: _showEditMode,
                  onChanged: (value) {
                    setState(() {
                      _showEditMode = value;
                    });
                  },
                  activeColor: const Color(0xFF359D9E),
                ),
              ])
            ]),
            const SizedBox(height: 15),
            widget.pacientesNames.isEmpty
                ? (!_showEditMode)
                    ? const Center(
                    child: Text(
                      'No tiene pacientes asociados',
                      style: TextStyle(fontSize: 16, color: Color(0xFF7F7F7F)),
                    ),
                      )
                    : GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            enableDrag: true,
                            builder: (context) => SizedBox(
                              child: PatientBottomSheet(
                                  healthProviderEmail: widget.hpEmail,
                                  showConfirmation: showConfirmation),
                            ),
                            showDragHandle: true,
                            backgroundColor: Colors.white,
                          );
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey.shade500,
                              child: const Icon(
                                Icons.person_add_sharp,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Añadir paciente',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _showEditMode
                        ? widget.pacientesNames.length + 1
                        : widget.pacientesNames.length,
                    itemBuilder: (context, index) {
                      if (_showEditMode &&
                          index == widget.pacientesNames.length) {
                        return GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              enableDrag: true,
                              builder: (context) => SizedBox(
                                child: PatientBottomSheet(
                                    healthProviderEmail: widget.hpEmail,
                                    showConfirmation: showConfirmation),
                              ),
                              showDragHandle: true,
                              backgroundColor: Colors.white,
                            );
                          },
                          child: 
                          (widget.isAdmin) ? 
                            Column(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors
                                      .grey.shade500,
                                  child: const Icon(
                                    Icons.person_add_sharp,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'Añadir paciente',
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ) : null
                        );
                      } else {
                      return Column(
                        children: [
                          Stack(children: [
                            const CircleAvatar(
                              radius: 30,
                              backgroundColor: Color(0xFFBFBFBF),
                              backgroundImage:
                                  AssetImage('assets/images/miTribu.png'),
                            ),
                            if (_showEditMode)
                              Positioned(
                                  top: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                        showConfirmation(
                                            context,
                                            repository,
                                            widget.pacientesNames[index],
                                            widget.hpEmail,
                                            'unlink',
                                            widget.isAdmin);
                                    },
                                    child: const CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.red,
                                      child: Icon(
                                        Icons.remove,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    ),
                                  ),
                              ],
                            ),
                          const SizedBox(height: 5),
                          Text(
                            '${widget.pacientesNames[index]['first_name']} ${widget.pacientesNames[index]['last_name']}',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.visible,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      );
                      }
                    },
                  ),
          ],
        ),
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
    // final isAdmin = ref.watch(authProvider).user?.isAdmin ?? false;

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
