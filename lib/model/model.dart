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
  User(
      {required this.id,
      required this.username,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.isActive,
      required this.vehicle,
      required this.session});
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
  final double revenue;
  @HiveField(6)
  final Map location;
  @HiveField(7)
  final Map parkingSpaces;
  ParkingLot(
      {required this.id,
      required this.lotName,
      required this.lotCapacity,
      required this.occupiedSpaces,
      required this.revenue,
      required this.location,
      required this.parkingSpaces});
}
