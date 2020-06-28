#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Jun 27 14:05:57 2020

@author: pushkara
"""


import background_job_process

background_job_process.scrap("https://www.indiatoday.in/top-stories",'data_top_stories.json')
background_job_process.scrap('https://www.indiatoday.in/technology/news','data_tech.json')
background_job_process.scrap_sports('https://www.indiatoday.in/sports','data_sports.json')
background_job_process.scrap_gaming('https://www.gamesradar.com/news/','data_gaming.json')