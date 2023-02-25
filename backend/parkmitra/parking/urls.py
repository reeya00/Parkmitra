from django.urls import path
from .views import VehicleRetrieve, VehicleList, AddVehicle

urlpatterns = [
    path("vehicle/", VehicleList.as_view()),
    path("vehicle/<pk>/", VehicleRetrieve.as_view()),
    path("addvehicle/", AddVehicle.as_view()),
]