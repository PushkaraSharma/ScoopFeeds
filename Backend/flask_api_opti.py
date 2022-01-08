#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jun 26 22:36:15 2020

@author: pushkara
"""


from flask import Flask
#import json
import background_job_process
from apscheduler.schedulers.background import BackgroundScheduler
import atexit
import pandas as pd

#Interval of 3 min
def process_news():
    print("Scheduler is alive!")
    background_job_process.scrap("https://www.indiatoday.in/top-stories",'data/top_stories.json')
   
    
sched = BackgroundScheduler(daemon=True)
sched.add_job(process_news,'interval',minutes=4)
sched.start()
atexit.register(lambda: sched.shutdown())

#Interval of 20 min 
def process_news2():
    print("Scheduler2 is alive!") 
    background_job_process.scrap('https://www.indiatoday.in/technology/news','data/tech_new.json')
    background_job_process.scrap_others('https://www.indiatoday.in/sports','data/sports_new.json')
    background_job_process.scrap('https://www.indiatoday.in/coronavirus-covid-19-outbreak','data/corona.json')
    background_job_process.scrap('https://www.indiatoday.in/world','data/world.json')
    background_job_process.scrap('https://www.indiatoday.in/education-today/news','data/education.json')

sched2 = BackgroundScheduler(daemon=True)
sched2.add_job(process_news2,'interval',minutes=20)
sched2.start()
atexit.register(lambda: sched2.shutdown())

# Interval of 40 min

def process_news3():
    print("Scheduler3 is alive!")
    background_job_process.scrap("https://www.indiatoday.in/business",'data/business.json')
    background_job_process.scrap_gaming('https://www.gamesradar.com/news/','data/gaming_new.json')
    background_job_process.scrap('https://www.indiatoday.in/trending-news','data/trending.json')
    background_job_process.scrap('https://www.indiatoday.in/lifestyle/fashion','data/fashion.json')
    background_job_process.scrap('https://www.indiatoday.in/auto/latest-auto-news','data/automobile.json')
sched3 = BackgroundScheduler(daemon=True)
sched3.add_job(process_news3,'interval',minutes=45)
sched3.start()
atexit.register(lambda: sched3.shutdown())


app = Flask(__name__)


@app.route('/top_stories/',methods=['GET'])
def top_stories_to_user():    
    
    data = pd.read_json('data/top_stories.json')
    data  = data.to_json(orient='records')
    return data



@app.route('/tech/',methods=['GET'])
def tech_to_user():    
    
    data = pd.read_json('data/tech_new.json')
    data  = data.to_json(orient='records')
    return data

@app.route('/sports/',methods=['GET'])
def sports_to_user():    
    
    data = pd.read_json('data/sports_new.json')
    data  = data.to_json(orient='records')
    return data

@app.route('/gaming/',methods=['GET'])
def gaming_to_user():    
    
    data = pd.read_json('data/gaming_new.json')
    data  = data.to_json(orient='records')
    return data

@app.route('/corona/',methods=['GET'])
def corona_to_user():    
    
    data = pd.read_json('data/corona.json')
    data  = data.to_json(orient='records')
    return data

@app.route('/automobile/',methods=['GET'])
def automobile_to_user():    
    
    data = pd.read_json('data/automobile.json')
    data  = data.to_json(orient='records')
    return data

@app.route('/education/',methods=['GET'])
def education_to_user():    
    
    data = pd.read_json('data/education.json')
    data  = data.to_json(orient='records')
    return data

@app.route('/fashion/',methods=['GET'])
def fashion_to_user():    
    
    data = pd.read_json('data/fashion.json')
    data  = data.to_json(orient='records')
    return data

@app.route('/trending/',methods=['GET'])
def trending_to_user():    
    
    data = pd.read_json('data/trending.json')
    data  = data.to_json(orient='records')
    return data

@app.route('/world/',methods=['GET'])
def world_to_user():    
    
    data = pd.read_json('data/world.json')
    data  = data.to_json(orient='records')
    return data

@app.route('/business/',methods=['GET'])
def business_to_user():    
    
    data = pd.read_json('data/business.json')
    data  = data.to_json(orient='records')
    return data

@app.route('/')
def index():
    return "<h1>Scoop_Feeds by Pushkara Sharma</h1>"


if __name__ == "__main__":
    app.run(host='0.0.0.0',port=5000)
    
#d = scrap()
#print(d)
