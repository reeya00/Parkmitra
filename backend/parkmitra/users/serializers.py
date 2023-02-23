from rest_framework import serializers
from rest_framework.response import Response
from rest_framework.decorators import api_view

from .models import CustomUser

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomUser
        fields = "__all__"
        

class RegisterUserSerializer(serializers.ModelSerializer):
    username = serializers.CharField(required=True)
    password = serializers.CharField(min_length=8, write_only=True)
    
    class Meta:
        model = CustomUser
        fields = '__all__'
    
    # def create_user(self, validated_data, *args, **kwargs):
    #     password = validated_data.pop('password', None)
    #     instance = self.Meta.model(**validated_data)
    #     print(instance)
    #     # if password is not None:
    #         # instance.set_password(password)
    #     self.password = make_password(password)  # hash the password
    #     print("password", password)

    #     instance.save(password=password, *args, **kwargs)
    #     print(instance)
    #     return instance
    
class RetrieveUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomUser
        fields = '__all__'
    
    # @api_view(['GET'])
    # def retrieve_user(self, request):
    #     token = request.headers.get('Authorization').split(' ')[1]
    #     decoded_token = jwt.decode(token, None, None)
    #     user_id = decoded_token['user_id']
    #     user = CustomUser.objects.get(id=user_id)
    #     # username = user.username 
    #     print(user, "called from serializer")
    #     return user