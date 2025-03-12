// lib/screens/client/contract_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/auth_provider.dart';
import 'package:intl/intl.dart';

class ContractScreen extends StatefulWidget {
  const ContractScreen({super.key});

  @override
  State<ContractScreen> createState() => _ContractScreenState();
}

class _ContractScreenState extends State<ContractScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _contracts = [];
  
  @override
  void initState() {
    super.initState();
    _loadContracts();
  }
  
  Future<void> _loadContracts() async {
    setState(() {
      _isLoading = true;
    });
    
    // Simuler le chargement des données
    await Future.delayed(const Duration(seconds: 1));
    
    // Données simulées pour les contrats
    final contracts = [
      {
        'id': 1,
        'title': 'Contrat de maintenance standard',
        'immeuble': 'Résidence Les Oliviers',
        'start_date': DateTime(2023, 1, 1),
        'end_date': DateTime(2024, 12, 31),
        'status': 'Actif',
        'monthly_fee': 150.0,
        'services': [
          'Maintenance des ascenseurs',
          'Entretien des espaces communs',
          'Maintenance des systèmes de chauffage',
        ],
      },
      {
        'id': 2,
        'title': 'Contrat de maintenance piscine',
        'immeuble': 'Résidence Les Oliviers',
        'start_date': DateTime(2023, 5, 1),
        'end_date': DateTime(2024, 4, 30),
        'status': 'Actif',
        'monthly_fee': 75.0,
        'services': [
          'Nettoyage hebdomadaire',
          'Contrôle de la qualité de l\'eau',
          'Maintenance des équipements de filtration',
        ],
      },
      {
        'id': 3,
        'title': 'Contrat de sécurité',
        'immeuble': 'Résidence Les Oliviers',
        'start_date': DateTime(2022, 7, 1),
        'end_date': DateTime(2023, 6, 30),
        'status': 'Expiré',
        'monthly_fee': 100.0,
        'services': [
          'Surveillance 24/7',
          'Maintenance des systèmes d\'alarme',
          'Contrôle des accès',
        ],
      },
    ];
    
    setState(() {
      _contracts = contracts;
      _isLoading = false;
    });
  }
  
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Actif':
        return Colors.green;
      case 'Expiré':
        return Colors.red;
      case 'En attente':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
  
  void _showContractDetails(Map<String, dynamic> contract) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        contract['title'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _getStatusColor(contract['status']),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        contract['status'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),
                _buildInfoRow('Immeuble', contract['immeuble']),
                _buildInfoRow(
                  'Période',
                  '${DateFormat('dd/MM/yyyy').format(contract['start_date'])} - ${DateFormat('dd/MM/yyyy').format(contract['end_date'])}',
                ),
                _buildInfoRow('Frais mensuels', '${contract['monthly_fee']} €'),
                const SizedBox(height: 20),
                const Text(
                  'Services inclus',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ...List.generate(
                  contract['services'].length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(contract['services'][index]),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),
                if (contract['status'] == 'Actif')
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Logique pour télécharger le contrat
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Téléchargement du contrat...'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.download),
                      label: const Text('Télécharger le contrat'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                  ),
                if (contract['status'] == 'Expiré')
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Logique pour renouveler le contrat
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Demande de renouvellement envoyée'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Renouveler le contrat'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _contracts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.description_outlined,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Aucun contrat trouvé',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Vous n\'avez pas encore de contrats actifs',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadContracts,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _contracts.length,
                    itemBuilder: (context, index) {
                      final contract = _contracts[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () => _showContractDetails(contract),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        contract['title'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(contract['status']),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        contract['status'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Immeuble: ${contract['immeuble']}',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Période: ${DateFormat('dd/MM/yyyy').format(contract['start_date'])} - ${DateFormat('dd/MM/yyyy').format(contract['end_date'])}',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Frais mensuels: ${contract['monthly_fee']} €',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () => _showContractDetails(contract),
                                      child: const Text('Voir les détails'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}