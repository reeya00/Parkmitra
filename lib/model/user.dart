import 'package:hive/hive.dart';
part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject{
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String username;
  @HiveField(2)
  final String first_name;
  @HiveField(3)
  final String last_name;
  @HiveField(4)
  final String email;
  @HiveField(5)
  final bool is_active;
  @HiveField(6)
  final Map vehicle;
  @HiveField(7)
  final Map session;
  User({this.id, this.username, this.first_name, this.last_name, this.email, this.is_active, this.vehicle, this.session});
}
@HiveType(typeId: 1)
class ParkingLot extends HiveObject{
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String lot_name;
  @HiveField(2)
  final int lot_capacity;
  @HiveField(3)
  final String occuied_spaces;
  @HiveField(5)
  final bool is_active;
  @HiveField(6)
  final Map vehicle;
  @HiveField(7)
  final Map session;
  User({this.id, this.username, this.first_name, this.last_name, this.email, this.is_active, this.vehicle, this.session});
}

