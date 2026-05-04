import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../../core/errors/failures.dart';
import '../local/auth_local_datasource.dart';

class MockApiService {
  final AuthLocalDataSource localDataSource;
  static const _uuid = Uuid();
  static const _networkDelay = Duration(milliseconds: 1200);

  const MockApiService(this.localDataSource);

  Future<Map<String, dynamic>> login(String email, String password) async {
    await Future.delayed(_networkDelay);

    final stored = await localDataSource.getRegisteredUser(email.toLowerCase());
    if (stored == null) {
      throw const AuthFailure('No account found with this email.');
    }
    if (stored['password'] != password) {
      throw const AuthFailure('Incorrect password. Please try again.');
    }
    return {
      'id': stored['id'],
      'name': stored['name'],
      'email': stored['email'],
      'phone': stored['phone'],
      'token': 'token_${_uuid.v4()}',
    };
  }

  Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    await Future.delayed(_networkDelay);

    final exists = await localDataSource.emailExists(email.toLowerCase());
    if (exists) {
      throw const AuthFailure('An account with this email already exists.');
    }

    final userId = _uuid.v4();
    final userData = {
      'id': userId,
      'name': name,
      'email': email.toLowerCase(),
      'phone': phone,
      'password': password,
    };
    await localDataSource.saveRegisteredUser(userData);

    return {
      'id': userId,
      'name': name,
      'email': email.toLowerCase(),
      'phone': phone,
      'token': 'token_${_uuid.v4()}',
    };
  }

  Future<Map<String, dynamic>> submitApplication(
      Map<String, dynamic> applicationData) async {
    await Future.delayed(const Duration(milliseconds: 2000));

    final trackingNumber =
        'NID-${DateTime.now().year}-${_generateCode()}';
    final submission = {
      ...applicationData,
      'tracking_number': trackingNumber,
      'submitted_date': DateTime.now().toIso8601String().split('T').first,
      'stage': 'Pending',
    };

    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString('app_$trackingNumber');
    if (existing == null) {
      await prefs.setString('app_$trackingNumber', jsonEncode(submission));
    }

    return {'tracking_number': trackingNumber};
  }

  Future<Map<String, dynamic>> trackApplication(String trackingNumber) async {
    await Future.delayed(_networkDelay);

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('app_$trackingNumber');

    if (raw != null) {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      return {
        'tracking_number': trackingNumber,
        'stage': data['stage'] ?? 'Pending',
        'message': _getStageMessage(data['stage'] ?? 'Pending'),
        'applicant_name': data['full_name'] ?? 'Applicant',
        'submitted_date': data['submitted_date'] ?? '',
        'last_updated': DateTime.now().toIso8601String().split('T').first,
      };
    }

    // For manually entered tracking numbers not in local storage
    if (trackingNumber.startsWith('NID-')) {
      return {
        'tracking_number': trackingNumber,
        'stage': 'Pending',
        'message': _getStageMessage('Pending'),
        'applicant_name': 'Applicant',
        'submitted_date':
            DateTime.now().toIso8601String().split('T').first,
        'last_updated': DateTime.now().toIso8601String().split('T').first,
      };
    }

    throw const NotFoundFailure('No application found with this tracking number.');
  }

  String _getStageMessage(String stage) {
    switch (stage) {
      case 'Pending':
        return 'Your application has been received and is awaiting review.';
      case 'Verified':
        return 'Your documents have been verified by our team.';
      case 'Senior Approval':
        return 'Your application is under senior officer review.';
      case 'Final Approval':
        return 'Your National ID has been approved and is being processed.';
      case 'Rejected':
        return 'Your application was rejected. Please contact the office.';
      default:
        return 'Status unknown. Please contact support.';
    }
  }

  String _generateCode() {
    final rand = DateTime.now().millisecondsSinceEpoch % 100000;
    return rand.toString().padLeft(5, '0');
  }
}
