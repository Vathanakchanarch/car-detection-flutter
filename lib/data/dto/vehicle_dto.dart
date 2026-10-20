import '../../model/vehicle.dart';

class VehicleDto {
  const VehicleDto({
    required this.id,
    required this.ownerId,
    required this.plateNumber,
    required this.vehicleType,
    required this.createdAt,
  });

  final int id;
  final int ownerId;
  final String plateNumber;
  final String vehicleType;
  final DateTime createdAt;

  factory VehicleDto.fromJson(Map<String, dynamic> json) {
    return VehicleDto(
      id: _requiredInt(json, 'id'),
      ownerId: _requiredInt(json, 'owner_id'),
      plateNumber: _requiredString(json, 'plate_number'),
      vehicleType: _requiredString(json, 'vehicle_type'),
      createdAt: _requiredDateTime(json, 'created_at'),
    );
  }

  Vehicle toModel() {
    final displayType = _toDisplayWords(vehicleType);
    return Vehicle(
      name: '$displayType $plateNumber',
      type: displayType,
      plate: plateNumber,
      colour: 'Not available',
      year: 0,
      expiry: 'Not available',
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

String _toDisplayWords(String value) {
  return value
      .split(RegExp(r'[_\-\s]+'))
      .where((word) => word.isNotEmpty)
      .map(
        (word) => '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
      )
      .join(' ');
}
