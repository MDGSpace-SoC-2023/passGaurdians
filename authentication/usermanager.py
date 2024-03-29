#from django.contrib.auth.base_user import BaseUserManager
from django.contrib.auth.models import AbstractUser,BaseUserManager
from django.db import models
from django.utils.translation import gettext_lazy as _
import bcrypt

class UserManager(BaseUserManager):
    use_in_migrations = True

    def _create_user(self, email, password, salt, **extra_fields):
        if not email:
            raise ValueError("Email field is required.")
        email = self.normalize_email(email)
        user = self.model(email=email, **extra_fields)
        if extra_fields.get("is_superuser") is True:
            user.salt = salt or bcrypt.gensalt()
            user.password= bcrypt.hashpw(password.encode('utf-8'), user.salt).decode('utf-8')
        else:
            user.salt = salt
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_user(self, email, password=None, salt=None, **extra_fields):
        extra_fields.setdefault("is_staff", False)
        extra_fields.setdefault("is_superuser", False)
        return self._create_user(email, password, salt, **extra_fields)

    def create_superuser(self, email, password, salt=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)

        if extra_fields.get('is_staff') is not True:
            raise ValueError('Superuser must have is_staff=True.')
        if extra_fields.get('is_superuser') is not True:
            raise ValueError('Superuser must have is_superuser=True.')

        return self._create_user(email, password, salt, **extra_fields)