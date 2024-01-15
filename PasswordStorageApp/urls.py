from .views import ListCreateView,UpdateView
from django.urls import path

urlpatterns =[
    path("passwordStorage/",ListCreateView.as_view(),name='listCreate'),
    path("passwordStorage/<int:pk>/update/",UpdateView.as_view(),name='update'),
    # path("csrf_token/",get_csrf_token,name='get_csrf_token'),
    #path("update/pk/",UpdateView.get_object,name="pk")
]