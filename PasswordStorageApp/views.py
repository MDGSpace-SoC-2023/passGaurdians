from .serializers import PasswordStorageSerializer
from .models import PasswordStorage
from rest_framework import generics
from django.http import JsonResponse
from django.middleware.csrf import get_token
# Create your views here.


class ListCreateView(generics.ListCreateAPIView):
    serializer_class=PasswordStorageSerializer
    queryset=PasswordStorage.objects.all()

class UpdateView(generics.RetrieveUpdateDestroyAPIView):
    serializer_class=PasswordStorageSerializer
    queryset=PasswordStorage.objects.all()

    def get_object(self,request,*args,**kwargs):
        pk=self.kwargs.get('pk')
        obj=PasswordStorage.objects.get(pk=pk)
        response =get(request)
        return obj

def get_csrf_token(request):
    csrf_token = get_token(request)
    response = JsonResponse({'csrf_token': csrf_token})
    response['X-CSRFToken'] = csrf_token  # Set the CSRF token in the response header
    return response

