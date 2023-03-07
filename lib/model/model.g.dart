// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as int,
      username: fields[1] as String,
      firstName: fields[2] as String,
      lastName: fields[3] as String,
      email: fields[4] as String,
      isActive: fields[5] as bool,
      vehicle: (fields[6] as Map).cast<dynamic, dynamic>(),
      session: (fields[7] as Map).cast<dynamic, dynamic>(),
      accessToken: fields[8] as String,
      refreshToken: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.firstName)
      ..writeByte(3)
      ..write(obj.lastName)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.isActive)
      ..writeByte(6)
      ..write(obj.vehicle)
      ..writeByte(7)
      ..write(obj.session)
      ..writeByte(8)
      ..write(obj.accessToken)
      ..writeByte(9)
      ..write(obj.refreshToken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ParkingLotAdapter extends TypeAdapter<ParkingLot> {
  @override
  final int typeId = 1;

  @override
  ParkingLot read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ParkingLot(
      id: fields[0] as int,
      lotName: fields[1] as String,
      lotCapacity: fields[2] as int,
      occupiedSpaces: (fields[3] as List).cast<dynamic>(),
      rate: fields[5] as double,
      lat: fields[6] as double,
      lng: fields[7] as double,
      parkingSpaces: (fields[8] as Map).cast<dynamic, dynamic>(),
      address: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ParkingLot obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.lotName)
      ..writeByte(2)
      ..write(obj.lotCapacity)
      ..writeByte(3)
      ..write(obj.occupiedSpaces)
      ..writeByte(5)
      ..write(obj.rate)
      ..writeByte(6)
      ..write(obj.lat)
      ..writeByte(7)
      ..write(obj.lng)
      ..writeByte(8)
      ..write(obj.parkingSpaces)
      ..writeByte(9)
      ..write(obj.address);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParkingLotAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
