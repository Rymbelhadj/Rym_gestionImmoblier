class Paiement {
  final int? id;
  final int idRapport;
  final int idClient;
  final double montant;
  final DateTime datePaiement;
  final String modePaiement;
  final String statut;
  
  Paiement({
    this.id,
    required this.idRapport,
    required this.idClient,
    required this.montant,
    required this.datePaiement,
    required this.modePaiement,
    required this.statut,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_rapport': idRapport,
      'id_client': idClient,
      'montant': montant,
      'date_paiement': datePaiement.toIso8601String(),
      'mode_paiement': modePaiement,
      'statut': statut,
    };
  }
  
  static Paiement fromMap(Map<String, dynamic> map) {
    return Paiement(
      id: map['id'],
      idRapport: map['id_rapport'],
      idClient: map['id_client'],
      montant: map['montant'],
      datePaiement: DateTime.parse(map['date_paiement']),
      modePaiement: map['mode_paiement'],
      statut: map['statut'],
    );
  }
}

