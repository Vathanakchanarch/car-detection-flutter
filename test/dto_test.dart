import 'package:car_detection/data/api/api_client.dart';
import 'package:car_detection/data/api/api_config.dart';
import 'package:car_detection/data/dto/owner_dto.dart';
import 'package:car_detection/data/dto/traffic_violation_dto.dart';
import 'package:car_detection/data/dto/vehicle_dto.dart';
import 'package:car_detection/model/violation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const ownerJson = <String, dynamic>{
    'id': 1,
    'full_name': 'Sok Dara',
    'phone_number': '012345678',
    'created_at': '2026-10-20T08:00:00',
  };
  const vehicleJson = <String, dynamic>{
    'id': 10,
    'owner_id': 1,
    'plate_number': '2AB-1234',
    'vehicle_type': 'car',
    'created_at': '2026-10-20T08:00:00',
  };
  const violationJson = <String, dynamic>{
    'id': 100,
    'vehicle_id': 10,
    'violation_type': 'speeding',
    'location': 'Phnom Penh',
    'occurred_at': '2026-10-18T09:42:00',
    'status': 'pending',
    'created_at': '2026-10-18T09:45:00',
  };

  group('DTO JSON parsing', () {
    test('OwnerDto parses known owner fields and ISO date', () {
      final owner = OwnerDto.fromJson(ownerJson);

      expect(owner.id, 1);
      expect(owner.fullName, 'Sok Dara');
      expect(owner.phoneNumber, '012345678');
      expect(owner.createdAt, DateTime(2026, 10, 20, 8));
    });

    test('VehicleDto parses known vehicle fields and ISO date', () {
      final vehicle = VehicleDto.fromJson(vehicleJson);

      expect(vehicle.id, 10);
      expect(vehicle.ownerId, 1);
      expect(vehicle.plateNumber, '2AB-1234');
      expect(vehicle.vehicleType, 'car');
      expect(vehicle.createdAt, DateTime(2026, 10, 20, 8));
    });

    test('TrafficViolationDto parses known fields and ISO dates', () {
      final violation = TrafficViolationDto.fromJson(violationJson);

      expect(violation.id, 100);
      expect(violation.vehicleId, 10);
      expect(violation.violationType, 'speeding');
      expect(violation.location, 'Phnom Penh');
      expect(violation.occurredAt, DateTime(2026, 10, 18, 9, 42));
      expect(violation.createdAt, DateTime(2026, 10, 18, 9, 45));
    });

    test('invalid ISO dates fail clearly', () {
      expect(
        () => OwnerDto.fromJson({...ownerJson, 'created_at': 'not-a-date'}),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('traffic violation status parsing', () {
    for (final entry in {
      'pending': TrafficViolationStatusDto.pending,
      'confirmed': TrafficViolationStatusDto.confirmed,
      'rejected': TrafficViolationStatusDto.rejected,
    }.entries) {
      test('supports ${entry.key}', () {
        final dto = TrafficViolationDto.fromJson({
          ...violationJson,
          'status': entry.key,
        });
        expect(dto.status, entry.value);
      });
    }

    test('rejects an unknown status', () {
      expect(
        () => TrafficViolationDto.fromJson({
          ...violationJson,
          'status': 'approved',
        }),
        throwsA(
          isA<FormatException>().having(
            (error) => error.message,
            'message',
            contains('Unknown traffic violation status'),
          ),
        ),
      );
    });
  });

  group('DTO to existing UI model mapping', () {
    test('VehicleDto supplies demo-only display placeholders', () {
      final model = VehicleDto.fromJson(vehicleJson).toModel();

      expect(model.name, 'Car 2AB-1234');
      expect(model.type, 'Car');
      expect(model.plate, '2AB-1234');
      expect(model.colour, 'Not available');
      expect(model.year, 0);
      expect(model.expiry, 'Not available');
    });

    test('pending violation maps to the existing review state', () {
      final model = TrafficViolationDto.fromJson(violationJson).toModel();

      expect(model.id, '100');
      expect(model.title, 'Speeding');
      expect(model.date, '18 Oct 2026');
      expect(model.time, '09:42');
      expect(model.location, 'Phnom Penh');
      expect(model.status, ViolationStatus.underReview);
      expect(model.amount, 0);
    });

    test(
      'confirmed and rejected map without becoming confirmed by default',
      () {
        final confirmed = TrafficViolationDto.fromJson({
          ...violationJson,
          'status': 'confirmed',
        }).toModel();
        final rejected = TrafficViolationDto.fromJson({
          ...violationJson,
          'status': 'rejected',
        }).toModel();

        expect(confirmed.status, ViolationStatus.confirmed);
        expect(rejected.status, ViolationStatus.resolved);
      },
    );
  });

  test('ApiClient prepares requests without sending them', () {
    const client = ApiClient();
    final request = client.get(
      ApiConfig.vehiclesPath,
      queryParameters: const {'owner_id': '1'},
    );

    expect(request.method, ApiMethod.get);
    expect(request.uri.host, 'api.example.invalid');
    expect(request.uri.path, '/api/v1/vehicles');
    expect(request.uri.queryParameters, {'owner_id': '1'});
    expect(request.headers['Accept'], 'application/json');
  });
}
