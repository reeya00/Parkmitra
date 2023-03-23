from django.urls import path
from .views import VehicleRetrieve, VehicleList, AddVehicle, ListSession, CreateSession, ListParkingLots, UserDetailView, QRCodeEntryValidationView, QRCodeExitValidationView

urlpatterns = [
    path("vehicle/", VehicleList.as_view()),
    path("vehicle/<pk>/", VehicleRetrieve.as_view()),
    path("addvehicle/", AddVehicle.as_view()),
    path("sessions/", ListSession.as_view()),
    path("sessions/add", CreateSession.as_view()),
    path("parkinglots/", ListParkingLots.as_view()),
    path("userdata/", UserDetailView.as_view()),
    path("verifyentry/", QRCodeEntryValidationView.as_view()),
    path("verifyexit/", QRCodeExitValidationView.as_view()),
]