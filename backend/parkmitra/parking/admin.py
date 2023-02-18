from django.contrib import admin
from .models import Vehicle

class VehicleAdmin(admin.ModelAdmin):
    list_display = ("plate_number", "vehicle_type")
    list_filter = [
        "vehicle_type"
    ]


admin.site.register(Vehicle, VehicleAdmin)