from django.urls import path
from news.views import NewsSearch

urlpatterns = [
    path('news/', NewsSearch.as_view(), name='NewsSearch'),
]