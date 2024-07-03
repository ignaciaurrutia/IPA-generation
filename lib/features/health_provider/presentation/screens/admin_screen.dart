import 'package:flutter/material.dart';
import 'package:teslo_shop/features/health_provider/presentation/screens/health_providers_screen.dart';
import 'package:teslo_shop/features/products/presentation/screens/products_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Admin Panel'),
      //   centerTitle: true,
      // ),
      body: _selectedIndex == 0
          ? const PatientsScreen(isAdmin: true)
          : const HealthProvidersScreen(),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color.fromARGB(255, 29, 138, 146),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.pregnant_woman),
            label: 'Pacientes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            label: 'Tratantes',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
