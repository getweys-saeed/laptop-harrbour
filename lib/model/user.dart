class User {
  final int? id;
  final String name;
  final String email;
  final String? emailVerifiedAt;
  final String? password; // Optional for user info response
  final String? photo; // Added field for photo
  final String? role;
  final String? provider;
  final String? providerId;
  final String status;
  final String? rememberToken;
  final String? createdAt;
  final String? updatedAt;

  // Constructor
  User({
    this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    this.password,
    this.photo,
    this.role = 'user', // Default role
    this.provider,
    this.providerId,
    this.status = 'active', // Default status
    this.rememberToken,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      status: json['status'] ?? 'active', // Default fallback
      role: json['role'] ?? 'customer',  // Default fallback
      photo: json['photo'],  // Added photo field
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'status': status,
      'role': role,
      'photo': photo,  // Include photo in toJson
    };
  }
}
