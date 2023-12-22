from dj_rest_auth.views import LoginView,LogoutView, UserDetailsView
from dj_rest_auth.registration.views import RegisterView
from .serializers import NewLoginSerializer,NewRegisterSerializer
from django.http import JsonResponse
from django.middleware.csrf import get_token
# Create your views here.

class NewLoginView(LoginView):
    serializer_class=NewLoginSerializer

class NewRegisterView(RegisterView):
    serializer_class=NewRegisterSerializer

def get_csrf_token(request):
    csrf_token = get_token(request)
    response = JsonResponse({'csrf_token': csrf_token})
    response['X-CSRFToken'] = csrf_token  # Set the CSRF token in the response header
    return response


