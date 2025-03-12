import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class InterventionReportScreen extends StatefulWidget {
  final String taskId;

  const InterventionReportScreen({
    super.key,
    required this.taskId,
  });

  @override
  State<InterventionReportScreen> createState() => _InterventionReportScreenState();
}

class _InterventionReportScreenState extends State<InterventionReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _diagnosticController = TextEditingController();
  final _actionTakenController = TextEditingController();
  final _completionTimeController = TextEditingController();
  List<File> _beforeImages = [];
  List<File> _afterImages = [];
  bool _taskCompleted = false;
  List<String> _checklistItems = [
    'Vérification des pièces défectueuses',
    'Nettoyage de la zone',
    'Test de fonctionnement',
    'Vérification de sécurité',
    'Information du client',
  ];
  List<bool> _checklistStatus = List.filled(5, false);

  Future<void> _pickImage(bool isBefore) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    
    if (pickedFile != null) {
      setState(() {
        if (isBefore) {
          _beforeImages.add(File(pickedFile.path));
        } else {
          _afterImages.add(File(pickedFile.path));
        }
      });
    }
  }

  void _removeImage(int index, bool isBefore) {
    setState(() {
      if (isBefore) {
        _beforeImages.removeAt(index);
      } else {
        _afterImages.removeAt(index);
      }
    });
  }

  Future<void> _submitReport() async {
    if (_formKey.currentState!.validate()) {
      // Vérifier que le technicien a pris au moins une photo avant/après
      if (_beforeImages.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez prendre au moins une photo avant intervention'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      if (_afterImages.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez prendre au moins une photo après intervention'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      // Ici, vous implémenteriez la logique pour envoyer le rapport
      // au serveur avec Firebase ou autre backend
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rapport envoyé avec succès'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Retourner à la page précédente
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _diagnosticController.dispose();
    _actionTakenController.dispose();
    _completionTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rapport d\'intervention: ${widget.taskId}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section checklist
              const Text(
                'Checklist d\'intervention',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _checklistItems.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(_checklistItems[index]),
                    value: _checklistStatus[index],
                    onChanged: (bool? value) {
                      setState(() {
                        _checklistStatus[index] = value!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                },
              ),
              const Divider(height: 32),
              
              // Section diagnostic
              const Text(
                'Diagnostic',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _diagnosticController,
                decoration: const InputDecoration(
                  labelText: 'Diagnostic détaillé',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un diagnostic';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              // Section photos avant
              const Text(
                'Photos avant intervention',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (_beforeImages.isNotEmpty)
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _beforeImages.length,
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
                                image: FileImage(_beforeImages[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 8,
                            child: GestureDetector(
                              onTap: () => _removeImage(index, true),
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
                onPressed: () => _pickImage(true),
                icon: const Icon(Icons.camera_alt),
                label: const Text('Prendre photo avant'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              
              // Section actions effectuées
              const Text(
                'Actions effectuées',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _actionTakenController,
                decoration: const InputDecoration(
                  labelText: 'Actions réalisées',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez détailler les actions effectuées';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              // Section photos après
              const Text(
                'Photos après intervention',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (_afterImages.isNotEmpty)
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _afterImages.length,
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
                                image: FileImage(_afterImages[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 8,
                            child: GestureDetector(
                              onTap: () => _removeImage(index, false),
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
                onPressed: () => _pickImage(false),
                icon: const Icon(Icons.camera_alt),
                label: const Text('Prendre photo après'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              
              // Section temps d'intervention
              const Text(
                'Temps d\'intervention',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _completionTimeController,
                decoration: const InputDecoration(
                  labelText: 'Durée (en minutes)',
                  border: OutlineInputBorder(),
                  hintText: 'Ex: 45',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez indiquer la durée';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              // Section état de la tâche
              const Text(
                'État de l\'intervention',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SwitchListTile(
                title: const Text('Intervention terminée'),
                value: _taskCompleted,
                onChanged: (bool value) {
                  setState(() {
                    _taskCompleted = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              
              // Bouton de soumission
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _taskCompleted ? _submitReport : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Envoyer le rapport',
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

