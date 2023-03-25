from datetime import timedelta, timezone
import datetime
from .serializer import QRCodeSerializer, VehicleSerializer, VehicleSerializer1, AddVehicleSerializer, ParkingSessionSerializer, ParkingLotSerializer, UserSerializer
from .models import Vehicle, ParkingSession, ParkingLot
from ..users.models import CustomUser
from rest_framework import permissions, generics, status, views
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

def calculate_parking_fee(entry_time, exit_time, rate_per_hour):
        """
        Calculates the parking fee based on the entry and exit time and the rate per hour.
        """
        # entry_time = datetime.datetime.strptime(entry_time, '%Y-%m-%dT%H:%M:%S.%f%z')
        # exit_time = datetime.datetime.strptime(exit_time, '%Y-%m-%dT%H:%M:%S.%f%z')
        print(entry_time)
        print(exit_time)
        duration = exit_time - entry_time
        total_hours = duration.total_seconds() / timedelta(hours=1).total_seconds()
        total_hours = round(total_hours, 2)  # Round to 2 decimal places
        fee = total_hours * rate_per_hour
        return fee

class QRCodeEntryValidationView(views.APIView):
    queryset = ParkingSession.objects.all()
    permission_classes = [permissions.AllowAny]
    def post(self, request, format=None):
        serializer = QRCodeSerializer(data=request.data)
        if serializer.is_valid():
            parking_session = serializer.validated_data['qr_code']
            parking_session.entry_time = datetime.datetime.now(timezone.utc)
            # .strftime('%Y-%m-%dT%H:%M:%S.%f%z')
            parking_session.save()
            return Response({"message": "Entry validated successfully."}, status=status.HTTP_200_OK)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class QRCodeExitValidationView(views.APIView):
    queryset = ParkingSession.objects.all()
    permission_classes = [permissions.AllowAny]
    def post(self, request, format=None):
        serializer = QRCodeSerializer(data=request.data)
        if serializer.is_valid():
            parking_session = serializer.validated_data['qr_code']
            # Set exit time
            # parking_session.exit_time = datetime.datetime.now(timezone.utc)
            parking_session.exit_time = datetime.datetime(year=2023, month=3, day=26, hour=10, minute=17, second=40, microsecond=435345, tzinfo=timezone.utc )
            parking_session.save()

            # Calculate parking fee
            entry_time = parking_session.entry_time
            exit_time = parking_session.exit_time
            fee = calculate_parking_fee(entry_time, exit_time, parking_session.parking_space.parking_lot.rate_per_hour)

            return Response({"message": "Exit validated successfully.", "fee": fee}, status=status.HTTP_200_OK)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)