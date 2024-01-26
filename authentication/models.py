from django.db import models
from django.contrib.auth.models import AbstractUser
import django.contrib.auth.validators
from django.core.validators import MinLengthValidator
from django_resized import ResizedImageField
import secrets
import bcrypt
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
    password=models.CharField(max_length=128)
    salt = models.CharField(max_length=32, null=False, blank=False, default=secrets.token_hex(16))

    def __str__(self):
        return self.email

    def verify_password(self, entered_password):
        if not self.salt:
            return False 
        hashed_password=bcrypt.hashpw(entered_password.encode('utf-8'), self.salt.encode('utf-8')).decode('utf-8')
        return self.check_password(hashed_password)
 
    def set_salt(self, salt):
        self.salt = salt