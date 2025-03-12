import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/auth_provider.dart';

class FacilityScreen extends StatefulWidget {
  const FacilityScreen({super.key});

  @override
  State<FacilityScreen> createState() => _FacilityScreenState();
}

class _FacilityScreenState extends State<FacilityScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _facilities = [];
  String _selectedCategory = 'Tous';
  final List<String> _categories = ['Tous', 'Ascenseur', 'Escalier', 'Piscine', 'Parking', 'Porte'];

  @override
  void initState() {
    super.initState();
    _loadFacilities();
  }

  Future<void> _loadFacilities() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    final facilities = [
      {
        'id': 1,
        'name': 'Ascenseur Principal',
        'category': 'Ascenseur',
        'location': 'Hall d\'entrée',
        'status': 'Opérationnel',
        'last_maintenance': DateTime(2023, 11, 15),
        'next_maintenance': DateTime(2024, 2, 15),
        'description': 'Ascenseur principal desservant tous les étages',
        'image': 'assets/images/elevator.jpg',
      },
      {
        'id': 2,
        'name': 'Piscine Extérieure',
        'category': 'Piscine',
        'location': 'Jardin arrière',
        'status': 'Fermée (Hiver)',
        'last_maintenance': DateTime(2023, 9, 30),
        'next_maintenance': DateTime(2024, 4, 15),
        'description': 'Piscine extérieure ouverte de mai à septembre',
        'image': 'assets/images/pool.jpg',
      },
    ];

    setState(() {
      _facilities = facilities;
      _isLoading = false;
    });
  }

  List<Map<String, dynamic>> get _filteredFacilities {
    if (_selectedCategory == 'Tous') {
      return _facilities;
    } else {
      return _facilities.where((facility) => facility['category'] == _selectedCategory).toList();
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Opérationnel':
        return Colors.green;
      case 'En maintenance':
        return Colors.orange;
      case 'Hors service':
        return Colors.red;
      case 'Fermée (Hiver)':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Ascenseur':
        return Icons.elevator;
      case 'Escalier':
        return Icons.stairs;
      case 'Piscine':
        return Icons.pool;
      case 'Parking':
        return Icons.local_parking;
      case 'Porte':
        return Icons.door_front_door;
      default:
        return Icons.apartment;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Installations')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Wrap(
                    spacing: 8,
                    children: _categories.map((category) {
                      return FilterChip(
                        label: Text(category),
                        selected: _selectedCategory == category,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: _filteredFacilities.isEmpty
                      ? const Center(child: Text('Aucune installation trouvée'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredFacilities.length,
                          itemBuilder: (context, index) {
                            final facility = _filteredFacilities[index];
                            return Card(
                              child: ListTile(
                                leading: Icon(_getCategoryIcon(facility['category'])),
                                title: Text(facility['name']),
                                subtitle: Text(facility['location']),
                                trailing: Text(
                                  facility['status'],
                                  style: TextStyle(color: _getStatusColor(facility['status'])),
                                ),
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
