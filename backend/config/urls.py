from django.contrib import admin
from django.urls import path, include
from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView
)
urlpatterns = [
    path("admin/", admin.site.urls, name='admin'),
    path('api-auth/', include('rest_framework.urls'), name='api_auth'),
    path('api/', include('parkmitra.users.api'), name='api'),
    path('user/', include('parkmitra.users.urls'), name='user'),
    
    path('', include('parkmitra.parking.urls'), name='parking'),
    
    path('api/token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
]
