from django.contrib import admin
from .models import Vehicle, ParkingSession
from ..users.models import CustomUser
class VehicleAdmin(admin.ModelAdmin):
    list_display = ("plate_number", "vehicle_type", "vehicle_model")
    list_filter = [
        "vehicle_type"
    ]


admin.site.register(Vehicle, VehicleAdmin)

class SessionsAdmin(admin.ModelAdmin):
    list_display = ("entry_time", "exit_time")

admin.site.register(ParkingSession, SessionsAdmin)