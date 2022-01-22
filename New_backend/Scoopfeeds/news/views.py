from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import AllowAny
from news.pagination import PaginationHandlerMixin
from news.models import News
from news.serializers import NewsSerializer
from rest_framework.pagination import PageNumberPagination

from news.services import valid_news_type, start_sceduler_jobs

start_sceduler_jobs()


class BasicPagination(PageNumberPagination):
    page_size_query_param = 'limit'


class NewsSearch(APIView, PaginationHandlerMixin):
    pagination_class = BasicPagination
    serializer_class = NewsSerializer

    def get(self, request):
        news_type = request.GET.get('type').lower()
        if valid_news_type(news_type):
            queryset = News.objects.filter(news_type=news_type).order_by('id')
            page = self.paginate_queryset(queryset)
            if page is not None:
                serializer = self.get_paginated_response(
                    self.serializer_class(page, many=True).data)
            else:
                serializer = self.serializer_class(queryset, many=True)
            return Response(serializer.data)
