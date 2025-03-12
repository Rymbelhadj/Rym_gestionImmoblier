class Intervention {
  final int? id;
  final int problemId;
  final int technicianId;
  final String? diagnostic;
  final String? actionsTaken;
  final String status;
  final DateTime? startTime;
  final DateTime? endTime;
  final int? duration;
  
  Intervention({
    this.id,
    required this.problemId,
    required this.technicianId,
    this.diagnostic,
    this.actionsTaken,
    required this.status,
    this.startTime,
    this.endTime,
    this.duration,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'problem_id': problemId,
      'technician_id': technicianId,
      'diagnostic': diagnostic,
      'actions_taken': actionsTaken,
      'status': status,
      'start_time': startTime?.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'duration': duration,
    };
  }
  
  static Intervention fromMap(Map<String, dynamic> map) {
    return Intervention(
      id: map['id'],
      problemId: map['problem_id'],
      technicianId: map['technician_id'],
      diagnostic: map['diagnostic'],
      actionsTaken: map['actions_taken'],
      status: map['status'],
      startTime: map['start_time'] != null ? DateTime.parse(map['start_time']) : null,
      endTime: map['end_time'] != null ? DateTime.parse(map['end_time']) : null,
      duration: map['duration'],
    );
  }
}

