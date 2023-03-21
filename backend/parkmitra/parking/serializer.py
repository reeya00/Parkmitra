from rest_framework import serializers
from .models import Vehicle, ParkingSession, ParkingLot, ParkingSpace
from ..users.models import CustomUser
from django.conf import settings

class VehicleSerializer1(serializers.ModelSerializer):
    class Meta:
        model = Vehicle
        fields = "__all__" # ["vehicle_type", "brand_name", "] use this when you need custom things

class VehicleSerializer(serializers.ModelSerializer):
    class Meta:
        model = Vehicle
        exclude = ["plate_number"] # ["vehicle_type", "brand_name", "] use this when you need custom things

class AddVehicleSerializer(serializers.ModelSerializer):
    class Meta:
        model = Vehicle
        fields = '__all__'
    
    # def add_vehicle(self, validated_data):
    #     owner = validated_data.pop('owner')
    #     user = CustomUser.objects.get(id=owner)
    #     vehicle = Vehicle.objects.create(**validated_data)
    #     user.vehicles.add(vehicle)
    #     return vehicle
    
class ParkingSessionSerializer(serializers.ModelSerializer):
    class Meta:
        model = ParkingSession
        fields = '__all__'
    
    def add_session(self, validated_data):
        parking_lot_id = validated_data.pop('parking_lot')
        parking_lot = ParkingLot.objects.get(pk=parking_lot_id)
        parking_spaces = parking_lot.spaces.all()
        
        for parking_space in parking_spaces:
            if not parking_space.is_occupied:
                parking_space_id = parking_space.id
        
        # space = ParkingSpace.objects.get(pk=validated_data['parking_space'])
        # space.is_occupied = True
        # space.occupied_by = validated_data['user']
        # space.save()
        instance = self.Meta.model(**validated_data)
        instance.save()
        return instance

class ParkingSpaceSerializer(serializers.ModelSerializer):
    class Meta:
        model = ParkingSpace
        fields = '__all__'

class ParkingLotSerializer(serializers.ModelSerializer):
    parking_spaces = serializers.SerializerMethodField()
    class Meta:
        model = ParkingLot
        fields = '__all__' 
    
    def get_parking_spaces(self, obj):
        spaces = obj.spaces.all()
        return [ParkingSpaceSerializer(space).data for space in spaces]

class UserSerializer(serializers.ModelSerializer):
    vehicle = serializers.SerializerMethodField()
    session = serializers.SerializerMethodField()

    def get_vehicle(self, obj):
        vehicles = obj.vehicles.all()
        return [VehicleSerializer(vehicle).data for vehicle in vehicles]

    def get_session(self, obj):
        sessions = obj.sessions.all()
        return [ParkingSessionSerializer(session).data for session in sessions]

    class Meta:
        model = CustomUser
        fields = ('id', 'username', 'first_name', 'last_name', 'email', 'is_active', 'vehicle', 'session')

class QRCodeSerializer(serializers.Serializer):
    qr_code = serializers.CharField()
    def validate_qr_code(self, value):
        try:
            parking_space_id = int(value)
        except ValueError:
            raise serializers.ValidationError("Invalid QR code")
        try:
            parking_session = ParkingSession.objects.get(parking_space_id=parking_space_id)
        except ParkingSession.DoesNotExist:
            raise serializers.ValidationError("Invalid QR code")

        return parking_session
    
