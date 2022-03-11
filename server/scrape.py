import requests
import json
from bs4 import BeautifulSoup
import warnings
warnings.filterwarnings("ignore", category=UserWarning, module='bs4')

def search_books(title):
    response = requests.get("https://libgen.is/search.php?req="+title+"&lg_topic=libgen&open=0&view=simple&res=25&phrase=1&column=def")
    parsed_html = BeautifulSoup(response.text)
    books = parsed_html.body.findAll('tr', attrs={'valign':'top','bgcolor':'#C6DEFF' })
    books_list = []
    for b in books:
        attrbutes = b.findAll('td')
        book = {}
        book['id'] = attrbutes[0].get_text()
        book['author'] = attrbutes[1].get_text()
        book['title'] = attrbutes[2].get_text()
        book['publisher'] = attrbutes[3].get_text()
        book['year'] = attrbutes[4].get_text()
        book['page_count'] = attrbutes[5].get_text()
        book['language'] = attrbutes[6].get_text()
        book['file_size'] = attrbutes[7].get_text()
        book['file_extention'] = attrbutes[8].get_text()
        book['mirror_1'] = attrbutes[9].find('a')['href']
        book['mirror_2'] = attrbutes[10].find('a')['href']
        book['mirror_3'] = attrbutes[11].find('a')['href']
        books_list.append(book)
    return json.dumps(books_list)    
def get_CF_pdf(mirror_url):
    response = requests.get(mirror_url)
    parsed_html = BeautifulSoup(response.text,'html.parser')
    dl_links = []
    ul_table = parsed_html.find('ul')
    li_s = ul_table.findAll('li')
    for li in li_s:
        dl_links.append(li.find('a')['href'])
    return json.dumps(dl_links)

#print(get_CF_pdf('http://library.lol/main/025976AAF38AAF99710D036A256D315C'))


print(search_books("science"))


