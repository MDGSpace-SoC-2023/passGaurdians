# Generated by Django 5.0 on 2024-01-26 09:28

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('authentication', '0003_alter_user_salt'),
    ]

    operations = [
        migrations.AlterField(
            model_name='user',
            name='salt',
            field=models.CharField(blank=True, default='b030ccad65f5c3dff7d517c83383df3c', max_length=32),
        ),
    ]