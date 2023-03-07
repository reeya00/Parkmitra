# Generated by Django 4.1.7 on 2023-03-01 19:15

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):
    dependencies = [
        ("parking", "0005_alter_parkingsession_parking_spot"),
    ]

    operations = [
        migrations.RemoveField(
            model_name="parkinglot",
            name="hourly_rate",
        ),
        migrations.RemoveField(
            model_name="parkingsession",
            name="parking_spot",
        ),
        migrations.RemoveField(
            model_name="parkingsession",
            name="user",
        ),
        migrations.RemoveField(
            model_name="parkingspace",
            name="occupied_by",
        ),
        migrations.RemoveField(
            model_name="parkingspace",
            name="parking_lot",
        ),
        migrations.RemoveField(
            model_name="vehicle",
            name="owner",
        ),
        migrations.AddField(
            model_name="parkingsession",
            name="parking_space",
            field=models.ForeignKey(
                null=True,
                on_delete=django.db.models.deletion.CASCADE,
                to="parking.parkingspace",
            ),
        ),
        migrations.RemoveField(
            model_name="parkinglot",
            name="parking_spaces",
        ),
        migrations.AddField(
            model_name="parkinglot",
            name="parking_spaces",
            field=models.ForeignKey(
                blank=True,
                null=True,
                on_delete=django.db.models.deletion.SET_NULL,
                to="parking.parkingspace",
            ),
        ),
    ]