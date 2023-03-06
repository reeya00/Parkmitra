from .serializer import VehicleSerializer, VehicleSerializer1, AddVehicleSerializer, ParkingSessionSerializer, ParkingLotSerializer
from .models import Vehicle, ParkingSession, ParkingLot
from rest_framework import permissions, generics

class VehicleRetrieve(generics.RetrieveUpdateDestroyAPIView):
    queryset = Vehicle.objects.all()
    serializer_class = VehicleSerializer1

class VehicleList(generics.ListAPIView):
    queryset = Vehicle.objects.all()
    serializer_class = VehicleSerializer

# class VehicleList(viewsets.ViewSet):
#     permission_classes = [permissions.AllowAny]
#     queryset = Vehicle.objects.all()
    
#     def list(self, request):
#         serializer_class = VehicleSerializer1(self.queryset, many=True)
#         return Response(serializer_class.data)
    
#     def retrieve(self, request, pk=None):
#         vehicle = get_object_or_404(self.queryset, pk=pk)
#         print(vehicle)
#         serializer_class = VehicleSerializer(vehicle)
#         return Response(serializer_class.data)
     
# class VehicleList(viewsets.ModelViewSet):
#     permission_classes = [permissions.AllowAny]
#     serializer_class = VehicleSerializer
    # queryset = Vehicle.objects.all()

    # def get_object(self, queryset=None, **kwargs):
    #     item = self.kwargs.get('pk')
    #     return get_object_or_404(Vehicle, vehicle_type=item)

    def get_queryset(self):
        return Vehicle.objects.all()

class AddVehicle(generics.CreateAPIView):
    permission_classes = [permissions.AllowAny]
    serializer_class = AddVehicleSerializer


    # def post(self, request):
    #     vehicle_serializer = AddVehicleSerializer(data=request.data)
    #     if(vehicle_serializer.is_valid()):
    #         print("inside if1")
    #         vehicle = vehicle_serializer.save()
    #         if vehicle:
    #             print("inside if 2")
    #             return Response(status=status.HTTP_201_CREATED)
    #         else:
    #             print("inside exception")
    #             return Exception
    #     return Response(vehicle_serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class ListSession(generics.ListAPIView):
    queryset = ParkingSession.objects.all()
    serializer_class = ParkingSessionSerializer

class CreateSession(generics.CreateAPIView):
    permission_classes = [permissions.IsAuthenticated]
    queryset = ParkingSession.objects.all()
    serializer_class = ParkingSessionSerializer

class ListParkingLots(generics.ListAPIView):
    permission_classes = [permissions.IsAuthenticated]
    serializer_class = ParkingLotSerializer
    queryset = ParkingLot.objects.all()
