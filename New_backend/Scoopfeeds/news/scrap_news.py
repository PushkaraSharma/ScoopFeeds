import urllib.request as url
import pandas as pd
import bs4
from news.variables import NEWS_HOME_PAGE_URL, NEWS_URL
from news.models import News

def get_first_record_heading(news_type):
    try:
        return News.objects.filter(news_type=news_type).first().heading
    except AttributeError:
        return ''
        

def get_context_of_page(url_name):
    web = url.urlopen(url_name)
    page = bs4.BeautifulSoup(web, 'lxml')
    return page


def extract_links_for_news(news_type, tag, class_name):
    home_page = get_context_of_page(NEWS_URL[news_type])
    b = home_page.find(tag, class_=class_name)
    temp_hrefs = []
    for anchor_tag in b.find_all('a', href=True):
        temp_hrefs.append(anchor_tag['href'])
    return temp_hrefs


def get_image_link_from_page(page):
    pic_link = page.find('img', class_="lazyload")
    pics = pic_link['data-src']
    return pics


def check_news_details_condition(news):
    for i in range(len(news)):
        if(news[i] == 'R' and news[i+1] == 'E' and news[i+2] == 'A' and news[i+3] == 'D'):
            news = news[:i]
            break
    return news


def create_context_for_news_model(headline_text, summary, img_url, news_type):
    return {
        'heading': headline_text,
        'summary': summary,
        'image_url': img_url,
        'news_type': news_type
    }


def scrap_news(news_type):
    heading_first = get_first_record_heading(news_type)
    hrefs = extract_links_for_news(news_type, 'div', 'view-content')
    print("TOTAL NEWS:", len(hrefs))
    for index in range(len(hrefs)):
        news_page = get_context_of_page(NEWS_HOME_PAGE_URL+hrefs[index])
        headline = news_page.find('h1', itemprop='headline')
        if not headline:
            continue
        headline_text = headline.text
        if headline_text == heading_first:
            break
        img_url = get_image_link_from_page(news_page)
        if not img_url:
            continue
        news_details = news_page.find('div', itemprop='articleBody')
        if not news_details:
            continue
        news_details_text = news_details.text
        news_details_text = check_news_details_condition(news_details.text)
        #summary_gen = summarizer.summarizer_gen(news_details_text)
        summary = news_details_text
        context = create_context_for_news_model(
            headline_text, summary, img_url, news_type)
        News.objects.create(**context)


# def scrap_others(url_,file_name):

#     try:

#         df2 = pd.read_json(file_name,encoding='utf-8')
#         first = df2['heading'][0]

#         print("Heading from json:\n",first)

#         web = url.urlopen(url_)
#         page1 = bs4.BeautifulSoup(web,'lxml')
#         b = page1.find('ul',class_='itg-listing')
#         temp_hrefs = []
#         headings = []
#         for a in b.find_all('a',href =True):
#             head = a.text
#             headings.append(head)
#             g =(a['href'])
#             temp_hrefs.append(g)
#         temp_hrefs = temp_hrefs[:10]
#         print("TOTAL NEWS:",len(temp_hrefs))

#         df = pd.DataFrame()
#         cols = ['heading','summary','picture']

#         c = 0
#         for i in range(len(temp_hrefs)):
#             try:

#                 new_web =  url.urlopen("https://www.indiatoday.in"+temp_hrefs[i])
#                 new_page = bs4.BeautifulSoup(new_web,'lxml')
#                 head = headings[i]
#                 if(head is None):
#                     continue
#                 #implementation to only scrap and process those news which afre fresh
#                 #and are not in our top 10 stories

#                 print("Heading from scrap:\n",head)
#                 if(head==first):
#                     print("\n+++++EQUAL+++++++++++++++++\n")
#                     break
#                 try:
#                     pic_link = new_page.find('img', class_= "lazyload")
#                     pics = pic_link['data-src']
#                 except:
#                     c+=1
#                     continue
#                 if(pics is None):
#                     continue
#                 newss = new_page.find('div',itemprop='articleBody')
#                 if(newss is None):
#                     continue
#                 f_news = newss.text
#                 temp = f_news.split()
#                 temp = temp[:374]
#                 f_news = ' '.join(temp)

#                 summary_gen = summarizer.summarizer_gen(f_news)
#                 df = df.append(pd.DataFrame([[head,summary_gen,pics]],columns=cols))

#                 print(df)
#                 c+=1

#             except:
#                 print("Some Internal Error in sports section")


#         df = df.append(df2)
#         if(len(df['heading'])>50):
#             df = df.iloc[0:50,:]

#         df.to_json(file_name,orient='records',force_ascii=False)
#     except:
#         print("Great error in scrap_others")

# def scrap_gaming(url_,file_name):

#     try:

#         df2 = pd.read_json(file_name,encoding='utf-8')
#         first = df2['heading'][0]
#         print("Heading from json:\n",first)

#         web = url.urlopen(url_)
#         page1 = bs4.BeautifulSoup(web,'lxml')
#         b = page1.find('div',class_='listingResults news')
#         temp_hrefs = []
#         c = 0

#         for a in b.find_all('a',href =True):
#             g =(a['href'])
#             if(c%2==0):
#                 temp_hrefs.append(g)
#             c+=1
#         temp_hrefs = temp_hrefs[:10]
#         print("TOTAL NEWS:",len(temp_hrefs))

#         df = pd.DataFrame()
#         cols = ['heading','summary','picture']
#         for i in range(len(temp_hrefs)):
#             try:

#                 new_web =  url.urlopen(temp_hrefs[i])
#                 new_page = bs4.BeautifulSoup(new_web,'lxml')
#                 head = new_page.find('h1').text
#                 if(head is None):
#                     continue
#                 #implementation to only scrap and process those news which afre fresh
#                 #and are not in our top 10 stories

#                 print("Heading from scrap:\n",head)
#                 if(head==first):
#                     print("\n+++++EQUAL+++++++++++++++++\n")
#                     break
#                 pic_link = new_page.find('img', class_='block-image-ads hero-image')
#                 pics = pic_link['src']
#                 if(pics is None):
#                     continue
#                 newss = new_page.find('div',class_='text-copy bodyCopy auto')
#                 if(newss is None):
#                     continue
#                 f_news = newss.text
#                 temp = f_news.split()
#                 temp = temp[:374]
#                 f_news = ' '.join(temp)

#                 summary_gen = summarizer.summarizer_gen(f_news)
#                 df = df.append(pd.DataFrame([[head,summary_gen,pics]],columns=cols))

#                 print(df)
#             except:
#                 print("Some Internal Error in gamming section")

#         df = df.append(df2)
#         if(len(df['heading'])>50):
#            df = df.iloc[0:50,:]

#         df.to_json(file_name,orient='records',force_ascii = False)
#     except:
#         print("Great error in gaming scrap")
