class Problem {
  final int? id;
  final String title;
  final String description;
  final String facilityType;
  final String status;
  final DateTime createdAt;
  final int userId;
  final int buildingId;
  
  Problem({
    this.id,
    required this.title,
    required this.description,
    required this.facilityType,
    required this.status,
    required this.createdAt,
    required this.userId,
    required this.buildingId,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'facility_type': facilityType,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'user_id': userId,
      'building_id': buildingId,
    };
  }
  
  static Problem fromMap(Map<String, dynamic> map) {
    return Problem(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      facilityType: map['facility_type'],
      status: map['status'],
      createdAt: DateTime.parse(map['created_at']),
      userId: map['user_id'],
      buildingId: map['building_id'],
    );
  }
}

