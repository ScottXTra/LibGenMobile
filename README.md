# LibGenMobile

The following outlines the easiest way to run the complete app ( as per the demo ):
1. Git clone this repo anywhere you want 
2. cd into the `LibGenMobile` directory 

3. Run the flask server: 
     - now cd into server 
     - type `flask run --host=0.0.0.0 -p 3000` into the command line 
     - You should see something similar to : `Running on http://172.26.1.253:3000/ (Press CTRL+C to quit)`
     - Copy paste this and head to the following : 
     
4. `cd..` to get out of the server directory and cd into mobile_app/bookSearch_page.dart 
     - Here navgiate to line 36 which will look like : `String url = 'http://192.168.2.27:3000/search_book?term=';`
     - Here you will replace `192.168.2.27:3000` with the ip flask had shown you earlier `example: 172.26.1.253:3000` and save the file 

5. flutter run 

6. App can now be used in a similar style to that of the demo
