import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/auth_provider.dart';
import 'package:flutter_application_1/database/database_helper.dart';
import 'package:flutter_application_1/models/probleme.dart';
import 'dart:io';

class ProblemFormScreen extends StatefulWidget {
  const ProblemFormScreen({super.key});

  @override
  State<ProblemFormScreen> createState() => _ProblemFormScreenState();
}

class _ProblemFormScreenState extends State<ProblemFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedFacility = 'Ascenseur';
  List<File> _images = [];
  final _facilities = [
    'Ascenseur',
    'Escalier',
    'Piscine',
    'Parking sous-sol',
    'Porte Générale',
    'Autre'
  ];
  final DatabaseHelper _dbHelper = DatabaseHelper();
  bool _isSubmitting = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<void> _submitProblem() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });
      
      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        if (authProvider.user != null) {
          // Créer un nouveau problème
          final problem = Problem(
            title: _titleController.text,
            description: _descriptionController.text,
            facilityType: _selectedFacility,
            status: 'En attente',
            createdAt: DateTime.now(),
            userId: authProvider.user!.id!,
            buildingId: authProvider.user!.buildingId ?? 1, // Fallback à l'ID 1 si null
          );
          
          // Insérer le problème dans la base de données
          final problemId = await _dbHelper.insertProblem(problem);
          
          // TODO: Sauvegarder les images et les associer au problème
          // Cette partie nécessiterait de copier les images dans un dossier permanent
          // et d'enregistrer les chemins dans la base de données
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Problème signalé avec succès'),
              backgroundColor: Colors.green,
            ),
          );
          
          // Retourner à la page précédente
          if (mounted) {
            Navigator.pop(context);
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signaler un problème'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Titre du problème',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un titre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedFacility,
                decoration: const InputDecoration(
                  labelText: 'Installation concernée',
                  border: OutlineInputBorder(),
                ),
                items: _facilities.map((String facility) {
                  return DropdownMenuItem<String>(
                    value: facility,
                    child: Text(facility),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedFacility = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description détaillée',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Photos (optionnel)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (_images.isNotEmpty)
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: FileImage(_images[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 8,
                            child: GestureDetector(
                              onTap: () => _removeImage(index),
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.photo_library),
                label: const Text('Ajouter des photos'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitProblem,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Soumettre',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

