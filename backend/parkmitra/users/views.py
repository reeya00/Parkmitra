from rest_framework import status, permissions
from rest_framework.response import Response
from rest_framework.views import APIView
from .serializers import RegisterUserSerializer

class CreateCustomUser(APIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        reg_serializer = RegisterUserSerializer(data=request.data)
        if(reg_serializer.is_valid()):
            newuser = reg_serializer.save()
            if newuser:
                return Response(status=status.HTTP_201_CREATED)
            else:
                return Exception
        return Response(reg_serializer.errors, status=status.HTTP_400_BAD_REQUEST)
