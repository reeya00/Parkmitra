# Generated by Django 4.1.7 on 2023-02-25 17:02

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):
    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ("parking", "0003_location_parkingspace_parkinglot"),
    ]

    operations = [
        migrations.AddField(
            model_name="parkingspace",
            name="parking_lot",
            field=models.ForeignKey(
                default=0,
                on_delete=django.db.models.deletion.CASCADE,
                to="parking.parkinglot",
            ),
            preserve_default=False,
        ),
        migrations.AlterField(
            model_name="vehicle",
            name="vehicle_type",
            field=models.CharField(
                choices=[
                    ("CAR", "Car"),
                    ("BIKE", "Bike"),
                    ("JEEP", "Jeep"),
                    ("VAN", "Van"),
                    ("SCOOTER", "Scooter"),
                ],
                max_length=32,
            ),
        ),
        migrations.CreateModel(
            name="ParkingSession",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("entry_time", models.DateTimeField()),
                ("exit_time", models.DateTimeField(blank=True, null=True)),
                (
                    "parking_spot",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        to="parking.parkingspace",
                    ),
                ),
                (
                    "user",
                    models.ForeignKey(
                        null=True,
                        on_delete=django.db.models.deletion.CASCADE,
                        to=settings.AUTH_USER_MODEL,
                    ),
                ),
                (
                    "vehicle",
                    models.ForeignKey(
                        null=True,
                        on_delete=django.db.models.deletion.CASCADE,
                        to="parking.vehicle",
                    ),
                ),
            ],
        ),
    ]
