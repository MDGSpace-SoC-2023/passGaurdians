from .serializers import PasswordStorageSerializer,pkSerializer
from .models import PasswordStorage
from rest_framework import generics
from rest_framework.permissions import IsAuthenticated
from rest_framework.authentication import TokenAuthentication
from rest_framework.views import APIView
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

class Getpk(generics.ListAPIView):
    serializer_class=pkSerializer
    authentication_classes=[TokenAuthentication]
    permission_classes=[IsAuthenticated]

    def get_queryset(self):
        return PasswordStorage.objects.filter(user=self.request.user)