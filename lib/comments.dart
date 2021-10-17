import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Comments extends StatefulWidget {
  final String groupName;
  final String teacherID;
  final String assignmentUrl;
  final String assignmentName;

  const Comments(
      {this.groupName,
      this.teacherID,
      this.assignmentUrl,
      this.assignmentName});

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  bool isLoaded = false;
  List<dynamic> Comments = [];

  Future<bool> fetch() async {
    final data = await FirebaseFirestore.instance
        .collection("items")
        .doc("classes")
        .get()
        .then((value) => value.data());
    List<dynamic> classes = data["classes"];
    List<dynamic> cmnts = [];

    classes.forEach((element) {
      if (element["teacherID"] == widget.teacherID &&
          element["groupName"] == widget.groupName) {
        List<dynamic> all = element["uploads"];
        all.forEach((e) {
          if (e["type"] == "Video Lecture" &&
              e["content"] == widget.assignmentName) {
            cmnts = e["comments"];
          }
        });
      }
    });
    setState(() {
      Comments = cmnts;
    });
    return true;
  }

  @override
  void initState() {
    fetch().whenComplete(() {
      setState(() {
        isLoaded = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
        centerTitle: true,
      ),
      body: Container(
        height: height,
        width: width,
        padding: EdgeInsets.all(10),
        child: isLoaded
            ? Comments.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        Text("Topic: " + widget.assignmentName),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: 'To Download ',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.red)),
                              TextSpan(
                                  text: 'click here',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      launch(widget.assignmentUrl);
                                    })
                            ],
                          ),
                        ),
                        Text("No comments yet."),
                      ])
                : Column(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  "Topic: ",
                                  style: TextStyle(fontSize: 20),
                                )),
                                Expanded(
                                    child: Text(widget.assignmentName,
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.blue[700]))),
                              ],
                            ),
                          )),
                      Expanded(
                        flex: 1,
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: 'To Download ',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.red,
                                  )),
                              TextSpan(
                                  text: 'click here',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      launch(widget.assignmentUrl);
                                    })
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        flex: 15,
                        child: ListView.builder(
                          itemCount: Comments.length,
                          itemBuilder: (context, i) {
                            return Container(
                                width: width * 0.8,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey[500], width: 2),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                margin: EdgeInsets.only(top: 8),
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    Text(Comments[i]["comment"].toString()),
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                                      Text(Comments[i]["rollnum"].toString()),
                                      Text(
                                          "Uploaded: ${(Comments[i]["uploadTime"] as Timestamp).toDate().day}/${(Comments[i]["uploadTime"] as Timestamp).toDate().month}/${(Comments[i]["uploadTime"] as Timestamp).toDate().year}  ${(Comments[i]["uploadTime"] as Timestamp).toDate().hour}:${(Comments[i]["uploadTime"] as Timestamp).toDate().minute}"),
                                    ]),
                                  ],
                                ));
                          },
                        ),
                      ),
                    ],
                  )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
