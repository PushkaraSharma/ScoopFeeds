from django.db import models
from django.db.models.fields import DateField

# Create your models here.

class News(models.Model):
    heading = models.CharField(max_length=1000, default='')
    summary = models.TextField(default='')
    image_url = models.TextField(default='')
    news_type = models.CharField(max_length=225, default='')
    date = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.heading