from django.urls import path,include
from .views import get_csrf_token, NewLoginView,NewRegisterView,getUserInfo,GoogleLogin,UserRedirectView
from dj_rest_auth.views import LogoutView, UserDetailsView

urlpatterns = [
    path('auth/', include('dj_rest_auth.urls')),
    path('auth/registration/',include('dj_rest_auth.registration.urls')),
    path('accounts/', include('allauth.urls')),
    path("register/", NewRegisterView.as_view(), name="rest_register"),
    path("login/", NewLoginView.as_view(), name="rest_login"),
    path("logout/", LogoutView.as_view(), name="rest_logout"),
    path("userdetails/", UserDetailsView.as_view(), name="rest_user_details"),
    path("get-csrf-token/",get_csrf_token,name='get_csrf_token'),
    path("userInfo/",getUserInfo.as_view(),name='userInfo'),
    path("google/login/", GoogleLogin.as_view(), name="google_login"),
    path("redirect/", view=UserRedirectView.as_view(), name="redirect"),
]
