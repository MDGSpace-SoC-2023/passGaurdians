from rest_framework import serializers
from .models import PasswordStorage
from authentication.models import  User

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model =User
        fields='__all__'


class PasswordStorageSerializer(serializers.ModelSerializer):
    user=UserSerializer(read_only=True)
    class Meta:
        model=PasswordStorage
        fields=['title','username','password','website','details','user']

    """title=serializers.CharField(max_length=100,required=True,)
    username=serializers.CharField(max_length=100,required=False)
    password=serializers.CharField(max_length=254,required=True)
    website=serializers.URLField(required=False)
    details=serializers.CharField(max_length= 300,required=False)
"""

