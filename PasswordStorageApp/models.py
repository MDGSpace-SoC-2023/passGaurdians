from django.db import models

# Create your models here.

class PasswordStorage(models.Model):
    title=models.CharField(max_length=100,null=False,blank=False,unique=True)
    username=models.CharField(max_length=100,null=True,blank=True,unique=False)
    password=models.CharField(max_length=254,null=False,blank=False,unique=False)
    website=models.URLField(null=True,blank=True,unique=False)
    details=models.TextField(max_length= 300,null=True,blank=True,unique=False)

    def __str__(self):
        return self.title