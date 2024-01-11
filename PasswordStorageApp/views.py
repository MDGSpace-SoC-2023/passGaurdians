from .serializers import PasswordStorageSerializer
from .models import PasswordStorage
from rest_framework import generics
# Create your views here.


class PasswordStorageView(generics.ListCreateAPIView):
    serializer_class=PasswordStorageSerializer
    queryset=PasswordStorage.objects.all()


