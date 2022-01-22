from apscheduler.schedulers.background import BackgroundScheduler
import atexit
import logging
from news.exceptions import WrongQueryParamsExeption
from news.scrap_news import scrap_news
from news.variables import BATCH_REHIT_TIME, BATCH_TO_NEWS_MAPPING, NEWS_URL

logger = logging.getLogger(__name__)


def start_sceduler_jobs():
    sched = BackgroundScheduler(daemon=True)
    for job in list(BATCH_REHIT_TIME.keys()):
        create_scheduler_job(sched, job)
    sched.start()
    atexit.register(lambda: sched.shutdown())


def valid_news_type(type):
    if type in list(NEWS_URL.keys()):
        return True
    raise WrongQueryParamsExeption()


def process_news(batch):
    logger.info(f'Scheduler is alive for {batch} !!!')
    for news_type in BATCH_TO_NEWS_MAPPING[batch]:
        scrap_news(news_type)


def create_scheduler_job(schedular, batch):
    schedular.add_job(process_news, 'interval', args=[batch], minutes=BATCH_REHIT_TIME[batch])



    
