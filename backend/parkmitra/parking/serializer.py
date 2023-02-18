from rest_framework import serializers
from .models import Vehicle

class VehicleSerializer(serializers.ModelSerializer):
    class Meta:
        model = Vehicle
        fields = "__all__" # ["vehicle_type", "brand_name", "] use this when you need custom things

class VehicleSerializer1(serializers.ModelSerializer):
    class Meta:
        model = Vehicle
        exclude = ["plate_number"] # ["vehicle_type", "brand_name", "] use this when you need custom things
