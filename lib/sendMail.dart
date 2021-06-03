import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class SendMail extends StatefulWidget {
  @override
  _SendMailState createState() => _SendMailState();
}

class _SendMailState extends State<SendMail> {
  bool isLoaded = false;
  List<dynamic> groups = [];
  List<dynamic> groupsData = [];
  String selectedGroup;
  int selectedIndex;
  List<String> people = ["Students", "Parents"];
  int selectedPeople = 0;
  List<String> recs = [];
  String title = "";

  String content = "";

  Future<bool> sendMail() async {
    setState(() {
      isLoaded = false;
    });
    List<dynamic> t1 = groupsData[selectedIndex]["students"];
    t1.forEach((element) {
      recs.add(element[selectedPeople == 0 ? "email" : "parentemail"]);
    });
    final Email email = Email(
      body: content,
      subject: title,
      recipients: recs,
      attachmentPaths: [],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
      return true;
    } catch (error) {
      print(error.toString());
      return false;
    }
  }

  Future<bool> fetch() async {
    String teacherEmail = FirebaseAuth.instance.currentUser.email;
    final data = await FirebaseFirestore.instance
        .collection("items")
        .doc("classes")
        .get()
        .then((value) => value.data());
    List<dynamic> classes = data["classes"];
    classes.forEach((element) {
      if (element["teacherID"] == teacherEmail) {
        groupsData.add(element);
        groups.add(element["groupName"]);
      }
    });
    groups.length != 0 ? selectedIndex = 0 : null;
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
          title: Text("Send Mail"),
          centerTitle: true,
        ),
        body: Container(
            height: height,
            width: width,
            child: isLoaded
                ? selectedIndex == null
                    ? Center(
                        child: Text("You have to create a group first"),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: height * 0.03,
                            ),
                            Container(
                              height: height * 0.08,
                              width: width * 0.8,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  border: Border.all(
                                      color: Colors.grey[500], width: 2)),
                              child: ListTile(
                                title: Text(
                                    groupsData[selectedIndex]["groupName"]),
                                trailing: PopupMenuButton(
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.black,
                                    ),
                                    onSelected: (value) {
                                      setState(() {
                                        selectedIndex = value;
                                      });
                                    },
                                    itemBuilder: (context) {
                                      return List.generate(groups.length,
                                          (index) {
                                        return PopupMenuItem(
                                          child: Text(groups[index]),
                                          value: index,
                                        );
                                      });
                                    }),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            Container(
                              height: height * 0.08,
                              width: width * 0.8,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  border: Border.all(
                                      color: Colors.grey[500], width: 2)),
                              child: ListTile(
                                title: Text(people[selectedPeople]),
                                trailing: PopupMenuButton(
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.black,
                                    ),
                                    onSelected: (value) {
                                      setState(() {
                                        selectedPeople = value;
                                      });
                                    },
                                    itemBuilder: (context) {
                                      return List.generate(people.length,
                                          (index) {
                                        return PopupMenuItem(
                                          child: Text(people[index]),
                                          value: index,
                                        );
                                      });
                                    }),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            Container(
                              width: width * 0.8,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  border: Border.all(
                                      color: Colors.grey[500], width: 2)),
                              child: TextField(
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Title"),
                                keyboardType: TextInputType.text,
                                onChanged: (value) {
                                  setState(() {
                                    title = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            Container(
                              height: height * 0.25,
                              width: width * 0.8,
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 8),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  border: Border.all(
                                      color: Colors.grey[500], width: 2)),
                              child: TextField(
                                maxLines: null,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Message"),
                                keyboardType: TextInputType.text,
                                onChanged: (value) {
                                  setState(() {
                                    content = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            Container(
                              width: width * 0.8,
                              decoration: BoxDecoration(
                                  color: Colors.blue[300],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: FlatButton(
                                child: Text("Send",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                                onPressed: () async {
                                  bool result = await sendMail().then((value) {
                                    setState(() {
                                      isLoaded = true;
                                    });
                                    return value;
                                  });
                                  await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: Text(result
                                                ? "Mail Sent"
                                                : "Cannot send mail"),
                                            actions: [
                                              FlatButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("OK"))
                                            ],
                                          ));
                                },
                              ),
                            )
                          ],
                        ),
                      )
                : Center(
                    child: CircularProgressIndicator(),
                  )));
  }
}
