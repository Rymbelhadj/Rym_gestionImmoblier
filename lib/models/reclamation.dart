class Reclamation {
  final int? id;
  final int idClient;
  final int idEquipement;
  final String description;
  final DateTime dateCreation;
  final String statut;
  
  Reclamation({
    this.id,
    required this.idClient,
    required this.idEquipement,
    required this.description,
    required this.dateCreation,
    required this.statut,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_client': idClient,
      'id_equipement': idEquipement,
      'description': description,
      'date_creation': dateCreation.toIso8601String(),
      'statut': statut,
    };
  }
  
  static Reclamation fromMap(Map<String, dynamic> map) {
    return Reclamation(
      id: map['id'],
      idClient: map['id_client'],
      idEquipement: map['id_equipement'],
      description: map['description'],
      dateCreation: DateTime.parse(map['date_creation']),
      statut: map['statut'],
    );
  }
}

