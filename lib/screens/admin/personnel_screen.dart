
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/user.dart';

class PersonnelScreen extends StatefulWidget {
  const PersonnelScreen({super.key});

  @override
  State<PersonnelScreen> createState() => _PersonnelScreenState();
}

class _PersonnelScreenState extends State<PersonnelScreen> {
  List<User> _personnel = [];
  bool _isLoading = true;
  String _selectedRole = 'Tous';
  final List<String> _roles = ['Tous', 'admin', 'technicien', 'client'];
  
  @override
  void initState() {
    super.initState();
    _loadPersonnel();
  }
  
  Future<void> _loadPersonnel() async {
    setState(() {
      _isLoading = true;
    });
    
    // Simuler le chargement des données
    await Future.delayed(const Duration(seconds: 1));
    
    // Données simulées
    final personnel = [
      User(id: 1, name: 'Admin Principal', email: 'admin@example.com', password: '123456', role: 'admin'),
      User(id: 2, name: 'Jean Dupont', email: 'jean@example.com', password: '123456', role: 'technicien'),
      User(id: 3, name: 'Marie Martin', email: 'marie@example.com', password: '123456', role: 'technicien'),
      User(id: 4, name: 'Pierre Durand', email: 'pierre@example.com', password: '123456', role: 'technicien'),
      User(id: 5, name: 'Sophie Lefebvre', email: 'sophie@example.com', password: '123456', role: 'client'),
      User(id: 6, name: 'Lucas Bernard', email: 'lucas@example.com', password: '123456', role: 'client'),
    ];
    
    setState(() {
      _personnel = personnel;
      _isLoading = false;
    });
  }
  
  List<User> get _filteredPersonnel {
    if (_selectedRole == 'Tous') {
      return _personnel;
    } else {
      return _personnel.where((user) => user.role == _selectedRole).toList();
    }
  }
  
  Future<void> _showAddEditPersonnelDialog([User? user]) async {
    final isEditing = user != null;
    final nameController = TextEditingController(text: isEditing ? user.name : '');
    final emailController = TextEditingController(text: isEditing ? user.email : '');
    final passwordController = TextEditingController();
    String role = isEditing ? user.role : 'client';
    
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(isEditing ? 'Modifier l\'utilisateur' : 'Ajouter un utilisateur'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nom complet',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: isEditing ? 'Nouveau mot de passe (laisser vide pour ne pas changer)' : 'Mot de passe',
                    border: const OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: role,
                  decoration: const InputDecoration(
                    labelText: 'Rôle',
                    border: OutlineInputBorder(),
                  ),
                  items: ['admin', 'technicien', 'client'].map((r) {
                    return DropdownMenuItem<String>(
                      value: r,
                      child: Text(r),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        role = value;
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
                if (nameController.text.isEmpty || emailController.text.isEmpty || 
                    (!isEditing && passwordController.text.isEmpty)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Veuillez remplir tous les champs obligatoires'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                
                if (isEditing) {
                  // Mettre à jour l'utilisateur existant
                  final updatedUser = User(
                    id: user.id,
                    name: nameController.text,
                    email: emailController.text,
                    password: passwordController.text.isEmpty ? user.password : passwordController.text,
                    role: role,
                  );
                  
                  this.setState(() {
                    final index = _personnel.indexWhere((u) => u.id == user.id);
                    if (index != -1) {
                      _personnel[index] = updatedUser;
                    }
                  });
                } else {
                  // Créer un nouvel utilisateur
                  final newUser = User(
                    id: _personnel.isNotEmpty ? _personnel.map((u) => u.id!).reduce((a, b) => a > b ? a : b) + 1 : 1,
                    name: nameController.text,
                    email: emailController.text,
                    password: passwordController.text,
                    role: role,
                  );
                  
                  this.setState(() {
                    _personnel.add(newUser);
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
  
  Future<void> _deletePersonnel(User user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Êtes-vous sûr de vouloir supprimer l\'utilisateur "${user.name}" ?'),
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
        _personnel.removeWhere((u) => u.id == user.id);
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Utilisateur supprimé avec succès'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion du Personnel'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Text('Filtrer par rôle: '),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButton<String>(
                          value: _selectedRole,
                          isExpanded: true,
                          items: _roles.map((role) {
                            return DropdownMenuItem<String>(
                              value: role,
                              child: Text(role),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedRole = value;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _filteredPersonnel.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Aucun personnel trouvé',
                                style: TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _showAddEditPersonnelDialog,
                                child: const Text('Ajouter un utilisateur'),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadPersonnel,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _filteredPersonnel.length,
                            itemBuilder: (context, index) {
                              final user = _filteredPersonnel[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 16),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: _getRoleColor(user.role),
                                    child: Text(user.name[0]),
                                  ),
                                  title: Text(user.name),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Email: ${user.email}'),
                                      Text('Rôle: ${user.role}'),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () => _showAddEditPersonnelDialog(user),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => _deletePersonnel(user),
                                      ),
                                    ],
                                  ),
                                  isThreeLine: true,
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEditPersonnelDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
  
  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin':
        return Colors.red;
      case 'technicien':
        return Colors.blue;
      case 'client':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}