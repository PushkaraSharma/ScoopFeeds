#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Jun 28 13:29:58 2020

@author: pushkara
"""


import torch
from transformers import T5Tokenizer,T5ForConditionalGeneration

model = T5ForConditionalGeneration.from_pretrained('t5-small')
tokenizer = T5Tokenizer.from_pretrained('t5-small')
device = torch.device('cpu')

def summarizer_gen(input):
    preprocess_text = input.strip().replace("\n",'')
    t5_prepared_text = "summarize: "+preprocess_text
    #print("Original text after Preprocessing: \n",preprocess_text)
    tokenzid_text = tokenizer.encode(t5_prepared_text,return_tensors="pt").to(device)
    
    summary_ids = model.generate(tokenzid_text,num_beams=4,no_repeat_ngram_size=2,min_length=10,max_length=80,early_stopping=True)
    output = tokenizer.decode(summary_ids[0],skip_special_tokens=True)
    temp = output.split()
    for i in range(len(temp)):
        if(i==0):
            temp[i] = temp[i].capitalize() 
        elif(temp[i-1]=='.' or temp[i-1][-1]=='.' or temp[i-1][:-2]=='. '):
            temp[i] = temp[i].capitalize() 
    output = ' '.join(temp)
    return output