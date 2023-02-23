from django.contrib.auth.models import AbstractUser
from django.db import models

class CustomUser(AbstractUser):
    access_token = models.CharField(max_length=256, null=True, blank=False)
    refresh_token = models.CharField(max_length=256, null=True, blank=False)
