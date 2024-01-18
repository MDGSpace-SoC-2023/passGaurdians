from dj_rest_auth.views import LoginView
from dj_rest_auth.registration.views import RegisterView
from .serializers import NewLoginSerializer,NewRegisterSerializer
from django.http import JsonResponse
from django.middleware.csrf import get_token

from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated

# Create your views here.

class NewLoginView(LoginView):
    serializer_class=NewLoginSerializer
    #pagination_class=[IsAuthenticated]

class NewRegisterView(RegisterView):
    serializer_class=NewRegisterSerializer


def get_csrf_token(request):
    csrf_token = get_token(request)
    response = JsonResponse({'csrf_token': csrf_token})
    response['X-CSRFToken'] = csrf_token  # Set the CSRF token in the response header
    return response


# class MyProtectedView(APIView):
#     authentication_classes = [TokenAuthentication]
#     #permission_classes = [IsAuthenticated]

#     def get(self, request):
#         # Access the user's token
#         token = request.auth.key
#         return Response({'token': token})
