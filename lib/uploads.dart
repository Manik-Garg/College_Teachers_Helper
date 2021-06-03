import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:teacher_helper/assignment.dart';
import 'package:url_launcher/url_launcher.dart';

class Uploads extends StatefulWidget {
  final String groupName;
  final String teacherID;
  final List<dynamic> uploads;

  const Uploads({this.groupName, this.teacherID, this.uploads});

  @override
  _UploadsState createState() => _UploadsState();
}

class _UploadsState extends State<Uploads> {
  bool isLoaded = true;
  String Topic;
  DateTime dueDate;
  Timestamp finalDate;
  TimeOfDay dueTime;
  String uploadedUrl;
  List<dynamic> uploads = [];
  String type;
  List<dynamic> categories = ["Assignment", "Notice", "Marks", "Attendance"];

  @override
  void initState() {
    setState(() {
      uploads = widget.uploads;
      type = categories[0];
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.groupName,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              await showDialog(
                  context: context,
                  builder: (context) => Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        child: Container(
                          height: height * 0.6,
                          width: width * 0.8,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  border: Border.all(
                                      color: Colors.indigo[500], width: 2),
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.all(10),
                                child: TextField(
                                  onChanged: (value) {
                                    setState(() {
                                      Topic = value;
                                    });
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    hintText: 'Enter Topic',
                                    border: InputBorder.none,
                                  ),
                                ),
                                width: width * 0.75,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  border: Border.all(
                                      color: Colors.indigo[500], width: 2),
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.all(10),
                                child: PopupMenuButton(
                                  onSelected: (value) {
                                    setState(() {
                                      type = value;
                                    });
                                  },
                                  child: Center(
                                    child: Text("Select type"),
                                  ),
                                  itemBuilder: (context) {
                                    return List.generate(categories.length,
                                        (index) {
                                      return PopupMenuItem(
                                        child: Text(categories[index]),
                                        value: categories[index],
                                      );
                                    });
                                  },
                                ),
                                width: width * 0.75,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  border: Border.all(
                                      color: Colors.indigo[500], width: 2),
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.all(10),
                                child: FlatButton(
                                    child: Text(
                                      "Set due date & time",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    onPressed: () async {
                                      var date = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime.now()
                                              .add(Duration(days: 30)));
                                      if (date != null) {
                                        setState(() {
                                          dueDate = date;
                                        });
                                        var time = await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay(
                                                hour: 00, minute: 00));
                                        if (time != null) {
                                          setState(() {
                                            dueTime = time;
                                            finalDate = Timestamp.fromDate(
                                                DateTime(
                                                    DateTime.now().year,
                                                    dueDate.month,
                                                    dueDate.day,
                                                    dueTime.hour,
                                                    dueTime.minute));
                                          });
                                        } else {
                                          setState(() {
                                            finalDate = null;
                                          });
                                        }
                                      } else {
                                        setState(() {
                                          finalDate = null;
                                        });
                                      }
                                    }),
                                width: width * 0.75,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                width: width * 0.75,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  color: Colors.indigo[300],
                                ),
                                padding: EdgeInsets.all(5),
                                child: FlatButton(
                                  child: Text(
                                    "Add File & upload",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    setState(() {
                                      isLoaded = false;
                                    });
                                    FilePickerResult result =
                                        await FilePicker.platform.pickFiles();

                                    if (result != null) {
                                      setState(() {
                                        isLoaded = false;
                                      });
                                      File file =
                                          File(result.files.single.path);
                                      String filename = DateTime.now()
                                          .microsecondsSinceEpoch
                                          .toString();
                                      var downloadUrl = await FirebaseStorage
                                          .instance
                                          .ref()
                                          .child(
                                              "${widget.teacherID}/${widget.groupName}/$filename")
                                          .putFile(file);
                                      String url = await downloadUrl.ref
                                          .getDownloadURL();
                                      setState(() {
                                        uploadedUrl = url;
                                      });

                                      var data = await FirebaseFirestore
                                          .instance
                                          .collection("items")
                                          .doc("classes")
                                          .get()
                                          .then((value) => value.data());
                                      List<dynamic> classes = data["classes"];
                                      int index;
                                      for (int i = 0; i < classes.length; i++) {
                                        if (classes[i]["groupName"] ==
                                                widget.groupName &&
                                            classes[i]["teacherID"] ==
                                                widget.teacherID) {
                                          index = i;
                                          break;
                                        }
                                      }
                                      uploads.insert(0, {
                                        "content": Topic,
                                        "dueDate": finalDate,
                                        "link": uploadedUrl,
                                        "type": type,
                                        "submissions": [],
                                        "uploadTime":
                                            Timestamp.fromDate(DateTime.now())
                                      });
                                      classes[index]["uploads"] = uploads;
                                      await FirebaseFirestore.instance
                                          .collection("items")
                                          .doc("classes")
                                          .update({
                                        "classes": classes
                                      }).whenComplete(() {
                                        setState(() {
                                          isLoaded = true;
                                        });
                                      });
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                width: width * 0.75,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  color: Colors.indigo[300],
                                ),
                                padding: EdgeInsets.all(5),
                                child: FlatButton(
                                    child: Text(
                                      "Upload without File",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      setState(() {
                                        isLoaded = false;
                                      });
                                      var data = await FirebaseFirestore
                                          .instance
                                          .collection("items")
                                          .doc("classes")
                                          .get()
                                          .then((value) => value.data());
                                      List<dynamic> classes = data["classes"];
                                      int index;
                                      for (int i = 0; i < classes.length; i++) {
                                        if (classes[i]["groupName"] ==
                                                widget.groupName &&
                                            classes[i]["teacherID"] ==
                                                widget.teacherID) {
                                          index = i;
                                          break;
                                        }
                                      }
                                      uploads.insert(0, {
                                        "content": Topic,
                                        "link": "",
                                        "type": type,
                                        "dueDate": finalDate,
                                        "uploadTime":
                                            Timestamp.fromDate(DateTime.now())
                                      });
                                      classes[index]["uploads"] = uploads;
                                      await FirebaseFirestore.instance
                                          .collection("items")
                                          .doc("classes")
                                          .update({
                                        "classes": classes
                                      }).whenComplete(() {
                                        setState(() {
                                          isLoaded = true;
                                        });
                                      });
                                    }),
                              )
                            ],
                          ),
                        ),
                      ));
            },
          )
        ],
        centerTitle: true,
      ),
      body: Container(
        height: height,
        width: width,
        padding: EdgeInsets.all(10),
        child: isLoaded
            ? widget.uploads.isEmpty
                ? Center(
                    child: Text("Nothing uploaded yet."),
                  )
                : ListView.builder(
                    itemCount: widget.uploads.length,
                    itemBuilder: (context, i) {
                      return Container(
                          width: width * 0.8,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey[500], width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          margin: EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            title: Text(widget.uploads[i]["content"]),
                            subtitle: Text(widget.uploads[i]["type"] ==
                                    "Assignment"
                                ? widget.uploads[i]["dueDate"] != null
                                    ? "Due: ${(widget.uploads[i]["dueDate"] as Timestamp).toDate().day}/${(widget.uploads[i]["dueDate"] as Timestamp).toDate().month}/${(widget.uploads[i]["dueDate"] as Timestamp).toDate().year}  ${(widget.uploads[i]["dueDate"] as Timestamp).toDate().hour}:${(widget.uploads[i]["dueDate"] as Timestamp).toDate().minute}"
                                    : "No due date"
                                : "Uploaded: ${(widget.uploads[i]["uploadTime"] as Timestamp).toDate().day}/${(widget.uploads[i]["uploadTime"] as Timestamp).toDate().month}/${(widget.uploads[i]["uploadTime"] as Timestamp).toDate().year}  ${(widget.uploads[i]["uploadTime"] as Timestamp).toDate().hour}:${(widget.uploads[i]["uploadTime"] as Timestamp).toDate().minute}"),
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Assignments(
                                            groupName: widget.groupName,
                                            teacherID: widget.teacherID,
                                            assignmentName: widget.uploads[i]
                                                ["content"],
                                            assignmentUrl: widget.uploads[i]
                                                ["link"],
                                          )));
                            },
                            trailing: IconButton(
                              onPressed: () async {
                                await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text(
                                              "Are you sure you want to DELETE this?"),
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
                                                  int index;
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
                                                            widget.groupName &&
                                                        e["teacherID"] ==
                                                            widget.teacherID) {
                                                      index = j;
                                                      break;
                                                    }
                                                  }
                                                  uploads.removeAt(i);
                                                  classes[index]["uploads"] =
                                                      uploads;
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
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    CircularProgressIndicator(),
                    Text("\n\nPlease Wait\nSlow Connection")
                  ]),
      ),
    );
  }
}
