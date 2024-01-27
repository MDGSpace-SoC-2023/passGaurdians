from dj_rest_auth.serializers import LoginSerializer
from dj_rest_auth.registration.serializers import RegisterSerializer
from rest_framework import serializers
from allauth.account import app_settings as allauth_account_settings
from allauth.account.adapter import get_adapter
from django.core.exceptions import ValidationError as DjangoValidationError
from allauth.account.utils import setup_user_email
from allauth.utils import get_username_max_length
from .models import User

class NewLoginSerializer(LoginSerializer):
    #username=None
    email =serializers.EmailField(required=True,allow_blank=False)
    password=serializers.CharField(style={'input_type': 'password'})

    def validate(self, data):
        email = data.get('email')
        password = data.get('password')

        try:
            user = User.objects.get(email=email)
        except User.DoesNotExist:
            raise serializers.ValidationError("Invalid email or password.")
        
        if not user.verify_password(password):
            raise serializers.ValidationError("Invalid email or password.")
        data['user'] = user
        return data

class NewRegisterSerializer(RegisterSerializer):
    #username=None
    #first_name=serializers.CharField()
    #last_name=serializers.CharField()
    username = serializers.CharField(
        max_length=get_username_max_length(),
        min_length=allauth_account_settings.USERNAME_MIN_LENGTH,
        required=False,
    )
    email = serializers.EmailField(required=allauth_account_settings.EMAIL_REQUIRED)
    password1 = serializers.CharField(write_only=True)
    password2 = serializers.CharField(write_only=True)
    salt = serializers.CharField(write_only=True)

    def create(self, validated_data):
        password = validated_data.pop('password1')
        salt = validated_data.pop('salt', '')
        user = User.objects.create(**validated_data)
        user.set_salt(salt)
        user.set_password(password)
        user.save()
        return user
    
class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model =User
        fields='__all__'
     



    

        
        

