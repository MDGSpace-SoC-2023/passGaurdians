from dj_rest_auth.views import LoginView
from dj_rest_auth.registration.views import RegisterView
from .serializers import NewLoginSerializer,NewRegisterSerializer,UserSerializer
from django.http import JsonResponse
from django.middleware.csrf import get_token
from allauth.socialaccount.providers.google.views import GoogleOAuth2Adapter
from allauth.socialaccount.providers.oauth2.client import OAuth2Client
from dj_rest_auth.registration.views import SocialLoginView
from rest_framework import response, status,generics
from rest_framework.authtoken.models import Token
from .models import User
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from django.contrib.auth.mixins import LoginRequiredMixin
from django.views.generic import RedirectView
# Create your views here.

redirect_url="http://127.0.0.1:8000"

class NewLoginView(LoginView):
    serializer_class=NewLoginSerializer
    
    def post(self, request, *args, **kwargs):
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.validated_data['user']
        password = serializer.validated_data['password']
        
        if not user.salt:
            return response.Response({"message": "Invalid salt"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        if user.verify_password(password):
            token, created = Token.objects.get_or_create(user=user)
            return response.Response({"message": "Login successful", "token": token.key}, status=status.HTTP_200_OK)
        else:
            return response.Response({"message": "Invalid credentials"}, status=status.HTTP_401_UNAUTHORIZED)

class NewRegisterView(RegisterView):
    serializer_class=NewRegisterSerializer

    def perform_create(self, serializer):
        salt = serializer.validated_data.get('salt', '')
        user = serializer.save(self.request)
        user.salt = salt
        user.set_password(serializer.validated_data.get('password1', ''))
        user.save()
    
    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = self.perform_create(serializer)
        headers = self.get_success_headers(serializer.data)
        return response.Response({"message": "Registration successful"}, status=status.HTTP_201_CREATED, headers=headers)

def get_csrf_token(request):
    csrf_token = get_token(request)
    response = JsonResponse({'csrf_token': csrf_token})
    response['X-CSRFToken'] = csrf_token 
    return response

class getUserInfo(generics.ListAPIView):
    serializer_class=UserSerializer
    authentication_classes=[TokenAuthentication]
    permission_classes=[IsAuthenticated]
    def get_queryset(self):
        return User.objects.filter(pk=self.request.user.pk)

class GoogleLogin(SocialLoginView):
    adapter_class = GoogleOAuth2Adapter
    callback_url = redirect_url
    client_class = OAuth2Client

class UserRedirectView(LoginRequiredMixin, RedirectView):
    permanent = False
    def get_redirect_url(self):
        return "redirect-url"