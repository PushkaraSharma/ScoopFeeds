#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jun 25 11:57:34 2020

@author: pushkara
"""


#import json
import requests
url='http://127.0.0.1:5000/top_stories/'
r = requests.get(url)
print(r)