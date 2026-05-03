class AppConstants {
  static const String appName = 'National ID App';

  // ── Odoo backend URL ───────────────────────────────────────────────────
  // Change this to your Odoo server IP when testing on a real device
  static const String baseUrl = 'http://192.168.40.129:8069';

  // SharedPreferences keys
  static const String keyIsLoggedIn    = 'is_logged_in';
  static const String keyUserId        = 'user_id';
  static const String keyUserEmail     = 'user_email';
  static const String keyUserName      = 'user_name';
  static const String keyUserPhone     = 'user_phone';
  static const String keyAuthToken     = 'auth_token';
  static const String keyRegisteredUsers       = 'registered_users';
  static const String keySubmittedApplications = 'submitted_applications';

  // Tracking stages — must match Odoo state_map in controller
  static const List<String> trackingStages = [
    'Pending',
    'Verified',
    'Senior Approval',
    'Final Approval',
  ];

  // Ugandan districts
  static const List<String> districts = [
    'Kampala', 'Wakiso', 'Mukono', 'Jinja', 'Mbale',
    'Gulu', 'Mbarara', 'Masaka', 'Arua', 'Lira',
    'Fort Portal', 'Soroti', 'Kabale', 'Tororo', 'Kasese',
    'Hoima', 'Masindi', 'Iganga', 'Busia', 'Kitgum',
  ];

  // Gender options
  static const List<String> genderOptions = ['Male', 'Female'];
}