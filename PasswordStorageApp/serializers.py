from rest_framework import serializers
from .models import PasswordStorage

class PasswordStorageSerializer(serializers.ModelSerializer):
    class Meta:
        model=PasswordStorage
        fields=['title','username','password','website','details']
    """title=serializers.CharField(max_length=100,required=True,)
    username=serializers.CharField(max_length=100,required=False)
    password=serializers.CharField(max_length=254,required=True)
    website=serializers.URLField(required=False)
    details=serializers.CharField(max_length= 300,required=False)
"""


