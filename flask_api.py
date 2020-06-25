from flask import Flask,jsonify
#import _pickle as pickle
import torch
import json
from transformers import T5Tokenizer,T5ForConditionalGeneration
import urllib.request as url
import bs4

app = Flask(__name__)

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


@app.route('/top_stories/',methods=['GET'])


def scrap():    
    
    with open('data.txt') as f:
         data = json.load(f)
    d1 = json.loads(data)
    print("++++++++",d1)
    first = (next(iter(d1)))
    print(first)
    
    web = url.urlopen("https://www.indiatoday.in/top-stories")
    page1 = bs4.BeautifulSoup(web,'lxml')
    b = page1.find('div',class_='view-content')
    temp_hrefs = []
    for a in b.find_all('a',href =True):
        g =(a['href'])
        temp_hrefs.append(g)
    headings = []
    news = []
    for i in range(len(temp_hrefs)):
        new_web =  url.urlopen("https://www.indiatoday.in"+temp_hrefs[i])
        new_page = bs4.BeautifulSoup(new_web,'lxml')
        head = new_page.find('h1',itemprop = 'headline')   
        #implement to check if heading is same as before so no processing just 
        # return the same file
        print(head.text)
        if(head.text==first and i==0):
            d1 = json.dumps(d1)
            return (d1)
            
        headings.append(head.text)

        
        newss = new_page.find('div',itemprop='articleBody')
        f_news = (newss.text[:-100])
        news.append(f_news)
    summaries = []
    for i in news:
        summaries.append(summarizer(i))
    final_data = {}
    for i in range(len(headings)):
        final_data.update({headings[i]:summaries[i]})
    jsonData = json.dumps(final_data)

    with open('data.txt', 'w') as outfile:
         json.dump(jsonData, outfile)
    return (jsonData)

@app.route('/')
def index():
    return "<h1>READ_RUN</h1>"

if __name__ == "__main__":
    app.run(port=8000,debug=True)
    
#d = scrap()
#print(d)