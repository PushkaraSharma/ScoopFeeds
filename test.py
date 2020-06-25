#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jun 25 11:57:34 2020

@author: pushkara
"""


#import json
import requests
from requests_toolbelt.utils import dump
url='http://127.0.0.1:8000/top_stories/'
r = requests.get(url)
data = dump.dump_all(r)
print(data.decode('utf-8'))




