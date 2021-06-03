import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Notes extends StatefulWidget {
  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  bool isLoaded = false;
  String content = "";
  List<dynamic> notes = [];
  String uploadedUrl = "";

  Future<bool> fetch() async {
    String teacherEmail = FirebaseAuth.instance.currentUser.email;
    final data = await FirebaseFirestore.instance
        .collection("teachers")
        .doc(teacherEmail)
        .get()
        .then((value) => value.data());
    List<dynamic> n = data["notes"];
    setState(() {
      notes = n;
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
        title: Text("Notebook"),
        centerTitle: true,
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
                                      content = value;
                                    });
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    hintText: 'Enter content',
                                    border: InputBorder.none,
                                  ),
                                ),
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
                                              "${FirebaseAuth.instance.currentUser.email}/notebook/$filename")
                                          .putFile(file);
                                      String url = await downloadUrl.ref
                                          .getDownloadURL();
                                      setState(() {
                                        uploadedUrl = url;
                                      });
                                      setState(() {
                                        notes.insert(0, {
                                          "content": content,
                                          "link": uploadedUrl,
                                          "uploadTime":
                                              Timestamp.fromDate(DateTime.now())
                                        });
                                      });

                                      await FirebaseFirestore.instance
                                          .collection("teachers")
                                          .doc(FirebaseAuth
                                              .instance.currentUser.email)
                                          .update({
                                        "notes": notes
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
                                      "Add without File",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      setState(() {
                                        isLoaded = false;
                                      });
                                      setState(() {
                                        notes.insert(0, {
                                          "content": content,
                                          "link": "",
                                          "uploadTime":
                                              Timestamp.fromDate(DateTime.now())
                                        });
                                      });
                                      await FirebaseFirestore.instance
                                          .collection("teachers")
                                          .doc(FirebaseAuth
                                              .instance.currentUser.email)
                                          .update({
                                        "notes": notes
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
      ),
      body: Container(
        height: height,
        width: width,
        padding: EdgeInsets.all(10),
        child: isLoaded
            ? notes.isEmpty
                ? Center(
                    child: Text("Notebook is empty\n"),
                  )
                : ListView.builder(
                    itemCount: notes.length,
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
                            title: Text(notes[i]["content"]),
                            subtitle: Text(
                                "Uploaded: ${(notes[i]["uploadTime"] as Timestamp).toDate().day}/${(notes[i]["uploadTime"] as Timestamp).toDate().month}/${(notes[i]["uploadTime"] as Timestamp).toDate().year}  ${(notes[i]["uploadTime"] as Timestamp).toDate().hour}:${(notes[i]["uploadTime"] as Timestamp).toDate().minute}"),
                            onTap: () {
                              if (notes[i]["link"] != "") {
                                launch(notes[i]["link"]);
                              }
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
                                                  setState(() {
                                                    notes.removeAt(i);
                                                  });
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("teachers")
                                                      .doc(FirebaseAuth.instance
                                                          .currentUser.email)
                                                      .update({"notes": notes});
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
