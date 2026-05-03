import '../../domain/entities/application.dart';

class ApplicationModel extends Application {
  const ApplicationModel({
    required super.fullName,
    required super.dateOfBirth,
    required super.gender,
    required super.district,
    required super.subCounty,
    required super.phone,
    required super.email,
    required super.nextOfKinName,
    required super.nextOfKinPhone,
    required super.nextOfKinRelationship,
    super.photoPath,
    super.lcLetterPath,
  });

  factory ApplicationModel.fromEntity(Application app) => ApplicationModel(
        fullName: app.fullName,
        dateOfBirth: app.dateOfBirth,
        gender: app.gender,
        district: app.district,
        subCounty: app.subCounty,
        phone: app.phone,
        email: app.email,
        nextOfKinName: app.nextOfKinName,
        nextOfKinPhone: app.nextOfKinPhone,
        nextOfKinRelationship: app.nextOfKinRelationship,
        photoPath: app.photoPath,
        lcLetterPath: app.lcLetterPath,
      );

  Map<String, dynamic> toJson() => {
        'full_name': fullName,
        'date_of_birth': dateOfBirth,
        'gender': gender,
        'district': district,
        'sub_county': subCounty,
        'phone': phone,
        'email': email,
        'next_of_kin_name': nextOfKinName,
        'next_of_kin_phone': nextOfKinPhone,
        'next_of_kin_relationship': nextOfKinRelationship,
      };
}
