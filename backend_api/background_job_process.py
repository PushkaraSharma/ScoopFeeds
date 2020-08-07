#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Jun 27 14:03:43 2020

@author: pushkara
"""
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jul  2 17:53:35 2020

@author: pushkara
"""



import urllib.request as url
import bs4
import summarizer
import pandas as pd


def scrap(url_,file_name):
    
    try:
    
        df2 = pd.read_json(file_name,encoding='utf-8')
        first = df2['heading'][0]
    
        web = url.urlopen(url_)
        page1 = bs4.BeautifulSoup(web,'lxml')
        b = page1.find('div',class_='view-content')
        temp_hrefs = []
        for a in b.find_all('a',href =True):
            g =(a['href'])
            temp_hrefs.append(g)
            
        print("TOTAL NEWS:",len(temp_hrefs))
        
        df = pd.DataFrame()
        cols = ['heading','summary','picture']
        
        for i in range(len(temp_hrefs)):
            
            try:
                new_web =  url.urlopen("https://www.indiatoday.in"+temp_hrefs[i])
                new_page = bs4.BeautifulSoup(new_web,'lxml')
                head = new_page.find('h1',itemprop = 'headline') 
                if(head is None):
                    continue
                
                #implementation to only scrap and process those news which afre fresh
                #and are not in our top 50 stories
                
                head = head.text
                print("Heading from scrap:\n",head)
                if(head==first):
                    print("\n+++++EQUAL+++++++++++++++++\n")
                    break
                pic_link = new_page.find('img', itemprop='contentUrl')
                pics = pic_link['data-src']   
                if(pics is None):
                    continue
                newss = new_page.find('div',itemprop='articleBody')
                if(newss is None):
                    continue
                f_news = newss.text
                for i in range(len(f_news)):
                    if(f_news[i]=='R' and f_news[i+1]=='E' and f_news[i+2]=='A' and f_news[i+3]=='D'):
                        f_news = f_news[:i]
                        break
            
        
                summary_gen = summarizer.summarizer_gen(f_news)
                df = df.append(pd.DataFrame([[head,summary_gen,pics]],columns=cols))
        
                print(df)
            except:
                print("Some Internal Error in tech/top_stories section") 
        
        df = df.append(df2)
        if(len(df['heading'])>50):
            df = df.iloc[0:50,:]
    
        df.to_json(file_name,orient='records',force_ascii=False)
    except:
        print('Some great error in srcap main')
    
def scrap_others(url_,file_name):  
    
    try:
    
        df2 = pd.read_json(file_name,encoding='utf-8')
        first = df2['heading'][0]
        
        print("Heading from json:\n",first)
    
        web = url.urlopen(url_)
        page1 = bs4.BeautifulSoup(web,'lxml')
        b = page1.find('ul',class_='itg-listing')
        temp_hrefs = []
        headings = []
        for a in b.find_all('a',href =True):
            head = a.text
            headings.append(head)
            g =(a['href'])
            temp_hrefs.append(g)
        temp_hrefs = temp_hrefs[:10]    
        print("TOTAL NEWS:",len(temp_hrefs))
        
        df = pd.DataFrame()
        cols = ['heading','summary','picture']
        
        c = 0
        for i in range(len(temp_hrefs)):
            try:
            
                new_web =  url.urlopen("https://www.indiatoday.in"+temp_hrefs[i])
                new_page = bs4.BeautifulSoup(new_web,'lxml')
                head = headings[i]
                if(head is None):
                    continue
                #implementation to only scrap and process those news which afre fresh
                #and are not in our top 10 stories
                
                print("Heading from scrap:\n",head)
                if(head==first):
                    print("\n+++++EQUAL+++++++++++++++++\n")
                    break
                try:
                    pic_link = new_page.find('img', itemprop='contentUrl')
                    pics = pic_link['data-src']  
                except:
                    c+=1
                    continue
                if(pics is None):
                    continue
                newss = new_page.find('div',itemprop='articleBody')
                if(newss is None):
                    continue
                f_news = newss.text
                temp = f_news.split()
                temp = temp[:374]
                f_news = ' '.join(temp)
    
                summary_gen = summarizer.summarizer_gen(f_news)
                df = df.append(pd.DataFrame([[head,summary_gen,pics]],columns=cols))
    
                print(df)
                c+=1
                
            except:
                print("Some Internal Error in sports section")
                
            
        df = df.append(df2)
        if(len(df['heading'])>50):
            df = df.iloc[0:50,:]
    
        df.to_json(file_name,orient='records',force_ascii=False)
    except:
        print("Great error in scrap_others")

def scrap_gaming(url_,file_name):    
    
    try:
    
        df2 = pd.read_json(file_name,encoding='utf-8')
        first = df2['heading'][0]
        print("Heading from json:\n",first)
    
        web = url.urlopen(url_)
        page1 = bs4.BeautifulSoup(web,'lxml')
        b = page1.find('div',class_='listingResults news')
        temp_hrefs = []
        c = 0
        
        for a in b.find_all('a',href =True):
            g =(a['href'])
            if(c%2==0):
                temp_hrefs.append(g)
            c+=1    
        temp_hrefs = temp_hrefs[:10]
        print("TOTAL NEWS:",len(temp_hrefs))
        
        df = pd.DataFrame()
        cols = ['heading','summary','picture']
        for i in range(len(temp_hrefs)):
            try:
            
                new_web =  url.urlopen(temp_hrefs[i])
                new_page = bs4.BeautifulSoup(new_web,'lxml')
                head = new_page.find('h1').text
                if(head is None):
                    continue
                #implementation to only scrap and process those news which afre fresh
                #and are not in our top 10 stories
                
                print("Heading from scrap:\n",head)
                if(head==first):
                    print("\n+++++EQUAL+++++++++++++++++\n")
                    break
                pic_link = new_page.find('img', class_='block-image-ads hero-image')
                pics = pic_link['src']   
                if(pics is None):
                    continue
                newss = new_page.find('div',class_='text-copy bodyCopy auto')
                if(newss is None):
                    continue
                f_news = newss.text
                temp = f_news.split()
                temp = temp[:374]
                f_news = ' '.join(temp)
            
                summary_gen = summarizer.summarizer_gen(f_news)
                df = df.append(pd.DataFrame([[head,summary_gen,pics]],columns=cols))
    
                print(df)
            except:
                print("Some Internal Error in gamming section")
           
        df = df.append(df2)
        if(len(df['heading'])>50):
           df = df.iloc[0:50,:]
    
        df.to_json(file_name,orient='records',force_ascii = False)
    except:
        print("Great error in gaming scrap")

