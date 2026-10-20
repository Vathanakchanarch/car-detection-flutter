import 'api_config.dart';

enum ApiMethod { get, post, put, patch, delete }

/// A request description that can be sent by an HTTP adapter in Step 4B.
class ApiRequest {
  const ApiRequest({
    required this.method,
    required this.uri,
    required this.headers,
    this.body,
  });

  final ApiMethod method;
  final Uri uri;
  final Map<String, String> headers;
  final Map<String, dynamic>? body;
}

/// Builds consistent API requests without performing network I/O.
class ApiClient {
  const ApiClient({this.defaultHeaders = const {'Accept': 'application/json'}});

  final Map<String, String> defaultHeaders;

  ApiRequest get(
    String path, {
    Map<String, String>? queryParameters,
    Map<String, String> headers = const {},
  }) => _build(
    ApiMethod.get,
    path,
    queryParameters: queryParameters,
    headers: headers,
  );

  ApiRequest post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String> headers = const {},
  }) => _build(ApiMethod.post, path, body: body, headers: headers);

  ApiRequest put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String> headers = const {},
  }) => _build(ApiMethod.put, path, body: body, headers: headers);

  ApiRequest patch(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String> headers = const {},
  }) => _build(ApiMethod.patch, path, body: body, headers: headers);

  ApiRequest delete(
    String path, {
    Map<String, String>? queryParameters,
    Map<String, String> headers = const {},
  }) => _build(
    ApiMethod.delete,
    path,
    queryParameters: queryParameters,
    headers: headers,
  );

  ApiRequest _build(
    ApiMethod method,
    String path, {
    Map<String, String>? queryParameters,
    Map<String, dynamic>? body,
    Map<String, String> headers = const {},
  }) {
    return ApiRequest(
      method: method,
      uri: ApiConfig.uri(path, queryParameters: queryParameters),
      headers: {
        ...defaultHeaders,
        if (body != null) 'Content-Type': 'application/json',
        ...headers,
      },
      body: body,
    );
  }
}
