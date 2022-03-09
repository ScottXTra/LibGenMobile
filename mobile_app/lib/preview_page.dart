import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:simple_shadow/simple_shadow.dart';

/** 
 * DUMMY DATA : List Dummy_data
 * 
 */
List dummy_data = [
  {
    "image": "https://images-na.ssl-images-amazon.com/images/I/91RQ5d-eIqL.jpg",
    "author": "Rick Riordan",
    "title": "The Lightning Thief",
  },
  {
    "image": "https://images-na.ssl-images-amazon.com/images/I/9117OFw0G4L.jpg",
    "author": "Rick Riordan",
    "title": "The Sea of Monsters",
  },
  {
    "image": "https://images-na.ssl-images-amazon.com/images/I/918s2eM4pSL.jpg",
    "author": "Rick Riordan",
    "title": "The Last Olympian",
  },
];

/** 
Page Author: Maaz Syed
*/
class Preview_page extends StatefulWidget {
  @override
  State<Preview_page> createState() => _Preview_page();
}

/*This class will generate horizontal cards that can 
be scrolled on either direction based on length of 
the previous search results */
class _Preview_page extends State<Preview_page> {
  /** Temporary styles using here for now, can be moved somewhere else later */
  titles() => const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white);
  info() => const TextStyle(fontSize: 14, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    /** Grab any accurate device dimensions */
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        /** We want to have cards that can be scrolled horizontally 
         * while allowing the user to snap the card in place
        */
        body: PageView.builder(
            itemCount: dummy_data.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: height,
                width: width,
                child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    color: Colors.grey[850],
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.zero,
                      children: [
                        /*X icon on the top right of the card */
                        Padding(
                          padding: EdgeInsets.only(top: 10.0, right: 10.0),
                          child: Align(
                              alignment: Alignment.topRight,
                              child: IconButton(onPressed: () {}, icon: Icon(Icons.cancel, color: Colors.grey[400]))),
                        ),
                        /* The main image for the book*/
                        Align(
                            alignment: Alignment.topCenter,
                            child: SimpleShadow(
                                opacity: 0.1,
                                color: Colors.white,
                                offset: const Offset(5, 5),
                                sigma: 10,
                                child: Image.network(dummy_data[index]["image"], width: 250, height: 500))),
                        /*Any further  information regarding the author*/
                        Column(
                          children: [
                            Text(dummy_data[index]["title"], style: titles()),
                            Container(height: 10),
                            Text(
                              dummy_data[index]["author"],
                              style: info(),
                            ),
                            Container(height: 55),

                            /* Container responsible for the elevated button*/
                            Container(
                              padding: const EdgeInsets.only(bottom: 30),
                              width: width - 30,
                              height: 80,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))),
                                onPressed: () {},
                                child: Text("ADD TO LIBRARY"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
              );
            }));
  }
}
