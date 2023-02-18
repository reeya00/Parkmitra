from django.contrib.auth.models import AbstractUser

class CustomUser(AbstractUser):
    def create_user(self):
        pass
