from dj_rest_auth.serializers import LoginSerializer
from dj_rest_auth.registration.serializers import RegisterSerializer
from rest_framework import serializers
from allauth.account import app_settings as allauth_account_settings

class NewLoginSerializer(LoginSerializer):
    username=None
    email =serializers.EmailField(required=True,allow_blank=False)
    password=serializers.CharField(style={'input_type': 'password'})

class NewRegisterSerializer(RegisterSerializer):
    username=None
    #first_name=serializers.CharField()
    #last_name=serializers.CharField()
    email = serializers.EmailField(required=allauth_account_settings.EMAIL_REQUIRED)
    password1 = serializers.CharField(write_only=True)
    password2 = serializers.CharField(write_only=True)
    """def custom_signup(self,request,user):
        user.first_name=request.data['first_name']
        user.last_name=request.data['last_name']"""

