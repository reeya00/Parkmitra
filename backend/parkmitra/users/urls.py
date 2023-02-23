from django.urls import path
from .views import CreateCustomUser, RetrieveUser, ListUser

urlpatterns = [
    path("register/", CreateCustomUser.as_view(), name="create_user"),
    path("retrieve/", RetrieveUser.as_view(), name="retrieve_user"),
    path("", ListUser.as_view(), name="list_user"),
]