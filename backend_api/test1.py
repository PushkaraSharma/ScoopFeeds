#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Jun 27 14:05:57 2020

@author: pushkara
"""




import background_job_process

background_job_process.scrap("https://www.indiatoday.in/top-stories",'data/top_stories.json')
background_job_process.scrap("https://www.indiatoday.in/business",'data/business.json')
background_job_process.scrap('https://www.indiatoday.in/technology/news','data/tech_new.json')
background_job_process.scrap('https://www.indiatoday.in/coronavirus-covid-19-outbreak','data/corona.json')
background_job_process.scrap('https://www.indiatoday.in/world','data/world.json')
background_job_process.scrap('https://www.indiatoday.in/trending-news','data/trending.json')
background_job_process.scrap('https://www.indiatoday.in/lifestyle/fashion','data/fashion.json')
background_job_process.scrap('https://www.indiatoday.in/auto/latest-auto-news','data/automobile.json')
background_job_process.scrap('https://www.indiatoday.in/education-today/news','data/education.json')


background_job_process.scrap_others('https://www.indiatoday.in/sports','data/sports_new.json')


background_job_process.scrap_gaming('https://www.gamesradar.com/news/','data/gaming_new.json')

