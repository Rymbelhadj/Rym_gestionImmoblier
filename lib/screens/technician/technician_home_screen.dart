import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/auth_provider.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/auth_provider.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/screens/technician/intervention_report_screen.dart';

class TechnicianHomeScreen extends StatefulWidget {
  const TechnicianHomeScreen({super.key});

  @override
  State<TechnicianHomeScreen> createState() => _TechnicianHomeScreenState();
}

class _TechnicianHomeScreenState extends State<TechnicianHomeScreen> {
  int _selectedIndex = 0;
  
  static final List<Widget> _screens = [
    const AssignedTasksScreen(),
    const CompletedTasksScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _signOut() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.signOut();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Espace Technicien'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Tâches assignées',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done_all),
            label: 'Tâches complétées',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class AssignedTasksScreen extends StatelessWidget {
  const AssignedTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tâches à effectuer',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 5, // Exemple avec 5 tâches
              itemBuilder: (context, index) {
                final urgency = index % 3 == 0
                    ? 'Haute'
                    : index % 3 == 1
                        ? 'Moyenne'
                        : 'Basse';
                final urgencyColor = index % 3 == 0
                    ? Colors.red
                    : index % 3 == 1
                        ? Colors.orange
                        : Colors.green;
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Icon(
                      index % 3 == 0 ? Icons.elevator : index % 3 == 1 ? Icons.stairs : Icons.pool,
                      color: Colors.blue,
                    ),
                    title: Text('Intervention #${index + 1}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Signalé le ${DateTime.now().subtract(Duration(days: index)).day}/'
                          '${DateTime.now().subtract(Duration(days: index)).month}/'
                          '${DateTime.now().subtract(Duration(days: index)).year}',
                        ),
                        const SizedBox(height: 4),
                        Text('Adresse: 123 Rue de l\'immeuble, 75000 Paris'),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Chip(
                          label: Text(
                            'Priorité: $urgency',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          backgroundColor: urgencyColor,
                        ),
                      ],
                    ),
                    isThreeLine: true,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => InterventionReportScreen(taskId: 'task-$index'),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CompletedTasksScreen extends StatelessWidget {
  const CompletedTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Interventions terminées',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 3, // Exemple avec 3 tâches complétées
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                    title: Text('Intervention #${index + 100}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Terminée le ${DateTime.now().subtract(Duration(days: index)).day}/'
                          '${DateTime.now().subtract(Duration(days: index)).month}/'
                          '${DateTime.now().subtract(Duration(days: index)).year}',
                        ),
                        const SizedBox(height: 4),
                        const Text('Durée: 1h30'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.visibility),
                      onPressed: () {
                        // Voir le rapport d'intervention
                      },
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

