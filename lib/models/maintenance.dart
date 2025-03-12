class Maintenance {
  final int? id;
  final String title;
  final String? description;
  final String facilityType;
  final int buildingId;
  final int? technicianId;
  final DateTime scheduledDate;
  final String status;
  
  Maintenance({
    this.id,
    required this.title,
    this.description,
    required this.facilityType,
    required this.buildingId,
    this.technicianId,
    required this.scheduledDate,
    required this.status,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'facility_type': facilityType,
      'building_id': buildingId,
      'technician_id': technicianId,
      'scheduled_date': scheduledDate.toIso8601String(),
      'status': status,
    };
  }
  
  static Maintenance fromMap(Map<String, dynamic> map) {
    return Maintenance(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      facilityType: map['facility_type'],
      buildingId: map['building_id'],
      technicianId: map['technician_id'],
      scheduledDate: DateTime.parse(map['scheduled_date']),
      status: map['status'],
    );
  }
}

