# LibGenMobile

# About
LibGenMobile is a mobile interface for the https://libgen.is/. It was created through reverse engineering and creating a wrapper for the basic functinality of the website to bring it to mobile. This was a project for CIS-4030 in which we recieved ~96% grade for the project.

![image](https://user-images.githubusercontent.com/39224367/164112960-d7edbeee-5328-45eb-b8f5-ebe5cc3fd4c6.png)
![image](https://user-images.githubusercontent.com/39224367/164113012-2ae4d176-bab1-4b2e-acf7-63d2aa318a3c.png)
![image](https://user-images.githubusercontent.com/39224367/164113043-1dc47814-6c72-4609-b2a5-62cd0c91cd98.png)
![image](https://user-images.githubusercontent.com/39224367/164113171-aaa8cbd1-3134-4494-8218-f66b45cef4c0.png)


The following outlines the easiest way to run the complete app ( as per the demo ):
1. Git clone this repo anywhere you want 
2. cd into the `LibGenMobile` directory 

3. Run the flask server: 
     - now cd into server 
     - type `flask run --host=0.0.0.0 -p 3000` into the command line 
     - You should see something similar to : `Running on http://172.26.1.253:3000/ (Press CTRL+C to quit)`
     - Copy paste this and head to the following : 
     
4. `cd..` to get out of the server directory and cd into mobile_app/
     - Here navgiate to line 37 in bookSearch_page.dart which will look like : `String url = 'http://192.168.2.27:3000/search_book?term=';`
     - Here you will replace `192.168.2.27:3000` with the ip flask had shown you earlier `example: 172.26.1.253:3000` and save the file
     - Replace the same string on line 183 in preview_page.dart with the ip in flask

5. flutter run 

6. App can now be used in a similar style to that of the demo
