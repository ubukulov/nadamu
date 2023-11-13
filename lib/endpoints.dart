class Endpoints {
  static const String baseUrl = 'kpp.dlg.kz:8900';
  static const String baseUrlWithHttps = 'https://kpp.dlg.kz:8900';
  static const String authLogin = '/api/auth/login';
  static const String getUserByToken = '/api/user/get-user-info';
  // Ashana
  static const String getKitchenItems = '/api/ashana/get-items';
  static const String getKitchenItemsByFilter = '/get-items-by-filter';
  static const String getUserRoles = '/get-items-by-filter';
  static const String getUserByUuid = '/api/ashana/get-user-by-uuid';
}