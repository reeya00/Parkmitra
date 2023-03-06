from django.urls import path
from .views import CreateCustomUser, RetrieveUser, ListUser, UpdateUser

urlpatterns = [
    path("register/", CreateCustomUser.as_view(), name="create_user"),
    path("retrieve/", RetrieveUser.as_view(), name="retrieve_user"),
    path("", ListUser.as_view(), name="list_user"),
    path("update/", UpdateUser.as_view(), name="update_user"),
]