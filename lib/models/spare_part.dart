class SparePart {
  final int? id;
  final String name;
  final String? description;
  final int quantity;
  final int minQuantity;
  final String facilityType;
  
  SparePart({
    this.id,
    required this.name,
    this.description,
    required this.quantity,
    required this.minQuantity,
    required this.facilityType,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'quantity': quantity,
      'min_quantity': minQuantity,
      'facility_type': facilityType,
    };
  }
  
  static SparePart fromMap(Map<String, dynamic> map) {
    return SparePart(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      quantity: map['quantity'],
      minQuantity: map['min_quantity'],
      facilityType: map['facility_type'],
    );
  }
}

