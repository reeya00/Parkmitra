from django.urls import path
from .views import CreateCustomUser

urlpatterns = [
    path("register/", CreateCustomUser.as_view(), name="create_user"),
]