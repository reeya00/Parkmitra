from django.urls import path
from .views import VehicleRetrieve, VehicleList, AddVehicle
from rest_framework.routers import DefaultRouter
urlpatterns = [
    path("vehicle/", VehicleList.as_view()),
    path("vehicle/<pk>", VehicleRetrieve.as_view()),
    path("vehicle/add/", AddVehicle.as_view()),
]

# router = DefaultRouter()
# router.register('vehicle', VehicleList, basename="vehicle")
# urlpatterns = router.urls