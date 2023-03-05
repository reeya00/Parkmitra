from django.contrib.auth.models import AbstractUser
from django.db import models
from django.db import models
from ..parking.models import ParkingSession, Vehicle

class CustomUser(AbstractUser):
    sessions = models.ManyToManyField(ParkingSession, blank=True)
    vehicles = models.ManyToManyField(Vehicle, blank=True)
    