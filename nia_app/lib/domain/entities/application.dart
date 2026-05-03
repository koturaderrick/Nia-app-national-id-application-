import 'package:equatable/equatable.dart';

class Application extends Equatable {
  final String fullName;
  final String dateOfBirth;
  final String gender;
  final String district;
  final String subCounty;
  final String phone;
  final String email;
  final String nextOfKinName;
  final String nextOfKinPhone;
  final String nextOfKinRelationship;
  final String? photoPath;
  final String? lcLetterPath;

  const Application({
    required this.fullName,
    required this.dateOfBirth,
    required this.gender,
    required this.district,
    required this.subCounty,
    required this.phone,
    required this.email,
    required this.nextOfKinName,
    required this.nextOfKinPhone,
    required this.nextOfKinRelationship,
    this.photoPath,
    this.lcLetterPath,
  });

  @override
  List<Object?> get props => [
        fullName,
        dateOfBirth,
        gender,
        district,
        subCounty,
        phone,
        email,
      ];
}
