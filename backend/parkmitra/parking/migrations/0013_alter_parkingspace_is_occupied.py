# Generated by Django 4.1.7 on 2023-03-24 15:00

from django.db import migrations, models


class Migration(migrations.Migration):
    dependencies = [
        ("parking", "0012_alter_parkingspace_parking_lot"),
    ]

    operations = [
        migrations.AlterField(
            model_name="parkingspace",
            name="is_occupied",
            field=models.BooleanField(default=False),
        ),
    ]
