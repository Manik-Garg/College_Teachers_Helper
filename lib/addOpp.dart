import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddOpportunity extends StatefulWidget {
  @override
  _AddOpportunityState createState() => _AddOpportunityState();
}

class _AddOpportunityState extends State<AddOpportunity> {
  String _cname = "", description = "", roles = "",location="";
  DateTime deadline, finalDate;
  TimeOfDay dueTime;
  String eligibility = "", links = "";
  double _ctc;
  bool isLoaded = true;
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();

  bool validateAndSave() {
    final FormState form = formKey1.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<Widget> dialog({String title, String details}) async {
    return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(details),
              actions: [
                FlatButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }

  Widget textField(
      {double width,
      String warning,
      Function func,
      String variable,
      String label,
      TextInputType textInputType}) {
    return Container(
      width: width,
      color: Colors.white,
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
          maxLines: null,
          textInputAction: TextInputAction.newline,
          keyboardType: textInputType,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(
                    color: Colors.grey, width: 6, style: BorderStyle.solid)),
          ),
          validator: (value) {
            return value.isEmpty ? warning : null;
          },
          onChanged: func),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Add Opportunity"),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Container(
        height: height,
        width: width,
        child: isLoaded
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    Form(
                      key: formKey1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 0.02 * height,
                          ),
                          textField(
                              width: 0.85 * width,
                              warning: "Name can't be empty",
                              label: "Enter Company name",
                              func: (String value) {
                                setState(() {
                                  _cname = value;
                                });
                                print(_cname);
                              },
                              textInputType: TextInputType.name),
                          SizedBox(
                            height: 10.0,
                          ),
                          textField(
                              width: 0.85 * width,
                              warning: "CTC can't be empty",
                              label: "Enter CTC",
                              func: (String value) {
                                setState(() {
                                  _ctc = double.parse(value);
                                });
                              },
                              textInputType: TextInputType.number),
                          SizedBox(
                            height: 10,
                          ),
                          textField(
                              width: 0.85 * width,
                              warning: "Roles can't be empty",
                              label: "Roles",
                              func: (String value) {
                                setState(() {
                                  roles = value;
                                });
                              },
                              textInputType: TextInputType.emailAddress),
                          SizedBox(
                            height: 10,
                          ),
                          textField(
                              width: 0.85 * width,
                              warning: "Description can't be empty",
                              label: "Description",
                              func: (String value) {
                                setState(() {
                                  description = value;
                                });
                              },
                              textInputType: TextInputType.emailAddress),
                          SizedBox(
                            height: 10,
                          ),
                          textField(
                              width: 0.85 * width,
                              warning: "Links can't be empty",
                              label: "Any Links",
                              func: (String value) {
                                setState(() {
                                  links = value;
                                });
                              },
                              textInputType: TextInputType.emailAddress),
                          SizedBox(
                            height: 10,
                          ),
                          textField(
                              width: 0.85 * width,
                              warning: "Eligibility can't be empty",
                              label: "Eligibility Criteria",
                              func: (String value) {
                                setState(() {
                                  eligibility = value;
                                });
                              },
                              textInputType: TextInputType.emailAddress),
                          SizedBox(
                            height: 10,
                          ),
                          textField(
                              width: 0.85 * width,
                              warning: "Location can't be empty",
                              label: "Location",
                              func: (String value) {
                                setState(() {
                                  location = value;
                                });
                              },
                              textInputType: TextInputType.emailAddress),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: width * 0.85,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              border: Border.all(
                                  color: Colors.indigo[500], width: 2),
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.all(5),
                            child: FlatButton(
                                child: Text(
                                  finalDate == null
                                      ? "Deadline"
                                      : "Due: " +
                                          DateFormat("dd/MMM/yyyy hh:mm")
                                              .format(finalDate),
                                  style: TextStyle(fontSize: 20),
                                ),
                                onPressed: () async {
                                  var date = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now()
                                          .add(Duration(days: 100)));
                                  if (date != null) {
                                    setState(() {
                                      deadline = date;
                                    });
                                    var time = await showTimePicker(
                                        context: context,
                                        initialTime:
                                            TimeOfDay(hour: 00, minute: 00));
                                    if (time != null) {
                                      setState(() {
                                        dueTime = time;
                                        finalDate = DateTime(
                                            deadline.year,
                                            deadline.month,
                                            deadline.day,
                                            dueTime.hour,
                                            dueTime.minute);
                                      });
                                    }
                                  }
                                }),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              width: 0.85 * width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.red[400]),
                              child: FlatButton(
                                onPressed: () async {
                                  if (validateAndSave() && finalDate != null) {
                                    setState(() {
                                      isLoaded = false;
                                    });
                                    var data = await FirebaseFirestore.instance
                                        .collection("items")
                                        .doc("TPO")
                                        .get()
                                        .then((value) => value.data());
                                    List<dynamic> openings = data["items"];
                                    openings.insert(0, {
                                      "companyName": _cname,
                                      "uploadTime":
                                          Timestamp.fromDate(DateTime.now()),
                                      "uploadedBy": FirebaseAuth
                                          .instance.currentUser.email,
                                      "ctc": _ctc,
                                      "roles": roles,
                                      "description": description,
                                      "links": links,
                                      "location": location,
                                      "deadline": Timestamp.fromDate(finalDate),
                                      "eligibility": eligibility
                                    });
                                    await FirebaseFirestore.instance
                                        .collection("items")
                                        .doc("TPO")
                                        .update({
                                      "items": openings
                                    }).whenComplete(() async {
                                      await showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                title: Text("Success"),
                                                content: Text(
                                                    "Opportunity has been added."),
                                                actions: [
                                                  FlatButton(
                                                    child: Text("Ok"),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  )
                                                ],
                                              ));
                                      setState(() {
                                        isLoaded = true;
                                      });
                                    });
                                  }
                                },
                                child: Text(
                                  "Submit",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                          SizedBox(
                            height: height * 0.02,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
