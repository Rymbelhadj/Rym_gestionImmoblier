// lib/screens/admin/immeubles_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/immeuble.dart';

class ImmeublesScreen extends StatefulWidget {
  const ImmeublesScreen({super.key});

  @override
  State<ImmeublesScreen> createState() => _ImmeublesScreenState();
}

class _ImmeublesScreenState extends State<ImmeublesScreen> {
  List<Immeuble> _immeubles = [];
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadImmeubles();
  }
  
  Future<void> _loadImmeubles() async {
    setState(() {
      _isLoading = true;
    });
    
    // Simuler le chargement des données
    await Future.delayed(const Duration(seconds: 1));
    
    // Données simulées
    final immeubles = [
      Immeuble(id: 1, nom: 'Résidence Les Oliviers', adresse: '123 Avenue de la République', type: 'Résidentiel'),
      Immeuble(id: 2, nom: 'Immeuble Le Parc', adresse: '45 Rue des Fleurs', type: 'Mixte'),
      Immeuble(id: 3, nom: 'Tour Horizon', adresse: '78 Boulevard Central', type: 'Commercial'),
    ];
    
    setState(() {
      _immeubles = immeubles;
      _isLoading = false;
    });
  }
  
  Future<void> _showAddEditImmeubleDialog([Immeuble? immeuble]) async {
    final isEditing = immeuble != null;
    final nomController = TextEditingController(text: isEditing ? immeuble.nom : '');
    final adresseController = TextEditingController(text: isEditing ? immeuble.adresse : '');
    String type = isEditing ? immeuble.type : 'Résidentiel';
    
    final types = ['Résidentiel', 'Commercial', 'Mixte', 'Industriel'];
    
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(isEditing ? 'Modifier l\'immeuble' : 'Ajouter un immeuble'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nomController,
                  decoration: const InputDecoration(
                    labelText: 'Nom de l\'immeuble',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: adresseController,
                  decoration: const InputDecoration(
                    labelText: 'Adresse',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: type,
                  decoration: const InputDecoration(
                    labelText: 'Type d\'immeuble',
                    border: OutlineInputBorder(),
                  ),
                  items: types.map((t) {
                    return DropdownMenuItem<String>(
                      value: t,
                      child: Text(t),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        type = value;
                      });
                    }
                  },
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
                if (nomController.text.isEmpty || adresseController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Veuillez remplir tous les champs'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                
                if (isEditing) {
                  // Mettre à jour l'immeuble existant
                  final updatedImmeuble = Immeuble(
                    id: immeuble.id,
                    nom: nomController.text,
                    adresse: adresseController.text,
                    type: type,
                  );
                  
                  this.setState(() {
                    final index = _immeubles.indexWhere((i) => i.id == immeuble.id);
                    if (index != -1) {
                      _immeubles[index] = updatedImmeuble;
                    }
                  });
                } else {
                  // Créer un nouvel immeuble
                  final newImmeuble = Immeuble(
                    id: _immeubles.isNotEmpty ? _immeubles.map((i) => i.id!).reduce((a, b) => a > b ? a : b) + 1 : 1,
                    nom: nomController.text,
                    adresse: adresseController.text,
                    type: type,
                  );
                  
                  this.setState(() {
                    _immeubles.add(newImmeuble);
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
  
  Future<void> _deleteImmeuble(Immeuble immeuble) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Êtes-vous sûr de vouloir supprimer l\'immeuble "${immeuble.nom}" ?'),
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
        _immeubles.removeWhere((i) => i.id == immeuble.id);
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Immeuble supprimé avec succès'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Immeubles'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _immeubles.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Aucun immeuble trouvé',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _showAddEditImmeubleDialog,
                        child: const Text('Ajouter un immeuble'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadImmeubles,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _immeubles.length,
                    itemBuilder: (context, index) {
                      final immeuble = _immeubles[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ListTile(
                          title: Text(immeuble.nom),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Adresse: ${immeuble.adresse}'),
                              Text('Type: ${immeuble.type}'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _showAddEditImmeubleDialog(immeuble),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteImmeuble(immeuble),
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
        onPressed: _showAddEditImmeubleDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}