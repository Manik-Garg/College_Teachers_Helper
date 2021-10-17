import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Assignments extends StatefulWidget {
  final String groupName;
  final String teacherID;
  final String assignmentUrl;
  final String assignmentName;

  const Assignments(
      {this.groupName,
      this.teacherID,
      this.assignmentUrl,
      this.assignmentName});

  @override
  _AssignmentsState createState() => _AssignmentsState();
}

class _AssignmentsState extends State<Assignments> {
  bool isLoaded = false;
  List<dynamic> assignments = [];
  List<dynamic> comments = [];

  Future<bool> fetch() async {
    String teacherEmail = FirebaseAuth.instance.currentUser.email;
    final data = await FirebaseFirestore.instance
        .collection("items")
        .doc("classes")
        .get()
        .then((value) => value.data());
    List<dynamic> classes = data["classes"];
    List<dynamic> a = [];
    List<dynamic> cmnts = [];

    classes.forEach((element) {
      if (element["teacherID"] == widget.teacherID &&
          element["groupName"] == widget.groupName) {
        List<dynamic> all = element["uploads"];
        all.forEach((e) {
          if (e["type"] == "Assignment" &&
              e["content"] == widget.assignmentName) {
            a = e["submissions"];
            cmnts = e["comments"];
          }
        });
      }
    });
    setState(() {
      assignments = a;
      comments = cmnts;
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
        title: Text("Submissions"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.message_outlined,
              color: Colors.white,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        height: height,
        width: width,
        padding: EdgeInsets.all(10),
        child: isLoaded
            ? assignments.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        Text("Topic: " + widget.assignmentName),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: 'To Download Assignment ',
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
                        Text("No submissions yet."),
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
                                  text: 'To Download Assignment ',
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
                          itemCount: assignments.length,
                          itemBuilder: (context, i) {
                            return Container(
                                width: width * 0.8,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey[500], width: 2),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                margin: EdgeInsets.only(top: 8),
                                child: ListTile(
                                  title: Center(
                                      child: Text(assignments[i]["rollnum"]
                                          .toString())),
                                  subtitle: Text(
                                      "Uploaded: ${(assignments[i]["uploadTime"] as Timestamp).toDate().day}/${(assignments[i]["uploadTime"] as Timestamp).toDate().month}/${(assignments[i]["uploadTime"] as Timestamp).toDate().year}  ${(assignments[i]["uploadTime"] as Timestamp).toDate().hour}:${(assignments[i]["uploadTime"] as Timestamp).toDate().minute}"),
                                  onTap: () async {
                                    if (assignments[i]["link"] != "") {
                                      await canLaunch(assignments[i]["link"])
                                          ? await launch(assignments[i]["link"])
                                          : print('Could not launch');
                                    }
                                  },
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
