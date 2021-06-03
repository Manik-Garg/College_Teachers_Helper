import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isLoaded = false;
  String _name;
  String _email;
  int _phonenum;
  int uploadCount;
  int classCount;

  Future<bool> fetch() async {
    final data = await FirebaseFirestore.instance
        .collection("teachers")
        .doc(FirebaseAuth.instance.currentUser.email)
        .get()
        .then((value) => value.data());
    List<dynamic> classes = await FirebaseFirestore.instance
        .collection("items")
        .doc("classes")
        .get()
        .then((value) => value.data()["classes"]);
    List<dynamic> cnt = [];
    int assCount = 0;
    classes.forEach((element) {
      if (element["teacherID"] == data["email"]) {
        cnt.add(element);
        List<dynamic> allUploads = element["uploads"];
        assCount += allUploads.length;
      }
    });

    _name = data["name"];
    _email = data["email"];
    _phonenum = data["contact"];
    classCount = cnt.length;
    uploadCount = assCount;

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
        title: Text("My Profile"),
        centerTitle: true,
      ),
      body: Container(
        height: height,
        width: width,
        padding: EdgeInsets.all(10),
        child: isLoaded
            ? SingleChildScrollView(
                child: Column(
                  children: [
                     Container(
                        padding: EdgeInsets.all(10.0),
                        width: width * 1,
                        decoration: BoxDecoration(
                            color: Colors.white38,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Column(
                          children: [
                            SizedBox(
                              height: height * 0.04,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Name :",
                                    style: TextStyle(
                                      fontSize: 25.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    _name,
                                    style: TextStyle(
                                      fontSize: 25.0,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Contact :",
                                    style: TextStyle(
                                      fontSize: 25.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    _phonenum.toString(),
                                    style: TextStyle(
                                      fontSize: 25.0,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Email ID:",
                                    style: TextStyle(
                                      fontSize: 25.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    _email,
                                    style: TextStyle(
                                      fontSize: 25.0,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Groups :",
                                    style: TextStyle(
                                      fontSize: 25.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    classCount.toString(),
                                    style: TextStyle(
                                      fontSize: 25.0,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Uploads :",
                                    style: TextStyle(
                                      fontSize: 25.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    uploadCount.toString(),
                                    style: TextStyle(
                                      fontSize: 25.0,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    CircularProgressIndicator(),
                    Text(
                      "\nPlease Wait\nSlow Connection",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20.0,
                      ),
                    ),
                  ]),
      ),
    );
  }
}
