from rest_framework import serializers
from .models import CustomUser

class RegisterUserSerializer(serializers.ModelSerializer):
    username = serializers.CharField(required=True)
    password = serializers.CharField(min_length=8, write_only=True)
    
    class Meta:
        model = CustomUser
        fields = '__all__'
        extra_kwargs = {
            'password': {'write-only': True}
        }
    
    def create_user(self, validated_data):
        password = validated_data.pop('password', None)
        instance = self.Meta.model(**validated_data)

        if password is not None:
            instance.set_password(password)
        
        instance.save()
        return instance