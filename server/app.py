
from flask import Flask, request
import json
from scrape import search_books , get_CF_pdf

app = Flask(__name__)


@app.route('/')
def hello():
    return 'LIBGEN API 0.1'
    # return 'Hello, World!'

@app.route('/search_book')
def search_book():
    term = request.args.get('term')
   
    return search_books(term)

@app.route('/get_download_links')
def get_download_links():
    term = request.args.get('mirror')
   
    return get_CF_pdf(term)




# @app.route('/api/insert_company' , methods = ['POST'])
# def insert_company_endpoint():
#     data = request.form
#     insert_company(data['company_name'])
#     return 'Company added'