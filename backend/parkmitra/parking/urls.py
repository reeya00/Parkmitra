from django.urls import path
from .views import VehicleRetrieve, VehicleList, AddVehicle, ListSession, CreateSession

urlpatterns = [
    path("vehicle/", VehicleList.as_view()),
    path("vehicle/<pk>/", VehicleRetrieve.as_view()),
    path("addvehicle/", AddVehicle.as_view()),
    path("sessions/", ListSession.as_view()),
    path("sessions/add", CreateSession.as_view()),
]