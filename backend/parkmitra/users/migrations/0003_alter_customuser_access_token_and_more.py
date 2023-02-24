# Generated by Django 4.1.7 on 2023-02-23 19:21

from django.db import migrations, models


class Migration(migrations.Migration):
    dependencies = [
        ("users", "0002_customuser_access_token_customuser_refresh_token"),
    ]

    operations = [
        migrations.AlterField(
            model_name="customuser",
            name="access_token",
            field=models.CharField(blank=True, max_length=256, null=True),
        ),
        migrations.AlterField(
            model_name="customuser",
            name="refresh_token",
            field=models.CharField(blank=True, max_length=256, null=True),
        ),
    ]
