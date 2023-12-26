from django.db import models
from django.contrib.auth.models import AbstractUser
import django.contrib.auth.validators
from django.core.validators import MinLengthValidator
from django_resized import ResizedImageField

from authentication.usermanager import UserManager
# Create your models here.

def upload_to(inst,filename):
    return "/profile/"+str(filename)

class User(AbstractUser):
    username=models.CharField(max_length=100,null=True,blank=True,unique=False)
    email=models.EmailField(max_length=254,null=False,blank=False 
                            #validators=[django.contrib.auth.validators.UnicodeUsernameValidator()], 
                            ,unique=True)
    objects =UserManager()
    USERNAME_FIELD='email'
    REQUIRED_FIELDS=[]
    profile_picture=ResizedImageField(upload_to=upload_to,null=True,blank=True)
    password=models.CharField(max_length=128#,validators=[MinLengthValidator(limit_value=8,message="Password must be atleast 8 characters long.")]
                              )
   
