from .serializer import VehicleSerializer, VehicleSerializer1
from .models import Vehicle
from rest_framework import generics
from rest_framework.permissions import IsAdminUser

class VehicleRetrive(generics.RetrieveAPIView):
    queryset = Vehicle.objects.all()
    serializer_class = VehicleSerializer

class VehicleList(generics.ListAPIView):
    queryset = Vehicle.objects.all()
    serializer_class = VehicleSerializer1

