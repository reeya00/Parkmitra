from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from django.contrib import admin
from parkmitra.users.models import CustomUser

class UserAdmin(BaseUserAdmin):
    pass

admin.site.register(CustomUser, UserAdmin)