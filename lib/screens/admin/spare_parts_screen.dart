// lib/screens/admin/spare_parts_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/equipement.dart';

class SparePartsScreen extends StatefulWidget {
  const SparePartsScreen({super.key});

  @override
  State<SparePartsScreen> createState() => _SparePartsScreenState();
}

class _SparePartsScreenState extends State<SparePartsScreen> {
  List<Map<String, dynamic>> _spareParts = [];
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadSpareParts();
  }
  
  Future<void> _loadSpareParts() async {
    setState(() {
      _isLoading = true;
    });
    
    // Simuler le chargement des données
    await Future.delayed(const Duration(seconds: 1));
    
    // Données simulées pour les pièces de rechange
    final spareParts = [
      {
        'id': 1,
        'name': 'Joint d\'étanchéité',
        'code': 'JE-001',
        'quantity': 15,
        'min_quantity': 5,
        'facility_type': 'Piscine',
        'description': 'Joint pour système de filtration de piscine'
      },
      {
        'id': 2,
        'name': 'Câble de traction',
        'code': 'CT-002',
        'quantity': 3,
        'min_quantity': 2,
        'facility_type': 'Ascenseur',
        'description': 'Câble pour ascenseur modèle XYZ'
      },
      {
        'id': 3,
        'name': 'Filtre à air',
        'code': 'FA-003',
        'quantity': 8,
        'min_quantity': 3,
        'facility_type': 'Climatiseur',
        'description': 'Filtre pour climatiseur central'
      },
      {
        'id': 4,
        'name': 'Ampoule LED',
        'code': 'AL-004',
        'quantity': 25,
        'min_quantity': 10,
        'facility_type': 'Éclairage',
        'description': 'Ampoule LED 10W pour couloirs'
      },
    ];
    
    setState(() {
      _spareParts = spareParts;
      _isLoading = false;
    });
  }
  
  Future<void> _showAddEditSparePartDialog([Map<String, dynamic>? sparePart]) async {
    final isEditing = sparePart != null;
    final nameController = TextEditingController(text: isEditing ? sparePart['name'] : '');
    final codeController = TextEditingController(text: isEditing ? sparePart['code'] : '');
    final quantityController = TextEditingController(text: isEditing ? sparePart['quantity'].toString() : '0');
    final minQuantityController = TextEditingController(text: isEditing ? sparePart['min_quantity'].toString() : '0');
    final descriptionController = TextEditingController(text: isEditing ? sparePart['description'] : '');
    
    String facilityType = isEditing ? sparePart['facility_type'] : 'Ascenseur';
    final facilityTypes = ['Ascenseur', 'Piscine', 'Climatiseur', 'Chauffage', 'Éclairage', 'Porte', 'Autre'];
    
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(isEditing ? 'Modifier la pièce de rechange' : 'Ajouter une pièce de rechange'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nom de la pièce',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: codeController,
                  decoration: const InputDecoration(
                    labelText: 'Code',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: facilityType,
                  decoration: const InputDecoration(
                    labelText: 'Type d\'équipement',
                    border: OutlineInputBorder(),
                  ),
                  items: facilityTypes.map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        facilityType = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: quantityController,
                        decoration: const InputDecoration(
                          labelText: 'Quantité',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: minQuantityController,
                        decoration: const InputDecoration(
                          labelText: 'Quantité min',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isEmpty || codeController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Veuillez remplir tous les champs obligatoires'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                
                final quantity = int.tryParse(quantityController.text) ?? 0;
                final minQuantity = int.tryParse(minQuantityController.text) ?? 0;
                
                if (isEditing) {
                  // Mettre à jour la pièce existante
                  final updatedSparePart = {
                    'id': sparePart['id'],
                    'name': nameController.text,
                    'code': codeController.text,
                    'quantity': quantity,
                    'min_quantity': minQuantity,
                    'facility_type': facilityType,
                    'description': descriptionController.text,
                  };
                  
                  this.setState(() {
                    final index = _spareParts.indexWhere((p) => p['id'] == sparePart['id']);
                    if (index != -1) {
                      _spareParts[index] = updatedSparePart;
                    }
                  });
                } else {
                  // Créer une nouvelle pièce
                  final newSparePart = {
                    'id': _spareParts.isNotEmpty ? _spareParts.map((p) => p['id'] as int).reduce((a, b) => a > b ? a : b) + 1 : 1,
                    'name': nameController.text,
                    'code': codeController.text,
                    'quantity': quantity,
                    'min_quantity': minQuantity,
                    'facility_type': facilityType,
                    'description': descriptionController.text,
                  };
                  
                  this.setState(() {
                    _spareParts.add(newSparePart);
                  });
                }
                
                Navigator.pop(context);
              },
              child: Text(isEditing ? 'Mettre à jour' : 'Ajouter'),
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _deleteSparePart(Map<String, dynamic> sparePart) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Êtes-vous sûr de vouloir supprimer la pièce "${sparePart['name']}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      setState(() {
        _spareParts.removeWhere((p) => p['id'] == sparePart['id']);
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pièce supprimée avec succès'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Pièces de Rechange'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _spareParts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Aucune pièce de rechange trouvée',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _showAddEditSparePartDialog,
                        child: const Text('Ajouter une pièce'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadSpareParts,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _spareParts.length,
                    itemBuilder: (context, index) {
                      final sparePart = _spareParts[index];
                      final isLowStock = sparePart['quantity'] <= sparePart['min_quantity'];
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ListTile(
                          title: Row(
                            children: [
                              Text(sparePart['name']),
                              if (isLowStock)
                                Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'Stock bas',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Code: ${sparePart['code']}'),
                              Text('Type: ${sparePart['facility_type']}'),
                              Text('Quantité: ${sparePart['quantity']} (Min: ${sparePart['min_quantity']})'),
                              if (sparePart['description'] != null && sparePart['description'].isNotEmpty)
                                Text('Description: ${sparePart['description']}'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _showAddEditSparePartDialog(sparePart),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteSparePart(sparePart),
                              ),
                            ],
                          ),
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEditSparePartDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}