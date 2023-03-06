from rest_framework import serializers
from .models import Vehicle, ParkingSession, ParkingLot, ParkingSpace
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
    
    def add_vehicle(self, validated_data):
        instance = self.Meta.model(**validated_data)
        instance.save()
        return instance
    
class ParkingSessionSerializer(serializers.ModelSerializer):
    class Meta:
        model = ParkingSession
        fields = '__all__'
    
    def add_session(self, validated_data):
        instance = self.Meta.model(**validated_data)
        instance.save()
        return instance

class ParkingSpaceSerializer(serializers.ModelSerializer):
    class Meta:
        model = ParkingSpace
        fields = '__all__'

class ParkingLotSerializer(serializers.ModelSerializer):
    parking_spaces = ParkingSpaceSerializer(many=True, read_only=True)
    class Meta:
        model = ParkingLot
        fields = '__all__' 

