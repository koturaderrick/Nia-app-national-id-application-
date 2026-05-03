class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) return 'Enter a valid email address';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != password) return 'Passwords do not match';
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Phone number is required';
    final phoneRegex = RegExp(r'^\+?[0-9]{10,14}$');
    if (!phoneRegex.hasMatch(value.replaceAll(' ', ''))) {
      return 'Enter a valid phone number (10-14 digits)';
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return '$fieldName is required';
    return null;
  }

  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Full name is required';
    if (value.trim().length < 3) return 'Name must be at least 3 characters';
    final nameRegex = RegExp(r"^[a-zA-Z\s'-]+$");
    if (!nameRegex.hasMatch(value.trim())) return 'Name can only contain letters';
    return null;
  }

  static String? validateDateOfBirth(String? value) {
    if (value == null || value.trim().isEmpty) return 'Date of birth is required';
    return null;
  }

  static String? validateTrackingNumber(String? value) {
    if (value == null || value.trim().isEmpty) return 'Tracking number is required';
    if (!value.trim().startsWith('NID-')) return 'Invalid tracking number format';
    return null;
  }
}
