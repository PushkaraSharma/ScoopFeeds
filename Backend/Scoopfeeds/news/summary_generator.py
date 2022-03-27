import torch
from transformers import T5Tokenizer, T5ForConditionalGeneration


def initialize_model():
    model = T5ForConditionalGeneration.from_pretrained('t5-small')
    tokenizer = T5Tokenizer.from_pretrained('t5-small')
    device = torch.device('cpu')
    return model, tokenizer, device


def process_generated_summary(summary_text):
    summary_list = summary_text.split()
    for i in range(len(summary_list)):
        if(i == 0):
            summary_list[i] = summary_list[i].capitalize()
        elif(summary_list[i-1] == '.' or summary_list[i-1][-1] == '.' or summary_list[i-1][:-2] == '. '):
            summary_list[i] = summary_list[i].capitalize()
    processed_text = ' '.join(summary_list)
    count = len(processed_text)-1
    for i in reversed(range(len(processed_text))):
        if (processed_text[count] == '.' and processed_text[count-2] == '.'):
            count -= 2
        elif (processed_text[count] == '.' and processed_text[count-2] != '.'):
            output = processed_text[:count+1]
            break
        count -= 1
    return output


def get_generated_summary(input):
    model, tokenizer, device = initialize_model()
    preprocess_text = input.strip().replace("\n", '')
    t5_prepared_text = "summarize: "+preprocess_text
    text = tokenizer.tokenize(t5_prepared_text)
    text = text[:512] if len(text) > 512 else text
    tokenzid_text = tokenizer.encode(text, return_tensors="pt").to(device)
    summary_ids = model.generate(tokenzid_text, num_beams=4, no_repeat_ngram_size=2,
                                 min_length=60, max_length=120, early_stopping=True)
    output = tokenizer.decode(summary_ids[0], skip_special_tokens=True)
    processed_output = process_generated_summary(output)
    return processed_output
