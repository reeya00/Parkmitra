import 'package:hive/hive.dart';
part 'model.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String username;
  @HiveField(2)
  final String firstName;
  @HiveField(3)
  final String lastName;
  @HiveField(4)
  final String email;
  @HiveField(5)
  final bool isActive;
  @HiveField(6)
  final Map vehicle;
  @HiveField(7)
  final Map session;
  @HiveField(8)
  final String accessToken;
  @HiveField(9)
  final String refreshToken;
  User(
      {required this.id,
      required this.username,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.isActive,
      required this.vehicle,
      required this.session,
      required this.accessToken,
      required this.refreshToken});
}

@HiveType(typeId: 1)
class ParkingLot extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String lotName;
  @HiveField(2)
  final int lotCapacity;
  @HiveField(3)
  final List occupiedSpaces;
  @HiveField(5)
  final double rate;
  @HiveField(6)
  final double lat;
  @HiveField(7)
  final double lng;
  @HiveField(8)
  final Map parkingSpaces;
  @HiveField(9)
  final String address;
  ParkingLot(
      {required this.id,
      required this.lotName,
      required this.lotCapacity,
      required this.occupiedSpaces,
      required this.rate,
      required this.lat,
      required this.lng,
      required this.parkingSpaces,
      required this.address});
}
