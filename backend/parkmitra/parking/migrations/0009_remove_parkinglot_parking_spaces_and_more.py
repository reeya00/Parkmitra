# Generated by Django 4.1.7 on 2023-03-06 05:42

from django.db import migrations, models


class Migration(migrations.Migration):
    dependencies = [
        ("parking", "0008_remove_parkinglot_lot_location_parkinglot_lat_and_more"),
    ]

    operations = [
        migrations.RemoveField(
            model_name="parkinglot",
            name="parking_spaces",
        ),
        migrations.AddField(
            model_name="parkinglot",
            name="parking_spaces",
            field=models.ManyToManyField(to="parking.parkingspace"),
        ),
    ]
