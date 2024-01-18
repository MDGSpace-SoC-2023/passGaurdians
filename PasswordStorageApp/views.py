from .serializers import PasswordStorageSerializer
from .models import PasswordStorage
from rest_framework import generics
from rest_framework.permissions import IsAuthenticated
from rest_framework.authentication import TokenAuthentication,BaseAuthentication,SessionAuthentication,BasicAuthentication
from django.http import JsonResponse
from django.middleware.csrf import get_token
# Create your views here.


class ListCreateView(generics.ListCreateAPIView):
    serializer_class=PasswordStorageSerializer
    queryset=PasswordStorage.objects.all()
    authentication_classes=[TokenAuthentication]
    permission_classes=[IsAuthenticated]

    def dispatch(self, request, *args, **kwargs):
        print(request.headers)
        return super().dispatch(request, *args, **kwargs)
    
    def get_queryset(self):
        return PasswordStorage.objects.filter(user=self.request.user)
    
    def perform_create(self, serializer):
        serializer.save(user=self.request.user) 

class UpdateView(generics.RetrieveUpdateDestroyAPIView):
    serializer_class=PasswordStorageSerializer
    queryset=PasswordStorage.objects.all()
    authentication_classes=[TokenAuthentication]
    permission_classes=[IsAuthenticated]
    
    def get_queryset(self):
        return PasswordStorage.objects.filter(user=self.request.user)

    # def get_object(self,request,*args,**kwargs):
    #     pk=self.kwargs.get('pk')
    #     obj=PasswordStorage.objects.get(pk=pk)
        #return obj

# def get_csrf_token(request):
#     csrf_token = get_token(request)
#     response = JsonResponse({'csrf_token': csrf_token})
#     response['X-CSRFToken'] = csrf_token  # Set the CSRF token in the response header
#     return response

