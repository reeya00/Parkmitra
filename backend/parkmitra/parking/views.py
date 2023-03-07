from .serializer import VehicleSerializer, VehicleSerializer1, AddVehicleSerializer, ParkingSessionSerializer, ParkingLotSerializer, UserSerializer
from .models import Vehicle, ParkingSession, ParkingLot
from ..users.models import CustomUser
from rest_framework import permissions, generics, status
from rest_framework.response import Response


class VehicleRetrieve(generics.RetrieveUpdateDestroyAPIView):
    queryset = Vehicle.objects.all()
    serializer_class = VehicleSerializer1

class VehicleList(generics.ListAPIView):
    queryset = Vehicle.objects.all()
    serializer_class = VehicleSerializer

    def get_queryset(self):
        return Vehicle.objects.all()

class AddVehicle(generics.CreateAPIView):
    permission_classes = [permissions.IsAuthenticated]
    serializer_class = AddVehicleSerializer

    def create_vehicle(request):
        serializer = AddVehicleSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save(owner=request.user)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class ListSession(generics.ListAPIView):
    queryset = ParkingSession.objects.all()
    serializer_class = ParkingSessionSerializer

class CreateSession(generics.CreateAPIView):
    permission_classes = [permissions.IsAuthenticated]
    queryset = ParkingSession.objects.all()
    serializer_class = ParkingSessionSerializer

class ListParkingLots(generics.ListAPIView):
    permission_classes = [permissions.AllowAny]
    serializer_class = ParkingLotSerializer
    queryset = ParkingLot.objects.all()

class UserDetailView(generics.RetrieveAPIView):
    permission_classes = [permissions.IsAuthenticated]
    serializer_class = UserSerializer
    queryset = CustomUser.objects.all()
    def get_object(self):
        return self.request.user