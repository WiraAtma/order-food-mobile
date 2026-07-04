class User {
  final int id;
  final String name;
  final String email;
  final String role;
  final String address;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'] ?? '',       
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      address: json['address'] ?? '', 
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'role': role,
    'address': address,
  };
}
