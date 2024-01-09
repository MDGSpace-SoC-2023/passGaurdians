from rest_framework import serializers

class PasswordStorageSerializer(serializers.Serializer):
    title=serializers.CharField(max_length=100,required=True,)
    username=serializers.CharField(max_length=100,required=False)
    password=serializers.CharField(max_length=254,required=True)
    website=serializers.URLField(required=False)
    details=serializers.CharField(max_length= 300,required=False)
