import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TnP extends StatefulWidget {
  @override
  _TnPState createState() => _TnPState();
}

class _TnPState extends State<TnP> {
  bool isLoaded = false;
  List<dynamic> items = [];
  String uploadedUrl = "";
  bool fromTPO = false;

  Future<bool> fetch() async {
    String teacherEmail = FirebaseAuth.instance.currentUser.email;
    final data = await FirebaseFirestore.instance
        .collection("teachers")
        .doc(teacherEmail)
        .get()
        .then((value) => value.data());
    bool check = data["fromTPO"];
    final data1 = await FirebaseFirestore.instance
        .collection("items")
        .doc("TPO")
        .get()
        .then((value) => value.data());
    setState(() {
      fromTPO = check;
      items = data1["items"] as List<dynamic>;
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
        title: Text("T&P Section"),
        centerTitle: true,
        actions: [
          // IconButton(
          //   icon: Icon(Icons.add),
          //   onPressed: () async {
          //     await showDialog(
          //         context: context,
          //         builder: (context) => Dialog(
          //               shape: RoundedRectangleBorder(
          //                   borderRadius:
          //                       BorderRadius.all(Radius.circular(20.0))),
          //               child: Container(
          //                 height: height * 0.6,
          //                 width: width * 0.8,
          //                 decoration: BoxDecoration(
          //                     color: Colors.white,
          //                     borderRadius:
          //                         BorderRadius.all(Radius.circular(20))),
          //                 child: Column(
          //                   mainAxisAlignment: MainAxisAlignment.center,
          //                   crossAxisAlignment: CrossAxisAlignment.center,
          //                   children: [
          //                     Container(
          //                       decoration: BoxDecoration(
          //                         borderRadius:
          //                             BorderRadius.all(Radius.circular(20)),
          //                         border: Border.all(
          //                             color: Colors.indigo[500], width: 2),
          //                         color: Colors.white,
          //                       ),
          //                       padding: EdgeInsets.all(10),
          //                       child: TextField(
          //                         onChanged: (value) {
          //                           setState(() {
          //                             content = value;
          //                           });
          //                         },
          //                         keyboardType: TextInputType.emailAddress,
          //                         decoration: InputDecoration(
          //                           hintText: 'Enter content',
          //                           border: InputBorder.none,
          //                         ),
          //                       ),
          //                       width: width * 0.75,
          //                     ),
          //                     SizedBox(
          //                       height: 15,
          //                     ),
          //                     Container(
          //                       width: width * 0.75,
          //                       decoration: BoxDecoration(
          //                         borderRadius:
          //                             BorderRadius.all(Radius.circular(20)),
          //                         color: Colors.indigo[300],
          //                       ),
          //                       padding: EdgeInsets.all(5),
          //                       child: FlatButton(
          //                         child: Text(
          //                           "Add File & upload",
          //                           style: TextStyle(fontSize: 20),
          //                         ),
          //                         onPressed: () async {
          //                           Navigator.pop(context);
          //                           setState(() {
          //                             isLoaded = false;
          //                           });
          //                           FilePickerResult result =
          //                               await FilePicker.platform.pickFiles();
          //
          //                           if (result != null) {
          //                             setState(() {
          //                               isLoaded = false;
          //                             });
          //                             File file =
          //                                 File(result.files.single.path);
          //                             String filename = DateTime.now()
          //                                 .microsecondsSinceEpoch
          //                                 .toString();
          //                             var downloadUrl = await FirebaseStorage
          //                                 .instance
          //                                 .ref()
          //                                 .child(
          //                                     "${FirebaseAuth.instance.currentUser.email}/notebook/$filename")
          //                                 .putFile(file);
          //                             String url = await downloadUrl.ref
          //                                 .getDownloadURL();
          //                             setState(() {
          //                               uploadedUrl = url;
          //                             });
          //                             setState(() {
          //                               notes.insert(0, {
          //                                 "content": content,
          //                                 "link": uploadedUrl,
          //                                 "uploadTime":
          //                                     Timestamp.fromDate(DateTime.now())
          //                               });
          //                             });
          //
          //                             await FirebaseFirestore.instance
          //                                 .collection("teachers")
          //                                 .doc(FirebaseAuth
          //                                     .instance.currentUser.email)
          //                                 .update({
          //                               "notes": notes
          //                             }).whenComplete(() {
          //                               setState(() {
          //                                 isLoaded = true;
          //                               });
          //                             });
          //                           }
          //                         },
          //                       ),
          //                     ),
          //                     SizedBox(
          //                       height: 15,
          //                     ),
          //                     Container(
          //                       width: width * 0.75,
          //                       decoration: BoxDecoration(
          //                         borderRadius:
          //                             BorderRadius.all(Radius.circular(20)),
          //                         color: Colors.indigo[300],
          //                       ),
          //                       padding: EdgeInsets.all(5),
          //                       child: FlatButton(
          //                           child: Text(
          //                             "Add without File",
          //                             style: TextStyle(fontSize: 20),
          //                           ),
          //                           onPressed: () async {
          //                             Navigator.pop(context);
          //                             setState(() {
          //                               isLoaded = false;
          //                             });
          //                             setState(() {
          //                               notes.insert(0, {
          //                                 "content": content,
          //                                 "link": "",
          //                                 "uploadTime":
          //                                     Timestamp.fromDate(DateTime.now())
          //                               });
          //                             });
          //                             await FirebaseFirestore.instance
          //                                 .collection("teachers")
          //                                 .doc(FirebaseAuth
          //                                     .instance.currentUser.email)
          //                                 .update({
          //                               "notes": notes
          //                             }).whenComplete(() {
          //                               setState(() {
          //                                 isLoaded = true;
          //                               });
          //                             });
          //                           }),
          //                     )
          //                   ],
          //                 ),
          //               ),
          //             ));
          //   },
          // )
        ],
      ),
      body: Container(
        height: height,
        width: width,
        padding: EdgeInsets.all(10),
        child: isLoaded
            ? items.isEmpty
                ? Center(
                    child: Text("Nothing uploaded yet."),
                  )
                : ListView.builder(
                    itemCount: items.length,
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
                            title: Text(items[i]["companyName"]),
                            subtitle: Text(
                                "Uploaded: ${(items[i]["uploadTime"] as Timestamp).toDate().day}/${(items[i]["uploadTime"] as Timestamp).toDate().month}/${(items[i]["uploadTime"] as Timestamp).toDate().year}  ${(items[i]["uploadTime"] as Timestamp).toDate().hour}:${(items[i]["uploadTime"] as Timestamp).toDate().minute}"),
                            onTap: () {},
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
