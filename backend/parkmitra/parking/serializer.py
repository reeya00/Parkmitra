from rest_framework import serializers
from .models import Vehicle, ParkingSession
from django.db import models
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
    # class VechicleTypeChoices(models.TextChoices):
    #     CAR = "CAR", "Car"
    #     BIKE = "BIKE", "Bike"
    #     JEEP = "JEEP", "Jeep"
    #     VAN = "VAN", "Van"

    # vehicle_type = serializers.ChoiceField(required=True, choices=VechicleTypeChoices.choices)
    # brand_name = serializers.CharField(required=True)
    # vehicle_model = serializers.CharField(required=True)
    # color = serializers.CharField()
    # plate_number = serializers.CharField(required=True)
    # owner = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, null=True, blank=False)

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