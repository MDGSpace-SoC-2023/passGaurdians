from dj_rest_auth.views import LoginView
from dj_rest_auth.registration.views import RegisterView
from .serializers import NewLoginSerializer,NewRegisterSerializer
from django.http import JsonResponse
from django.middleware.csrf import get_token
from allauth.socialaccount.providers.google.views import GoogleOAuth2Adapter
from allauth.socialaccount.providers.oauth2.client import OAuth2Client
from dj_rest_auth.registration.views import SocialLoginView
import secrets
# Create your views here.

class NewLoginView(LoginView):
    serializer_class=NewLoginSerializer

class NewRegisterView(RegisterView):
    serializer_class=NewRegisterSerializer

    def perform_create(self, serializer):
        salt = secrets.token_hex(16)
        password = serializer.validated_data.get('password1', '')
        user = serializer.save(self.request)
        user.salt = salt
        user.set_password(password)
        user.save()

def get_csrf_token(request):
    csrf_token = get_token(request)
    response = JsonResponse({'csrf_token': csrf_token})
    response['X-CSRFToken'] = csrf_token 
    return response



class GoogleLogin(SocialLoginView):
    adapter_class = GoogleOAuth2Adapter
    #callback_url = CALLBACK_URL_YOU_SET_ON_GOOGLE
    client_class = OAuth2Client
