from .views import ListCreateView,UpdateView,Getpk
from django.urls import path

urlpatterns =[
    path("create/",ListCreateView.as_view(),name='listCreate'),
    path("update/<int:pk>/",UpdateView.as_view(),name='update'),
    path("pk/",Getpk.as_view,name="pk"),
]