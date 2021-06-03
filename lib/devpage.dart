import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OurDevelopers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("About Developer")),
      ),
      body: Container(
        height: height,
        width: width,
        child: SingleChildScrollView(
          child:  Column(
              children: [
                SizedBox(
                  height: height * 0.04,
                ),
                Container(
                  height: width * 0.3,
                  width: width * 0.3,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: Image(
                    image: AssetImage("img/coolboi.jpg"),
                  ),
                ),
                SizedBox(
                  height: height * 0.04,
                ),
                Container(
                    child: Text(
                  "Name: Manik Garg",
                  style: TextStyle(fontSize: 20.0, color: Colors.black),
                )),
                SizedBox(
                  height: height * 0.02,
                ),
                Container(
                  child: Text(
                    "College: J.C. Bose UST YMCA",
                    style: TextStyle(fontSize: 20.0, color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Container(
                  child: Row(
                    children: [
                      SizedBox(
                        width: width * 0.20,
                      ),
                      Text(
                        "Email: ",
                        style: TextStyle(fontSize: 20.0, color: Colors.black),
                      ),
                      SizedBox(
                        width: width * 0.02,
                      ),
                      Icon(
                        Icons.email,
                      ),
                      SizedBox(
                        width: width * 0.01,
                      ),
                      Text("manikgarg2000@gmail.com")
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.1,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'For twitter,  ',
                            style:
                                TextStyle(fontSize: 20, color: Colors.black)),
                        TextSpan(
                            text: 'click here',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.lightBlueAccent,
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                launch('https://twitter.com/MGarg16');
                              })
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'For LinkedIn,  ',
                            style:
                                TextStyle(fontSize: 20, color: Colors.black)),
                        TextSpan(
                            text: 'click here',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.lightBlueAccent,
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                launch(
                                    'https://www.linkedin.com/in/manik-garg-5060a4172/');
                              })
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'For instagram,  ',
                            style:
                                TextStyle(fontSize: 20, color: Colors.black)),
                        TextSpan(
                            text: 'click here',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.lightBlueAccent,
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                launch(
                                    'https://www.instagram.com/its_manikgarg/');
                              })
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
