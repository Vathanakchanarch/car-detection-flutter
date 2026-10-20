class ApiConfig {
  const ApiConfig._();

  /// Replace at run time with:
  /// `--dart-define=AICA_API_BASE_URL=https://your-api.example`
  static const String baseUrl = String.fromEnvironment(
    'AICA_API_BASE_URL',
    defaultValue: 'https://api.example.invalid',
  );

  static const String apiPrefix = '/api/v1';
  static const String healthPath = '/health';
  static const String databaseHealthPath = '/health/db';
  static const String ownersPath = '$apiPrefix/owners';
  static const String vehiclesPath = '$apiPrefix/vehicles';
  static const String trafficViolationsPath = '$apiPrefix/traffic-violations';

  static Uri uri(String path, {Map<String, String>? queryParameters}) {
    final uri = Uri.parse(baseUrl).resolve(path);
    return queryParameters == null
        ? uri
        : uri.replace(queryParameters: queryParameters);
  }
}
