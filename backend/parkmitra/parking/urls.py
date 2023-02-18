from django.urls import path
from .views import VehicleList, VehicleRetrive

urlpatterns = [
    path("vehicle/", VehicleList.as_view()),
    path("vehicle/<pk>/", VehicleRetrive.as_view()),
]
