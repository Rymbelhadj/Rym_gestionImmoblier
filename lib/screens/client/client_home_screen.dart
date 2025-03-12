import 'package:flutter/material.dart';
import 'package:flutter_application_1/database/database_helper.dart';
import 'package:flutter_application_1/models/probleme.dart';
import 'package:flutter_application_1/providers/auth_provider.dart';
import 'package:flutter_application_1/screens/client/problem_form_screen.dart';
import 'package:flutter_application_1/screens/contrat_screen.dart';
import 'package:flutter_application_1/screens/facility_screen.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:provider/provider.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({super.key});

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  int _selectedIndex = 0;
  
  static final List<Widget> _screens = [
    const ProblemHomeScreen(),
    const ContractScreen(),
    const FacilityScreen(),
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
        title: const Text('Espace Client'),
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
            icon: Icon(Icons.report_problem),
            label: 'Problèmes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Contrats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apartment),
            label: 'Installations',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ProblemFormScreen(),
                  ),
                );
              },
            )
          : null,
    );
  }
}

class ProblemHomeScreen extends StatefulWidget {
  const ProblemHomeScreen({super.key});

  @override
  State<ProblemHomeScreen> createState() => _ProblemHomeScreenState();
}

class _ProblemHomeScreenState extends State<ProblemHomeScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Problem> _problems = [];
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadProblems();
  }
  
  Future<void> _loadProblems() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user != null) {
      setState(() {
        _isLoading = true;
      });
      
      final problems = await _dbHelper.getProblemsForUser(authProvider.user!.id!);
      
      setState(() {
        _problems = problems;
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadProblems,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mes problèmes signalés',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _problems.isEmpty
                      ? Center(
                          child: Text(
                            'Aucun problème signalé',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _problems.length,
                          itemBuilder: (context, index) {
                            final problem = _problems[index];
                            final statusColor = problem.status == 'En attente'
                                ? Colors.orange
                                : problem.status == 'En cours'
                                    ? Colors.blue
                                    : Colors.green;
                            
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                leading: Icon(
                                  _getFacilityIcon(problem.facilityType),
                                  color: Colors.blue,
                                ),
                                title: Text(problem.title),
                                subtitle: Text(
                                  'Signalé le ${problem.createdAt.day}/'
                                  '${problem.createdAt.month}/'
                                  '${problem.createdAt.year}',
                                ),
                                trailing: Chip(
                                  label: Text(
                                    problem.status,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                  backgroundColor: statusColor,
                                ),
                                onTap: () {
                                  // Naviguer vers les détails du problème
                                },
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
  
  IconData _getFacilityIcon(String facilityType) {
    switch (facilityType) {
      case 'Ascenseur':
        return Icons.elevator;
      case 'Escalier':
        return Icons.stairs;
      case 'Piscine':
        return Icons.pool;
      case 'Parking sous-sol':
        return Icons.local_parking;
      case 'Porte Générale':
        return Icons.door_front_door;
      default:
        return Icons.apartment;
    }
  }
}

