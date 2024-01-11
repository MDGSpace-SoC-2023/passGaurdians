from .views import ListCreateView,UpdateView
from django.urls import path

urlpatterns =[
    path("passwordStorage/",ListCreateView.as_view(),name='listCreate'),
    path("passwordStorage/<int:pk>/update/",UpdateView.as_view(),name='update'),
]