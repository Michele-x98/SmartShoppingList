from transformers import pipeline
import json
from flask import Flask, request
import time


app = Flask(__name__)

# init model
classifier = pipeline("zero-shot-classification",
                      model="facebook/bart-large-mnli", use_fast=True)


class ClassifyRequest(object):
    def __init__(self, item, candidate_labels,  top_k=3, use_translation=False, t_from='', t_to=''):
        self.item = item
        self.candidate_labels = candidate_labels
        self.top_k = top_k
        self.use_translation = use_translation
        self.t_from = t_from
        self.t_to = t_to


@app.route("/classify", methods=['POST'])
def getClassification():
    if request.method == 'POST':
        j = json.loads(json.dumps(request.get_json()))
        c = ClassifyRequest(**j)
        return _getClassification(c)
    else:
        return 'Error: only POST requests are supported'


def _translate(input, from_, to):
    # Define the model repo
    model_name = f"Helsinki-NLP/opus-mt-{from_}-{to}"
    translator = pipeline(
        f"translation_{from_}_to_{to}", model=model_name, use_fast=True)
    # Translate the text
    translation = translator(input, max_length=40)
    # Print the translation
    print(translation)
    return translation


def _getClassification(c: ClassifyRequest):

    st = time.process_time()

    if (c.item == ''):
        return 'Error: missing item to classify'

    labels = list(c.candidate_labels)
    print(labels)

    if (labels == ''):
        return 'Error: missing candidate labels'

    print('Item to classify: ', c.item)
    print('Candidate labels: ', labels)

    if (c.use_translation == 'false' or c.use_translation == False):
        # classify the input
        result = classifier(c.item, labels,
                            multi_label=True, top_k=3)

        int = time.process_time() - st
        print('Time needed to classify: ', int)

        # return the top 2 labels with the highest scores from result
        top3_indices = sorted(
            range(len(result['scores'])), key=lambda i: result['scores'][i])[-c.top_k:]
        top3_labels = [result['labels'][i] for i in top3_indices]

        end = time.process_time() - st
        print('Time needed to classify and sort: ', end)
        print(top3_labels)

        return top3_labels

    if (c.t_from == '' or c.t_to == ''):
        return 'Error: missing translation parameters from or to'

    # translate the input
    translation = _translate(input, c.t_from, c.t_to)[0]['translation_text']

    tr = time.process_time() - st
    print('Time needed to complete translate: ', tr)

    result = classifier(translation, labels,
                        multi_label=True, top_k=3)

    tr = time.process_time() - st

    # return the top 2 labels with the highest scores from result
    top3_indices = sorted(
        range(len(result['scores'])), key=lambda i: result['scores'][i])[-c.top_k:]
    top3_labels = [result['labels'][i] for i in top3_indices]

    # translate the labels and add them to new list
    translated_labels = []
    for label in top3_labels:
        translated_labels.append(_translate(label, 'en', 'it')[
                                 0]['translation_text'])

    tr = time.process_time() - st
    print('Time needed to complete classify and translate: ', tr)

    return translated_labels
