from django.db.models import manager
from rest_framework.response import Response
from rest_framework.serializers import Serializer
from rest_framework.views import APIView
from rest_framework.permissions import AllowAny
from news.models import News
from news.serializers import NewsSerializer

from news.services import valid_news_type, start_sceduler_jobs

start_sceduler_jobs()

class NewsSearch(APIView):
    permission_classes = [AllowAny]

    def get(self, request):
        news_type = request.GET.get('type').lower()
        if valid_news_type(news_type):
            queryset = News.objects.filter(news_type=news_type)
            response = NewsSerializer(queryset, many=True).data
            return Response(response)
