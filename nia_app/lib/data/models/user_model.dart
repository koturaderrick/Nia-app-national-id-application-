import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    // Odoo returns uid as int — convert safely
    id: (json['id'] ?? json['uid'] ?? '').toString(),
    name: (json['name'] ?? json['partner_name'] ?? '').toString(),
    email: (json['email'] ?? json['login'] ?? '').toString(),
    // phone may be absent — default to empty string
    phone: (json['phone'] ?? json['partner_phone'] ?? '').toString(),
    // Odoo session token or our mock token
    token: (json['token'] ?? json['session_id'] ?? '').toString(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'token': token,
  };

  factory UserModel.fromEntity(User user) => UserModel(
    id: user.id,
    name: user.name,
    email: user.email,
    phone: user.phone,
    token: user.token,
  );
}