from django.db import models
from django.conf import settings

class Vehicle(models.Model):
    class VechicleTypeChoices(models.TextChoices):
        CAR = "CAR", "Car"
        BIKE = "BIKE", "Bike"
        JEEP = "JEEP", "Jeep"
        VAN = "VAN", "Van"
    
    owner = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, null=True, blank=False)
    vehicle_type = models.CharField(max_length=32, choices=VechicleTypeChoices.choices)
    brand_name = models.CharField(max_length=32) #might make a new table for this and store as a foreign key
    vehicle_model = models.CharField(max_length=16)
    color = models.CharField(max_length=16)
    plate_number = models.CharField(max_length=32)
    
    def __str__(self):
        return f"{self.vehicle_model} {self.plate_number}"
    
