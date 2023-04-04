from transformers import pipeline
import json
from flask import Flask, request
import time

app = Flask(__name__)

# init model
classifier = pipeline("zero-shot-classification",
                      model="facebook/bart-large-mnli", use_fast=True)


@app.route("/classify")
def getClassification():
    args = request.args
    input = args.get('item')
    use_translation = args.get('use_translatrion')
    t_from = args.get('from')
    t_to = args.get('to')
    # TODO ask for candidate labels
    # TODO move args to body
    return _getClassification(input, use_translation, t_from, t_to)


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


def _getClassification(input, use_translation=False, t_from='', t_to=''):

    st = time.process_time()

    print('Input: ', input)
    print('Use translation: ', use_translation)

   # read the sequence of candidate labels from json file
    with open('candidate_labels.json') as f:
        # the json file contains an object with a single key "labels" and a list of labels as value
        candidate_labels = json.load(f)['labels']

    if (use_translation == 'false'):
        # classify the input
        result = classifier(input, candidate_labels,
                            multi_label=True, top_k=3)

        int = time.process_time() - st
        print('Time needed to classify: ', int)

        # return the top 2 labels with the highest scores from result
        top3_indices = sorted(
            range(len(result['scores'])), key=lambda i: result['scores'][i])[-3:]
        top3_labels = [result['labels'][i] for i in top3_indices]

        end = time.process_time() - st
        print('Time needed to classify and sort: ', end)

        return top3_labels

    if (t_from == '' or t_to == ''):
        return 'Error: missing translation parameters from or to'

    # translate the input
    translation = _translate(input, 'it', 'en')[0]['translation_text']

    tr = time.process_time() - st
    print('Time needed to complete translate: ', tr)

    result = classifier(translation, candidate_labels,
                        multi_label=True, top_k=3)

    tr = time.process_time() - st

    # return the top 2 labels with the highest scores from result
    top3_indices = sorted(
        range(len(result['scores'])), key=lambda i: result['scores'][i])[-3:]
    top3_labels = [result['labels'][i] for i in top3_indices]
    print(top3_labels)

    # translate the labels and add them to new list
    translated_labels = []
    for label in top3_labels:
        translated_labels.append(_translate(label, 'en', 'it')[
                                 0]['translation_text'])

    tr = time.process_time() - st
    print('Time needed to complete classify and translate: ', tr)

    return translated_labels
