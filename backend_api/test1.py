#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Jun 27 14:05:57 2020

@author: pushkara
"""
# =============================================================================
# import pandas as pd 
# df  = pd.read_json('tech_new.json')
# print(df)
# =============================================================================

import background_process_testing

#background_process_testing.scrap("https://www.indiatoday.in/top-stories",'top_stories.json')
background_process_testing.scrap('https://www.indiatoday.in/technology/news')
#background_job_process.scrap_sports('https://www.indiatoday.in/sports','data_sports.json')
#background_job_process.scrap_gaming('https://www.gamesradar.com/news/','data_gaming.json')