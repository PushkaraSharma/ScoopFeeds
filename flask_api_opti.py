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

def process_news():
    print("Scheduler is alive!")
    background_job_process.scrap("https://www.indiatoday.in/top-stories",'data_top_stories.json')
    background_job_process.scrap('https://www.indiatoday.in/technology/news','data_tech.json')
    background_job_process.scrap_sports('https://www.indiatoday.in/sports','data_sports.json')
    
sched = BackgroundScheduler(daemon=True)
sched.add_job(process_news,'interval',minutes=10)
sched.start()
atexit.register(lambda: sched.shutdown())

def process_news2():
    print("Scheduler2 is alive!")
    background_job_process.scrap_gaming('https://www.gamesradar.com/news/','data_gaming.json')

sched2 = BackgroundScheduler(daemon=True)
sched2.add_job(process_news2,'interval',minutes=120)
sched2.start()
atexit.register(lambda: sched2.shutdown())

app = Flask(__name__)


@app.route('/top_stories/',methods=['GET'])
def top_stories_to_user():    
    
    with open('data_top_stories.json') as f:
         data = json.load(f)
    d1 = json.loads(data)
    jsonData = json.dumps(d1)
    return (jsonData)


@app.route('/tech/',methods=['GET'])
def tech_to_user():    
    
    with open('data_tech.json') as f:
         data = json.load(f)
    d1 = json.loads(data)
    jsonData = json.dumps(d1)
    return (jsonData)

@app.route('/sports/',methods=['GET'])
def sports_to_user():    
    
    with open('data_sports.json') as f:
         data = json.load(f)
    d1 = json.loads(data)
    jsonData = json.dumps(d1)
    return (jsonData)

@app.route('/gaming/',methods=['GET'])
def gaming_to_user():    
    
    with open('data_gaming.json') as f:
         data = json.load(f)
    d1 = json.loads(data)
    jsonData = json.dumps(d1)
    return (jsonData)


@app.route('/')
def index():
    return "<h1>READ_RUN</h1>"


if __name__ == "__main__":
    app.run(port=8000,debug=True)
    
#d = scrap()
#print(d)