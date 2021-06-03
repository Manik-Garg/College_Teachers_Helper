import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teacher_helper/students.dart';
import 'package:teacher_helper/uploads.dart';

class Groups extends StatefulWidget {
  @override
  _GroupsState createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  bool isLoaded = false;
  List<dynamic> groups = [];

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
        groups.add(element);
      }
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
        title: Text("Your Groups"),
        centerTitle: true,
      ),
      body: Container(
        height: height,
        width: width,
        padding: EdgeInsets.all(10),
        child: isLoaded
            ? groups.isEmpty
                ? Center(
                    child: Text("You have not created\n\nany groups yet."),
                  )
                : ListView.builder(
                    itemCount: groups.length,
                    itemBuilder: (context, i) {
                      return Container(
                          width: width * 0.8,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey[500], width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          margin: EdgeInsets.only(top: 8),
                          child: ListTile(
                            title: Center(child: Text(groups[i]["groupName"])),
                            leading: IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Students(
                                              students: groups[i]["students"],
                                            )));
                              },
                              icon: Icon(
                                Icons.person,
                                color: Colors.grey[600],
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Uploads(
                                            groupName: groups[i]["groupName"],
                                            teacherID: groups[i]["teacherID"],
                                            uploads: groups[i]["uploads"],
                                          )));
                            },
                            trailing: IconButton(
                              onPressed: () async {
                                await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text(
                                              "Are you sure you want to DELETE this group?"),
                                          actions: [
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("No")),
                                            FlatButton(
                                                onPressed: () async {
                                                  setState(() {
                                                    isLoaded = false;
                                                  });
                                                  Navigator.pop(context);
                                                  List<dynamic> classes =
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection("items")
                                                          .doc("classes")
                                                          .get()
                                                          .then((value) =>
                                                              value.data()[
                                                                  "classes"]);
                                                  for (int j = 0;
                                                      j < classes.length;
                                                      j++) {
                                                    var e = classes[j];
                                                    if (e["groupName"] ==
                                                            groups[i]
                                                                ["groupName"] &&
                                                        e["teacherID"] ==
                                                            groups[i]
                                                                ["teacherID"]) {
                                                      classes.removeAt(j);
                                                      setState(() {
                                                        groups.removeAt(i);
                                                      });
                                                      break;
                                                    }
                                                  }
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("items")
                                                      .doc("classes")
                                                      .update(
                                                          {"classes": classes});
                                                  setState(() {
                                                    isLoaded = true;
                                                  });
                                                },
                                                child: Text("Yes")),
                                          ],
                                        ));
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ));
                    },
                  )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
