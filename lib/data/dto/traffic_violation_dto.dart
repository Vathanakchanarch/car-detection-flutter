import '../../model/violation.dart';

enum TrafficViolationStatusDto {
  pending('pending'),
  confirmed('confirmed'),
  rejected('rejected');

  const TrafficViolationStatusDto(this.apiValue);

  final String apiValue;

  static TrafficViolationStatusDto parse(String value) {
    return switch (value) {
      'pending' => pending,
      'confirmed' => confirmed,
      'rejected' => rejected,
      _ => throw FormatException(
        'Unknown traffic violation status "$value". '
        'Expected pending, confirmed, or rejected.',
      ),
    };
  }
}

class TrafficViolationDto {
  const TrafficViolationDto({
    required this.id,
    required this.vehicleId,
    required this.violationType,
    required this.location,
    required this.occurredAt,
    required this.status,
    required this.createdAt,
  });

  final int id;
  final int vehicleId;
  final String violationType;
  final String location;
  final DateTime occurredAt;
  final TrafficViolationStatusDto status;
  final DateTime createdAt;

  factory TrafficViolationDto.fromJson(Map<String, dynamic> json) {
    return TrafficViolationDto(
      id: _requiredInt(json, 'id'),
      vehicleId: _requiredInt(json, 'vehicle_id'),
      violationType: _requiredString(json, 'violation_type'),
      location: _requiredString(json, 'location'),
      occurredAt: _requiredDateTime(json, 'occurred_at'),
      status: TrafficViolationStatusDto.parse(_requiredString(json, 'status')),
      createdAt: _requiredDateTime(json, 'created_at'),
    );
  }

  Violation toModel() {
    return Violation(
      id: id.toString(),
      title: _toDisplayWords(violationType),
      date: _formatDate(occurredAt),
      time: _formatTime(occurredAt),
      location: location,
      plate: 'Not available',
      reference: id.toString(),
      status: switch (status) {
        TrafficViolationStatusDto.pending => ViolationStatus.underReview,
        TrafficViolationStatusDto.confirmed => ViolationStatus.confirmed,
        TrafficViolationStatusDto.rejected => ViolationStatus.resolved,
      },
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

String _formatDate(DateTime value) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${value.day} ${months[value.month - 1]} ${value.year}';
}

String _formatTime(DateTime value) {
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}
