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
    owner = models.ForeignKey(user, on_delete=models.CASCADE, null=True, blank=False, related_name="vehicles")
    vehicle_type = models.CharField(max_length=32, choices=VechicleTypeChoices.choices)
    brand_name = models.CharField(max_length=32) #might make a new table for this and store as a foreign key
    vehicle_model = models.CharField(max_length=16)
    color = models.CharField(max_length=16)
    plate_number = models.CharField(max_length=32)
    
    def __str__(self):
        return f"{self.vehicle_model} {self.plate_number}"    
    
class ParkingLot(models.Model):
    lot_name = models.CharField(max_length=32)
    lat = models.FloatField(blank=True, null=True)
    long = models.FloatField(blank=True, null=True)
    lot_capacity = models.IntegerField()
    occupied_spaces = models.IntegerField()
    revenue = models.IntegerField()
    manager = models.CharField(max_length=32)
    address = models.CharField(max_length=64, null=True, blank=True)
    rate_per_hour = models.FloatField()

    def is_available(self):
        return False if (self.occupied_spaces >= self.lot_capacity) else True

class ParkingSpace(models.Model):
    parking_lot = models.ForeignKey(ParkingLot, on_delete=models.CASCADE, blank=True, null=True, related_name="spaces")
    is_occupied = models.BooleanField()
    occupied_by = models.ForeignKey(user, on_delete=models.DO_NOTHING, blank=True, null=True)

    def check_occupancy(self):
        return self.is_occupied

class ParkingSession(models.Model):
    user = models.ForeignKey(user, on_delete=models.CASCADE, blank=False, null=True, related_name="sessions")
    vehicle = models.ForeignKey(Vehicle, on_delete=models.CASCADE, blank=False, null=True, related_name="sessions")
    parking_space = models.ForeignKey(ParkingSpace, on_delete=models.CASCADE, blank=False, null=True, related_name="sessions")
    entry_time = models.DateTimeField()
    exit_time = models.DateTimeField(null=True, blank=True)

    def calculate_costs(self):
        pass