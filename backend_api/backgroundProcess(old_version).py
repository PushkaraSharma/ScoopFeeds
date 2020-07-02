import json
import urllib.request as url
import bs4
import summarizer


def scrap(url_,file_name):    
    
    with open(file_name) as f:
         data = json.load(f)
    d1 = json.loads(data)
    first = (next(iter(d1))).encode('ascii', 'replace').decode()
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
            head = head.text.encode('ascii', 'replace').decode()
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
            f_news = newss.text.encode('ascii', 'replace').decode()
            temp = f_news.split()
            temp = temp[:374]
            f_news = ' '.join(temp)
            
    
            summary_gen = summarizer.summarizer_gen(f_news)
            d2.update({head:[summary_gen,pics]})
        except:
            print("Some Internal Error in top stories section")
    d3 = dict(d2) 
    d3.update(d1)  
    d3 = {k: d3[k] for k in list(d3)[:10]}     
    jsonData = json.dumps(d3)
    
    with open(file_name, 'w') as outfile:
        json.dump(jsonData, outfile)
    #return (jsonData)

def scrap_sports(url_,file_name):    
    
    with open(file_name) as f:
         data = json.load(f)
    d1 = json.loads(data)
    first = (next(iter(d1))).encode('ascii', 'replace').decode()
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
    
    d2 = {}
    c = 0
    for i in range(len(temp_hrefs)):
        try:
        
            new_web =  url.urlopen("https://www.indiatoday.in"+temp_hrefs[i])
            new_page = bs4.BeautifulSoup(new_web,'lxml')
            head = headings[i].encode('ascii', 'replace').decode()
            if(head is None):
                continue
            #implementation to only scrap and process those news which afre fresh
            #and are not in our top 10 stories
            
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
            f_news = newss.text.encode('ascii', 'replace').decode()
            temp = f_news.split()
            temp = temp[:374]
            f_news = ' '.join(temp)

            summary_gen = summarizer.summarizer_gen(f_news)
            d2.update({head:[summary_gen,pics]})
            c+=1
            
        except:
            print("Some Internal Error in sports section") 
        
    d3 = dict(d2) 
    d3.update(d1)  
    d3 = {k: d3[k] for k in list(d3)[:10]}     
    jsonData = json.dumps(d3)
    
    with open(file_name, 'w') as outfile:
        json.dump(jsonData, outfile)
    #return (jsonData)

def scrap_gaming(url_,file_name):    
    
    with open(file_name) as f:
         data = json.load(f)
    d1 = json.loads(data)
    first = (next(iter(d1))).encode('ascii', 'replace').decode()
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
    
    d2 = {}
    for i in range(len(temp_hrefs)):
        try:
        
            new_web =  url.urlopen(temp_hrefs[i])
            new_page = bs4.BeautifulSoup(new_web,'lxml')
            head = new_page.find('h1').text.encode('ascii', 'replace').decode()
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
            f_news = newss.text.encode('ascii', 'replace').decode()
            temp = f_news.split()
            temp = temp[:374]
            f_news = ' '.join(temp)
        
            summary_gen = summarizer.summarizer_gen(f_news)
            d2.update({head:[summary_gen,pics]})
        except:
            print("Some Internal Error in gamming section")
       
    d3 = dict(d2) 
    d3.update(d1)  
    d3 = {k: d3[k] for k in list(d3)[:10]}     
    jsonData = json.dumps(d3)
    
    with open(file_name, 'w') as outfile:
        json.dump(jsonData, outfile)
    #return (jsonData)
