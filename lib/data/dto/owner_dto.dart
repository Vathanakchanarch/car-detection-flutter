class OwnerDto {
  const OwnerDto({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.createdAt,
  });

  final int id;
  final String fullName;
  final String phoneNumber;
  final DateTime createdAt;

  factory OwnerDto.fromJson(Map<String, dynamic> json) {
    return OwnerDto(
      id: _requiredInt(json, 'id'),
      fullName: _requiredString(json, 'full_name'),
      phoneNumber: _requiredString(json, 'phone_number'),
      createdAt: _requiredDateTime(json, 'created_at'),
    );
  }
}

int _requiredInt(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is int) return value;
  throw FormatException('Expected "$key" to be an integer.');
}

String _requiredString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is String && value.isNotEmpty) return value;
  throw FormatException('Expected "$key" to be a non-empty string.');
}

DateTime _requiredDateTime(Map<String, dynamic> json, String key) {
  final value = _requiredString(json, key);
  try {
    return DateTime.parse(value);
  } on FormatException {
    throw FormatException('Expected "$key" to be a valid ISO-8601 date.');
  }
}
