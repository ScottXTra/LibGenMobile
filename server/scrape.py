import requests
import json
from bs4 import BeautifulSoup
import warnings
from time import sleep, perf_counter
from threading import Thread
import re


warnings.filterwarnings("ignore", category=UserWarning, module='bs4')

def get_CF_pdf(mirror_url):
    response = requests.get(mirror_url)
    
    parsed_html = BeautifulSoup(response.text,'html.parser')

    dl_links = []
    cover_img_element = parsed_html.find('img')
    
    

    ul_table = parsed_html.find('ul')
    li = ul_table.findAll('li')[0]
    
    book_data = {}
    book_data['cover_image'] = "http://library.lol"+cover_img_element['src']
    book_data['direct_url'] = li.find('a')['href']
    
    return book_data





def search_books(title):
    response = requests.get("https://libgen.is/search.php?req="+title+"&lg_topic=libgen&open=0&view=simple&res=25&phrase=1&column=def")
    parsed_html = BeautifulSoup(response.text)
    books = parsed_html.body.findAll('tr', attrs={'valign':'top','bgcolor':'#C6DEFF' })
    books_list = []
    limit = 0
    for b in books:
        attrbutes = b.findAll('td')
        book = {}
        book['id'] = attrbutes[0].get_text()
        book['author'] = attrbutes[1].get_text()
        book['title'] = attrbutes[2].get_text()
        
        title_without_isbn = re.sub('[0-9,-]{5,}', '', book['title']).strip()
        book['title'] = ' '.join(title_without_isbn.split())

        book['publisher'] = attrbutes[3].get_text()
        book['year'] = attrbutes[4].get_text()
        book['page_count'] = attrbutes[5].get_text()
        book['language'] = attrbutes[6].get_text()
        book['file_size'] = attrbutes[7].get_text()
        book['file_extention'] = attrbutes[8].get_text()
        book['mirror_url'] = attrbutes[9].find('a')['href']
        
        #book['mirror_3'] = attrbutes[11].find('a')['href']
        books_list.append(book)
    return json.dumps(books_list)    


# print(get_CF_pdf("http://library.lol/main/7505F8354A1B33D6B90B248A7007863C"))


