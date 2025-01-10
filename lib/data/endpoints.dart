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
  static const String fixChanges = '/api/ashana/fix-changes';

  // Webcont
  static const String getContainersZones = '/api/webcont/get-webcont-containers-zones';
  static const String getTechniques = '/api/webcont/get-webcont-techniques';
  static const String getContainerInfo = '/api/webcont/get-container-info';
  static const String getFreeRows = '/api/webcont/get-free-rows';
  static const String getFreeSlingers = '/api/webcont/get-free-slingers';
}