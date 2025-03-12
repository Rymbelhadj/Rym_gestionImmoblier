class Panne {
  final int? id;
  final int iduser; 
  final String description;
  final DateTime dateDetection;
  
  final String statut;
  
  Panne({
    this.id,
    required this.iduser,
    required this.description,
    required this.dateDetection,
   
    required this.statut,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'iduser': iduser, // Ajouté ici
      'description': description,
      'date_detection': dateDetection.toIso8601String(),
     
      'statut': statut,
    };
  }
  
  static Panne fromMap(Map<String, dynamic> map) {
    return Panne(
      id: map['id'],
      iduser: map['iduser'], // Ajouté ici
      description: map['description'],
      dateDetection: DateTime.parse(map['date_detection']),
 
        
      statut: map['statut'],
    );
  }
}
