import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String token;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.token,
  });

  @override
  List<Object?> get props => [id, email];
}
