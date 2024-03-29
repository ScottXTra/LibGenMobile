import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

int _rating = 0;

/* Generic button styling settings */
final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
  minimumSize: const Size(200, 0),
  padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
  primary: Colors.red,
  textStyle: const TextStyle(fontSize: 17),
);

/* Main page that has settings and extra info */
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const String shareMessage = "Visit our github repository for Libgen Mobile at: https://github.com/ScottXTra/LibGenMobile!";
  double rating = 0;

  /* Code that gets textfield values and sends a support email from settings page */
  TextEditingController userPersonalNameController = TextEditingController();
  TextEditingController userPersonalEmailController = TextEditingController();
  TextEditingController userMessageController = TextEditingController();
  Future sendSupportEmail(String userPersonalName, String userPersonalEmail, String userMessage) async {
    const serviceId = 'service_vg9u6rk';
    const templateId = 'template_kwy2hq4';
    const userId = 'xWP1dnMU5OkksqWIY';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'user_personal_name': userPersonalName,
          'user_personal_email': userPersonalEmail,
          'user_message': userMessage,
        }
      }),
    );
  }

  /* Code that gets the user entered rating and sends an email */
  Future sendRatingEmail(int starRating) async {
    const serviceId = 'service_vg9u6rk';
    const templateId = 'template_ibuiaxo';
    const userId = 'xWP1dnMU5OkksqWIY';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'star_rating': starRating,
        }
      }),
    );
  }

  /* Function that copies info regarding our app to the clipboard */
  void shareOurApp() {
    Clipboard.setData(const ClipboardData(text: shareMessage));
  }

  /* Function that opens the Libgen website in-app */
  void openLibgenSite() async {
    String url = "https://libgen.is/";
    if (!await launch(url)) {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.grey[850],
          centerTitle: true,
          title: const Text(
            "Settings",
            textAlign: TextAlign.center,
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back, color: Colors.white)),
        ),
        body: SafeArea(
            child: Center(
                child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
            Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
              const Text(
                "Options",
                style: TextStyle(fontSize: 27, color: Colors.white),
              ),
              AlertDialogButton(
                  buttonText: "Get Support",
                  titleText: "Send a message to our developers",
                  action: () =>
                      sendSupportEmail(userPersonalNameController.text, userPersonalEmailController.text, userMessageController.text),
                  submitButton: "Send",
                  mainContent: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                    TextField(
                      controller: userPersonalNameController,
                      cursorColor: Colors.red,
                      decoration: const InputDecoration(
                        hintText: "Enter your name",
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    TextField(
                      controller: userPersonalEmailController,
                      cursorColor: Colors.red,
                      decoration: const InputDecoration(
                        hintText: "Enter your email",
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    TextField(
                      controller: userMessageController,
                      cursorColor: Colors.red,
                      decoration: const InputDecoration(
                        hintText: "Enter your message",
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                  ])),
              ElevatedButton(
                style: buttonStyle,
                onPressed: openLibgenSite,
                child: const Text("Visit Website"),
              ),
              AlertDialogButton(
                buttonText: "Share",
                titleText: "Share with your friends!",
                submitButton: "Copy",
                action: shareOurApp,
                mainContent: const Text(shareMessage),
              ),
            ]),
            Column(children: <Widget>[
              const Text(
                "Rate our app",
                style: TextStyle(fontSize: 27, color: Colors.white),
              ),
              FiveStarRating(),
              AlertDialogButton(
                buttonText: "Submit",
                titleText: "Thank you!",
                submitButton: "Ok",
                action: () => sendRatingEmail(_rating),
                mainContent: const Text("Thanks for the rating, it means a lot to our team at Libgen Mobile!"),
              ),
            ]),
            Column(children: const <Widget>[
              Text(
                "About Us",
                style: TextStyle(fontSize: 27, color: Colors.white),
              ),
              Center(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                      child: Text(
                        "We are a small team of five 3rd - 5th year University students at the University of Guelph, and have created this project for our Mobile Development class CIS4030. We believe that everybody should have free access to information, so that was our main inspiration for creating this mobile version of the Libgen Website.",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                        textAlign: TextAlign.justify,
                      ))),
            ]),
            const Text(
              "Â©2022 LIBGEN MOBILE, ALL RIGHTS RESERVED, V1.0",
              style: TextStyle(fontSize: 10, color: Colors.white),
            ),
          ]),
        ))));
  }
}

/* Widget that shows an alert once a button is clicked */
class AlertDialogButton extends StatelessWidget {
  AlertDialogButton(
      {Key? key,
      required this.buttonText,
      required this.titleText,
      required this.submitButton,
      required this.mainContent,
      required this.action})
      : super(key: key);

  final String buttonText;
  final String titleText;
  final String submitButton;
  Widget mainContent;
  final VoidCallback action;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: buttonStyle,
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(titleText),
          content: mainContent,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                action();
                Navigator.pop(context, submitButton);
              },
              child: Text(
                submitButton,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
      child: Text(buttonText),
    );
  }
}

/* Widget that shows a rating from 0 - 5 stars */
class FiveStarRating extends StatefulWidget {
  @override
  _FiveStarRatingState createState() => _FiveStarRatingState();
}

class _FiveStarRatingState extends State<FiveStarRating> {
  void rate(int rating) {
    setState(() {
      _rating = rating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 200,
        height: 30,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                child: Icon(
                  Icons.star,
                  size: 30,
                  color: _rating >= 1 ? Colors.red : Colors.grey,
                ),
                onTap: () => rate(1),
              ),
              GestureDetector(
                child: Icon(
                  Icons.star,
                  size: 30,
                  color: _rating >= 2 ? Colors.red : Colors.grey,
                ),
                onTap: () => rate(2),
              ),
              GestureDetector(
                child: Icon(
                  Icons.star,
                  size: 30,
                  color: _rating >= 3 ? Colors.red : Colors.grey,
                ),
                onTap: () => rate(3),
              ),
              GestureDetector(
                child: Icon(
                  Icons.star,
                  size: 30,
                  color: _rating >= 4 ? Colors.red : Colors.grey,
                ),
                onTap: () => rate(4),
              ),
              GestureDetector(
                child: Icon(
                  Icons.star,
                  size: 30,
                  color: _rating >= 5 ? Colors.red : Colors.grey,
                ),
                onTap: () => rate(5),
              )
            ],
          ),
        ));
  }
}
