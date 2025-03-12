class User {
  final int? id;
  final String name;
  final String email;
  final String password;
  final String role;
  final int? buildingId;
  
  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    this.buildingId,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'building_id': buildingId,
    };
  }
  
  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      role: map['role'],
      buildingId: map['building_id'],
    );
  }
}

