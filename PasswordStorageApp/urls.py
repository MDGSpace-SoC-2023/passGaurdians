from .views import PasswordStorageView
from django.urls import path

urlpatterns =[
    path("passwordStorage/",PasswordStorageView.as_view(),name='passwordStorage'),
]