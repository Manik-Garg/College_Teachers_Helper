import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:teacher_helper/TnPSection.dart';
import 'package:teacher_helper/addOpp.dart';
import 'package:teacher_helper/devpage.dart';
import 'package:teacher_helper/groups.dart';
import 'package:teacher_helper/notes.dart';
import 'package:teacher_helper/profile.dart';
import 'package:teacher_helper/register.dart';
import 'package:teacher_helper/sendMail.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String groupName = "";
  bool fromTPO = false, isLoaded = false;
  String userName = "";

  Future<Null> fetch() async {
    var data = await FirebaseFirestore.instance
        .collection("teachers")
        .doc(FirebaseAuth.instance.currentUser.email)
        .get()
        .then((value) => value.data());
    setState(() {
      userName = data["name"];
      fromTPO = data["fromTPO"];
    });
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
          title: Text(
            "Welcome $userName",
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                FirebaseAuth.instance.signOut().whenComplete(() {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Register()));
                });
              },
            )
          ]),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                child: Container(
              height: height * 0.3,
              width: double.infinity,
              child: Image(
                image: AssetImage("img/logo.png"),
              ),
            )),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(
                    width: width * 0.02,
                  ),
                  Text(
                    "My Profile",
                    style: TextStyle(fontSize: 20, color: Colors.blue),
                  )
                ],
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Profile()));
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.group),
                  SizedBox(
                    width: width * 0.02,
                  ),
                  Text(
                    "Your Groups",
                    style: TextStyle(fontSize: 20, color: Colors.blue),
                  )
                ],
              ),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Groups()));
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.mail_outline),
                  SizedBox(
                    width: width * 0.02,
                  ),
                  Text(
                    "Send Mail",
                    style: TextStyle(fontSize: 20, color: Colors.blue),
                  )
                ],
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SendMail()));
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.notes),
                  SizedBox(
                    width: width * 0.02,
                  ),
                  Text(
                    "Notebook",
                    style: TextStyle(fontSize: 20, color: Colors.blue),
                  )
                ],
              ),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Notes()));
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(
                    width: width * 0.02,
                  ),
                  Text(
                    "About Developer",
                    style: TextStyle(fontSize: 20, color: Colors.blue),
                  )
                ],
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OurDevelopers()));
              },
            ),
            ListTile(
                title: Row(
                  children: [
                    Icon(Icons.exit_to_app),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    Text(
                      "Sign Out",
                      style: TextStyle(fontSize: 20, color: Colors.blue),
                    )
                  ],
                ),
                onTap: () {
                  FirebaseAuth.instance.signOut().whenComplete(
                    () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Register()));
                    },
                  );
                })
          ],
        ),
      ),
      body: Container(
        height: height,
        width: width,
        child: isLoaded
            ? SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: height * 0.05,
                      ),
                      Container(
                        height: width * 0.4,
                        width: width * 0.4,
                        child: Image.asset(
                          "img/logo.png",
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      // Container(
                      //   height: height * 0.08,
                      //   width: width * 0.8,
                      //   padding: EdgeInsets.all(5),
                      //   decoration: BoxDecoration(
                      //       color: Colors.grey[500],
                      //       border: Border.all(color: Colors.black, width: 2.0),
                      //       borderRadius:
                      //           BorderRadius.all(Radius.circular(20))),
                      //   child: FlatButton(
                      //     child: Text(
                      //       "Create Group",
                      //       style: TextStyle(fontSize: 20),
                      //     ),
                      //     onPressed: () async {
                      //       await showDialog(
                      //           context: context,
                      //           builder: (context) => Dialog(
                      //                 shape: RoundedRectangleBorder(
                      //                     borderRadius: BorderRadius.all(
                      //                         Radius.circular(20.0))),
                      //                 child: Container(
                      //                   height: height * 0.3,
                      //                   width: width * 0.8,
                      //                   decoration: BoxDecoration(
                      //                       color: Colors.white,
                      //                       borderRadius: BorderRadius.all(
                      //                           Radius.circular(20))),
                      //                   child: Column(
                      //                     mainAxisAlignment:
                      //                         MainAxisAlignment.center,
                      //                     crossAxisAlignment:
                      //                         CrossAxisAlignment.center,
                      //                     children: [
                      //                       Container(
                      //                         decoration: BoxDecoration(
                      //                           borderRadius: BorderRadius.all(
                      //                               Radius.circular(20)),
                      //                           border: Border.all(
                      //                               color: Colors.indigo[500],
                      //                               width: 2),
                      //                           color: Colors.white,
                      //                         ),
                      //                         padding: EdgeInsets.all(10),
                      //                         child: TextField(
                      //                           onChanged: (value) {
                      //                             setState(() {
                      //                               groupName = value;
                      //                             });
                      //                           },
                      //                           keyboardType:
                      //                               TextInputType.emailAddress,
                      //                           decoration: InputDecoration(
                      //                             hintText: 'Enter Group Name',
                      //                             border: InputBorder.none,
                      //                           ),
                      //                         ),
                      //                         width: width * 0.75,
                      //                       ),
                      //                       SizedBox(
                      //                         height: 15,
                      //                       ),
                      //                       Container(
                      //                         width: width * 0.75,
                      //                         decoration: BoxDecoration(
                      //                           borderRadius: BorderRadius.all(
                      //                               Radius.circular(20)),
                      //                           color: Colors.indigo[300],
                      //                         ),
                      //                         padding: EdgeInsets.all(5),
                      //                         child: FlatButton(
                      //                           child: Text(
                      //                             "Create Group",
                      //                             style:
                      //                                 TextStyle(fontSize: 20),
                      //                           ),
                      //                           onPressed: () async {
                      //                             if (groupName == "" ||
                      //                                 groupName == null) {
                      //                               await showDialog(
                      //                                   context: context,
                      //                                   builder: (context) =>
                      //                                       AlertDialog(
                      //                                         title: Text(
                      //                                             "Please Enter correct name."),
                      //                                         actions: [
                      //                                           FlatButton(
                      //                                             child: Text(
                      //                                                 "Ok"),
                      //                                             onPressed:
                      //                                                 () {
                      //                                               Navigator.pop(
                      //                                                   context);
                      //                                             },
                      //                                           )
                      //                                         ],
                      //                                       ));
                      //                             } else {
                      //                               setState(() {
                      //                                 isLoaded = false;
                      //                               });
                      //                               String teacherEmail =
                      //                                   FirebaseAuth.instance
                      //                                       .currentUser.email;
                      //                               final teacherName =
                      //                                   await FirebaseFirestore
                      //                                       .instance
                      //                                       .collection(
                      //                                           "teachers")
                      //                                       .doc(teacherEmail)
                      //                                       .get()
                      //                                       .then((value) =>
                      //                                           value.data()[
                      //                                               "name"]);
                      //                               final Data =
                      //                                   await FirebaseFirestore
                      //                                       .instance
                      //                                       .collection("items")
                      //                                       .doc("classes")
                      //                                       .get()
                      //                                       .then((value) =>
                      //                                           value.data());
                      //                               List<dynamic> classes =
                      //                                   Data["classes"];
                      //                               bool already = false;
                      //                               for (int j = 0;
                      //                                   j < classes.length;
                      //                                   j++) {
                      //                                 if (classes[j][
                      //                                             "groupName"] ==
                      //                                         groupName &&
                      //                                     classes[j][
                      //                                             "teacherID"] ==
                      //                                         teacherEmail) {
                      //                                   already = true;
                      //                                   break;
                      //                                 }
                      //                               }
                      //                               if (!already) {
                      //                                 classes.add({
                      //                                   "teacherID":
                      //                                       teacherEmail,
                      //                                   "groupName": groupName,
                      //                                   "teacherName":
                      //                                       teacherName,
                      //                                   "uploads": [],
                      //                                   "students": []
                      //                                 });
                      //                                 await FirebaseFirestore
                      //                                     .instance
                      //                                     .collection("items")
                      //                                     .doc("classes")
                      //                                     .update({
                      //                                   "classes": classes
                      //                                 }).whenComplete(() async {
                      //                                   await showDialog(
                      //                                       context: context,
                      //                                       builder:
                      //                                           (context) =>
                      //                                               AlertDialog(
                      //                                                 title: Text(
                      //                                                     "Group $groupName has been created."),
                      //                                                 actions: [
                      //                                                   FlatButton(
                      //                                                     child:
                      //                                                         Text("Ok"),
                      //                                                     onPressed:
                      //                                                         () {
                      //                                                       Navigator.pop(context);
                      //                                                     },
                      //                                                   )
                      //                                                 ],
                      //                                               ));
                      //                                   setState(() {
                      //                                     isLoaded = true;
                      //                                   });
                      //                                 });
                      //                               } else {
                      //                                 await showDialog(
                      //                                     context: context,
                      //                                     builder: (context) =>
                      //                                         AlertDialog(
                      //                                           title: Text(
                      //                                               "This Group Name already exist. Please enter another name."),
                      //                                           actions: [
                      //                                             FlatButton(
                      //                                               child: Text(
                      //                                                   "Ok"),
                      //                                               onPressed:
                      //                                                   () {
                      //                                                 setState(
                      //                                                     () {
                      //                                                   isLoaded =
                      //                                                       true;
                      //                                                 });
                      //                                                 Navigator.pop(
                      //                                                     context);
                      //                                               },
                      //                                             )
                      //                                           ],
                      //                                         ));
                      //                               }
                      //                             }
                      //                           },
                      //                         ),
                      //                       )
                      //                     ],
                      //                   ),
                      //                 ),
                      //               ));
                      //     },
                      //   ),
                      // ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Container(
                        height: height * 0.08,
                        width: width * 0.8,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.grey[500],
                            border: Border.all(color: Colors.black, width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: FlatButton(
                          child: Text(
                            "Your Groups",
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Groups()));
                          },
                        ),
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Container(
                        height: height * 0.08,
                        width: width * 0.8,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.grey[500],
                            border: Border.all(color: Colors.black, width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: FlatButton(
                          child: Text(
                            "Send Mail",
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SendMail()));
                          },
                        ),
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Container(
                        height: height * 0.08,
                        width: width * 0.8,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.grey[500],
                            border: Border.all(color: Colors.black, width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: FlatButton(
                          child: Text(
                            "Your Notebook",
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Notes()));
                          },
                        ),
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Container(
                        height: height * 0.08,
                        width: width * 0.8,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.grey[500],
                            border: Border.all(color: Colors.black, width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: FlatButton(
                          child: Text(
                            "T&P Section",
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TnP(
                                          fromTPO: fromTPO,
                                        )));
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: height * 0.08,
                        width: width * 0.8,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.grey[500],
                            border: Border.all(color: Colors.black, width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: FlatButton(
                          child: Text(
                            "Add Opportunity",
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddOpportunity()));
                          },
                        ),
                      ),
                    ]),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
