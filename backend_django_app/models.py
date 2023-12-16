from django.db import models
from django.contrib.auth.models import AbstractUser
from django.core.validators import MinLengthValidator
from django_resized import ResizedImageField
# Create your models here.

def upload_to(inst,filename):
    return "/profile/"+str(filename)

class User(AbstractUser):
    Username=models.CharField(max_length=100)
    profile_picture=ResizedImageField(upload_to=upload_to,null=True,blank=True)
    '''password=models.CharField(
        max_length=100,
        validators=[MinLengthValidator(limit_value=8,message="Password must be atleast 8 characters long.")]
    )'''
