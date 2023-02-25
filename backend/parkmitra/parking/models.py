from django.db import models
from django.conf import settings
from ..users.models import CustomUser

class Vehicle(models.Model):
    class VechicleTypeChoices(models.TextChoices):
        CAR = "CAR", "Car"
        BIKE = "BIKE", "Bike"
        JEEP = "JEEP", "Jeep"
        VAN = "VAN", "Van"
        SCOOTER = "SCOOTER", "Scooter"
    
    owner = models.ForeignKey(CustomUser, on_delete=models.CASCADE, null=True, blank=False)
    vehicle_type = models.CharField(max_length=32, choices=VechicleTypeChoices.choices)
    brand_name = models.CharField(max_length=32) #might make a new table for this and store as a foreign key
    vehicle_model = models.CharField(max_length=16)
    color = models.CharField(max_length=16)
    plate_number = models.CharField(max_length=32)
    
    def __str__(self):
        return f"{self.vehicle_model} {self.plate_number}"

class Location(models.Model):
    lat = models.FloatField()
    long = models.FloatField()
    def __str__(self) -> str:
        return f"{self.lat},{self.long}"


class ParkingLot(models.Model):
    class ParkingSpace(models.Model):
        is_occupied = models.BooleanField()
        occupied_by = models.ForeignKey(CustomUser, on_delete=models.DO_NOTHING, blank=True, null=True)
        rate_per_hour = models.IntegerField()

        def check_occupancy(self):
            return self.is_occupied
        
        def occupy(self, user: CustomUser):
            pass

        def release(self):
            pass

        def calculate_costs(self):
            pass    
    
    lot_name = models.CharField(max_length=32)
    lot_location = models.ForeignKey(Location, on_delete=models.DO_NOTHING)
    lot_capacity = models.IntegerField()
    occupied_spaces = models.IntegerField()
    hourly_rate = models.IntegerField()
    revenue = models.IntegerField()
    manager = models.CharField(max_length=32)
    parking_spaces = models.ManyToManyField('ParkingSpace')

    def is_availbale(self):
        return False if (self.occupied_spaces >= self.lot_capacity) else True
    
    # def __str__(self) -> str:
    #     return [x for x in ParkingLot.__getattribute__()]


