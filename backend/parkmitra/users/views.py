from rest_framework import status, permissions, generics
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework_simplejwt.authentication import JWTAuthentication
from rest_framework_simplejwt.tokens import RefreshToken
from .serializers import RegisterUserSerializer, RetrieveUserSerializer, UserSerializer
from django.contrib.auth.hashers import make_password
from .models import CustomUser

class ListUser(generics.ListAPIView):
    serializer_class = UserSerializer
    queryset = CustomUser.objects.all()


class CreateCustomUser(APIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        data = request.data
        serializer = RegisterUserSerializer(data=data)
        if serializer.is_valid():
            password = make_password(data['password']) # hash the password
            serializer.save(password=password)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class RetrieveUser(APIView):
    permission_classes = [permissions.IsAuthenticated]
    queryset = CustomUser.objects.all()
    serializer_class = RetrieveUserSerializer
    authentication_classes = [JWTAuthentication]

    def get(self, request, *args, **kwargs):
        user = request.user
        serializer = self.serializer_class(user)
        return Response(serializer.data, status=status.HTTP_200_OK)
    
    # def get(self, request):
    #     retrieve_serializer = RetrieveUserSerializer(request)
    #     return Response(status=status.HTTP_200_OK)
        
    
    # @api_view(['GET'])
    # def retrieve_user(self, request):
    #     token = request.headers.get('Authorization').split(' ')[1]
    #     decoded_token = jwt.decode(token, None, None)
    #     user_id = decoded_token['user_id']
    #     user = CustomUser.objects.get(id=user_id)
    #     # username = user.username 
    #     print(user, "called from serializer")
    #     return Response(user)


class UpdateUser(generics.UpdateAPIView):
    serializer_class = UserSerializer
    permission_classes = [permissions.IsAuthenticated]
    authentication_classes = [JWTAuthentication]
    queryset = CustomUser.objects.all()
    
    def get_object(self):
        queryset = self.filter_queryset(self.get_queryset())
        # make sure to catch 404's below
        obj = queryset.get(pk=self.request.user.id)
        self.check_object_permissions(self.request, obj)
        return obj
    
    def patch(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(serializer.data)
    