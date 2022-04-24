from apscheduler.schedulers.background import BackgroundScheduler
import atexit
import logging
from news.models import News
from news.exceptions import WrongQueryParamsExeption
from news.scrap_news import scrap_news
from news.variables import BATCH_REHIT_TIME, BATCH_TO_NEWS_MAPPING, DATA_DELETE_TIME, NEWS_URL

logger = logging.getLogger(__name__)


def start_scheduler_jobs():
    sched = BackgroundScheduler(daemon=True)
    for job in list(BATCH_REHIT_TIME.keys()):
        create_scraping_scheduler_job(sched, job)
    create_data_deletion_job(sched)
    sched.start()
    atexit.register(lambda: sched.shutdown())


def valid_news_type(type):
    if type in list(NEWS_URL.keys()):
        return True
    raise WrongQueryParamsExeption()


def process_news(batch):
    logger.info(f'Scheduler is alive for {batch} !!!')
    print(f'Scheduler is alive for {batch} !!!')
    for news_type in BATCH_TO_NEWS_MAPPING[batch]:
        scrap_news(news_type)


def create_scraping_scheduler_job(schedular, batch):
    schedular.add_job(process_news, 'interval', args=[batch], minutes=BATCH_REHIT_TIME[batch])


def create_data_deletion_job(schedular):
    schedular.add_job(delete_data, 'interval', days=DATA_DELETE_TIME)


def delete_data():
    for type in list(NEWS_URL.keys()):
        to_delete_objects = News.objects.filter(news_type=type).order_by("-id")[2000:]
        print(f'Number of News of type {type} to be deleted: {len(to_delete_objects)}')
        for object in to_delete_objects:
            object.delete()


#To be done Tomorrow
# - Make docker file using compose
# - Use travis to build container
# - Write few tests and run tests on travis
# - After that write terraform scripts
# - Add to travis     
