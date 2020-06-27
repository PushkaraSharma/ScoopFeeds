#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Jun 27 14:03:43 2020

@author: pushkara
"""


import torch
import json
from transformers import T5Tokenizer,T5ForConditionalGeneration
import urllib.request as url
import bs4

model = T5ForConditionalGeneration.from_pretrained('t5-small')
tokenizer = T5Tokenizer.from_pretrained('t5-small')
device = torch.device('cpu')

def summarizer(input):
    preprocess_text = input.strip().replace("\n",'')
    t5_prepared_text = "summarize: "+preprocess_text
    #print("Original text after Preprocessing: \n",preprocess_text)
    tokenzid_text = tokenizer.encode(t5_prepared_text,return_tensors="pt").to(device)
    
    summary_ids = model.generate(tokenzid_text,num_beams=4,no_repeat_ngram_size=2,min_length=10,max_length=80,early_stopping=True)
    output = tokenizer.decode(summary_ids[0],skip_special_tokens=True)
    return output


def scrap(url_,file_name):    
    
    with open(file_name) as f:
         data = json.load(f)
    d1 = json.loads(data)
    first = (next(iter(d1)))
    print("Heading from json:\n",first)

    web = url.urlopen(url_)
    page1 = bs4.BeautifulSoup(web,'lxml')
    b = page1.find('div',class_='view-content')
    temp_hrefs = []
    for a in b.find_all('a',href =True):
        g =(a['href'])
        temp_hrefs.append(g)
        
    print("TOTAL NEWS:",len(temp_hrefs))
    
    d2 = {}
    for i in range(len(temp_hrefs)):
        try:
            new_web =  url.urlopen("https://www.indiatoday.in"+temp_hrefs[i])
            new_page = bs4.BeautifulSoup(new_web,'lxml')
            head = new_page.find('h1',itemprop = 'headline') 
            if(head is None):
                continue
            #implementation to only scrap and process those news which afre fresh
            #and are not in our top 10 stories
            
            print("Heading from scrap:\n",head.text)
            if(head.text==first):
                print("EQUAL")
                break
            pic_link = new_page.find('img', itemprop='contentUrl')
            pics = pic_link['data-src']   
            if(pics is None):
                continue
            newss = new_page.find('div',itemprop='articleBody')
            if(newss is None):
                continue
            f_news = newss.text
            temp = f_news.split()
            temp = temp[:374]
            f_news = ' '.join(temp)
            
    
            summary_gen = summarizer(f_news)
            d2.update({head.text:[summary_gen,pics]})
        except:
            print("Some Internal Error")
    d3 = dict(d2) 
    d3.update(d1)  
    d3 = {k: d3[k] for k in list(d3)[:10]}     
    jsonData = json.dumps(d3)
    
    with open(file_name, 'w') as outfile:
        json.dump(jsonData, outfile)
    #return (jsonData)