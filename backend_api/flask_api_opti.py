#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jun 26 22:36:15 2020

@author: pushkara
"""


from flask import Flask
import json
import background_job_process
from apscheduler.schedulers.background import BackgroundScheduler
import atexit
import pandas as pd

def process_news():
    print("Scheduler is alive!")
    background_job_process.scrap("https://www.indiatoday.in/top-stories",'top_stories.json')
    background_job_process.scrap('https://www.indiatoday.in/technology/news','tech_new.json')
    background_job_process.scrap_sports('https://www.indiatoday.in/sports','sports_new.json')
    
sched = BackgroundScheduler(daemon=True)
sched.add_job(process_news,'interval',minutes=8)
sched.start()
atexit.register(lambda: sched.shutdown())

def process_news2():
    print("Scheduler2 is alive!")
    background_job_process.scrap_gaming('https://www.gamesradar.com/news/','gaming_new.json')

sched2 = BackgroundScheduler(daemon=True)
sched2.add_job(process_news2,'interval',minutes=60)
sched2.start()
atexit.register(lambda: sched2.shutdown())

app = Flask(__name__)


@app.route('/top_stories/',methods=['GET'])
def top_stories_to_user():    
    
    data = pd.read_json('top_stories.json')
    data  = data.to_json(orient='records')
    return data



@app.route('/tech/',methods=['GET'])
def tech_to_user():    
    
    data = pd.read_json('tech_new.json')
    data  = data.to_json(orient='records')
    return data

@app.route('/sports/',methods=['GET'])
def sports_to_user():    
    
    data = pd.read_json('sports_new.json')
    data  = data.to_json(orient='records')
    return data

@app.route('/gaming/',methods=['GET'])
def gaming_to_user():    
    
    data = pd.read_json('gaming_new.json')
    data  = data.to_json(orient='records')
    return data


@app.route('/')
def index():
    return "<h1>READ_RUN</h1>"


if __name__ == "__main__":
    app.run(host='0.0.0.0',port=5000)
    
#d = scrap()
#print(d)
