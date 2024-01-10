from typing import Any
from django.shortcuts import render
from .serializers import PasswordStorageSerializer
from django.views import View
from django.http import HttpResponse
# Create your views here.
class PasswordStorageView(View):
    serializer_class=PasswordStorageSerializer
    def get(request , *args , **kwargs):
        return HttpResponse
