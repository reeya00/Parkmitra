from django.db import models
from django.conf import settings

user = settings.AUTH_USER_MODEL

class Vehicle(models.Model):
    class VechicleTypeChoices(models.TextChoices):
        CAR = "CAR", "Car"
        BIKE = "BIKE", "Bike"
        JEEP = "JEEP", "Jeep"
        VAN = "VAN", "Van"
        SCOOTER = "SCOOTER", "Scooter"
    
    owner = models.ForeignKey(user, on_delete=models.CASCADE, null=True, blank=False)
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
    
class ParkingSpace(models.Model):
    # parking_lot = models.ForeignKey(ParkingLot, on_delete=models.CASCADE)
    is_occupied = models.BooleanField()
    occupied_by = models.ForeignKey(user, on_delete=models.DO_NOTHING, blank=True, null=True)
    rate_per_hour = models.IntegerField()

    def check_occupancy(self):
        return self.is_occupied
    
    
class ParkingLot(models.Model):
    lot_name = models.CharField(max_length=32)
    lot_location = models.ForeignKey(Location, on_delete=models.DO_NOTHING)
    lot_capacity = models.IntegerField()
    occupied_spaces = models.IntegerField()
    revenue = models.IntegerField()
    manager = models.CharField(max_length=32)
    parking_spaces = models.ForeignKey(ParkingSpace, on_delete=models.SET_NULL, blank=True, null=True)

    def is_availbale(self):
        return False if (self.occupied_spaces >= self.lot_capacity) else True

class ParkingSession(models.Model):
    user = models.ForeignKey(user, on_delete=models.CASCADE, blank=False, null=True)
    vehicle = models.ForeignKey(Vehicle, on_delete=models.CASCADE, blank=False, null=True)
    parking_space = models.ForeignKey(ParkingSpace, on_delete=models.CASCADE, blank=False, null=True)
    entry_time = models.DateTimeField()
    exit_time = models.DateTimeField(null=True, blank=True)

    def calculate_costs(self):
        pass