import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

/* Generic button styling settings */
final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
  minimumSize: const Size(200, 0),
  padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
  primary: Colors.green,
  textStyle: const TextStyle(fontSize: 17),
);

/* Main page that has settings and extra info */
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const String shareMessage =
      "Visit our github repository for Libgen Mobile at: https://github.com/ScottXTra/LibGenMobile!";
  double rating = 0;

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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.red,
          centerTitle: true,
          title: const Text(
            "Settings",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 35),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back, color: Colors.white)),
        ),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Options",
                        style: TextStyle(fontSize: 27),
                      ),
                      AlertDialogButton(
                          buttonText: "Get Support",
                          titleText: "Send a message to our developers",
                          action: shareOurApp,
                          submitButton: "Send",
                          mainContent: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const <Widget>[
                                TextField(
                                  cursorColor: Colors.red,
                                  decoration: InputDecoration(
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
                                  cursorColor: Colors.red,
                                  decoration: InputDecoration(
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
                                  cursorColor: Colors.red,
                                  decoration: InputDecoration(
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
                    style: TextStyle(fontSize: 27),
                  ),
                  FiveStarRating(),
                  AlertDialogButton(
                    buttonText: "Submit",
                    titleText: "Thank you!",
                    submitButton: "Ok",
                    action: shareOurApp,
                    mainContent: const Text(
                        "Thanks for the rating, it means a lot to our team at Libgen Mobile!"),
                  ),
                ]),
                Column(children: const <Widget>[
                  Text(
                    "About Us",
                    style: TextStyle(fontSize: 27),
                  ),
                  Center(
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                          child: Text(
                            "We are a small team of five 3rd and 4th year University students at the University of Guelph, and have created this project for our Mobile Development class CIS4030. We believe that everybody should have free access to information, so that was our main inspiration for creating this mobile version of the Libgen Website.",
                            style: TextStyle(fontSize: 15),
                            textAlign: TextAlign.justify,
                          ))),
                ]),
                const Text(
                  "©2022 LIBGEN MOBILE, ALL RIGHTS RESERVED, V1.0",
                  style: TextStyle(fontSize: 10),
                ),
              ]),
        )));
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
  int _rating = 0;

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
