from dj_rest_auth.serializers import LoginSerializer
from dj_rest_auth.registration.serializers import RegisterSerializer
from rest_framework import serializers
from allauth.account import app_settings as allauth_account_settings
from allauth.account.adapter import get_adapter
from django.core.exceptions import ValidationError as DjangoValidationError
from allauth.account.utils import setup_user_email
from allauth.utils import get_username_max_length
import secrets
from .models import User

class NewLoginSerializer(LoginSerializer):
    #username=None
    email =serializers.EmailField(required=True,allow_blank=False)
    password=serializers.CharField(style={'input_type': 'password'})

    def validate(self, attrs):
        email = attrs.get('email')
        password = attrs.get('password')

        user = User.objects.filter(email=email).first()

        if user:
            if user.verify_password(password):
                return attrs
            else:
                raise serializers.ValidationError({'detail': 'Incorrect password.'})
        else:
            raise serializers.ValidationError({'detail': 'User not found.'})

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
    salt = serializers.CharField(max_length=32, read_only=True)

    def validate(self, data):
        data = super().validate(data)
        data['salt'] = secrets.token_hex(16)
        return data
    
    # def save(self, request):
    #     adapter = get_adapter()
    #     user = adapter.new_user(request)
    #     self.cleaned_data = self.get_cleaned_data()
    #     adapter.save_user(request, user, self)
    #     self.custom_signup(request, user)
    #     setup_user_email(request, user, [])
    #     return user
        
        

