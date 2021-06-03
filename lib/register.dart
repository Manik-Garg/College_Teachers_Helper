import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teacher_helper/login.dart';

import 'home.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String _name;
  int _phonenum;
  String cnfrm;
  String _password;
  String _email;
  bool isLoaded = true;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool validateAndSave() {
    final FormState form = formKey.currentState;
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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Register Yourself"),
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
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 0.02 * height,
                          ),
                          Container(
                            width: 0.8 * width,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              border:
                                  Border.all(color: Colors.grey[500], width: 2),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    hintText: 'Enter Name',
                                    border: InputBorder.none,
                                  ),
                                  validator: (value) {
                                    return value.isEmpty
                                        ? 'Name can\'t be empty'
                                        : null;
                                  },
                                  textCapitalization: TextCapitalization.words,
                                  onSaved: (String value) {
                                    setState(() {
                                      _name = value;
                                    });
                                  }),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            width: 0.8 * MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(20)),
                              border:
                              Border.all(color: Colors.grey[500], width: 2),
                              color: Colors.white,
                            ),

                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    hintText: 'Enter Email ID',
                                    border: InputBorder.none,
                                  ),
                                  validator: (value) {
                                    return value.isEmpty
                                        ? 'Email ID can\'t be empty'
                                        : null;
                                  },
                                  onSaved: (String value) {
                                    setState(() {
                                      _email = value;
                                    });
                                  }),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: 0.8 * MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(20)),
                              border:
                              Border.all(color: Colors.grey[500], width: 2),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TextFormField(
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    hintText: 'Enter Mobile Number',
                                    border: InputBorder.none,
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty ||
                                        int.parse(value) < 6000000000 ||
                                        int.parse(value) > 9999999999) {
                                      return 'Please enter valid Mobile Number';
                                    }
                                    return null;
                                  },
                                  onSaved: (String value) {
                                    setState(() {
                                      _phonenum = int.parse(value);
                                    });
                                  }),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: 0.8 * MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(20)),
                              border:
                              Border.all(color: Colors.grey[500], width: 2),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TextFormField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: 'Enter Password',
                                  border: InputBorder.none,
                                ),
                                validator: (value) {
                                  return value.isEmpty || value.length < 6
                                      ? 'Please Enter atleast 6 characters.'
                                      : null;
                                },
                                onSaved: (String value) {
                                  setState(() {
                                    _password = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: 0.8 * MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(20)),
                              border:
                              Border.all(color: Colors.grey[500], width: 2),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TextFormField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: 'Confirm Password',
                                  border: InputBorder.none,
                                ),
                                validator: (value) {
                                  return cnfrm != _password
                                      ? 'This is not same as your password'
                                      : null;
                                },
                                onSaved: (String value) {
                                  setState(() {
                                    cnfrm = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                              width: 0.8 * MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.red[400]),
                              child: FlatButton(
                                onPressed: () async {
                                  if (validateAndSave()) {
                                    setState(() {
                                      isLoaded = false;
                                    });
                                    try {
                                      await FirebaseAuth.instance
                                          .createUserWithEmailAndPassword(
                                              email: _email,
                                              password: _password)
                                          .then((value) async {
                                        setState(() {
                                          isLoaded = true;
                                        });
                                        if (value != null) {
                                          await FirebaseFirestore.instance
                                              .collection("teachers")
                                              .doc(value.user.email)
                                              .set({
                                            "name": _name,
                                            "email": _email,
                                            "password": _password,
                                            "contact": _phonenum,
                                            "groups": [],
                                            "uploads": [],
                                            "notes":[]
                                          }).whenComplete(() {
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Home()),
                                                    ModalRoute.withName('/'));
                                          });
                                        }
                                      });
                                    } on FirebaseAuthException catch (e) {
                                      setState(() {
                                        isLoaded = true;
                                      });
                                      String errorDetails = "";
                                      switch (e.code) {
                                        case "weak-password":
                                          errorDetails =
                                              "The password provided is too weak.";
                                          break;
                                        case "email-already-in-use":
                                          errorDetails =
                                              "The account already exists for this email.";
                                          break;
                                        default:
                                          errorDetails =
                                              "Please try again with different credentials";
                                          break;
                                      }
                                      dialog(
                                          title: "Cannot create account",
                                          details: errorDetails);
                                    } catch (e) {
                                      print("catch error");
                                      setState(() {
                                        isLoaded = true;
                                      });
                                    }
                                  }
                                },
                                child: Text(
                                  "Create Account",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Text(
                            "Already have an account?",
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                          FlatButton(
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 15.0,
                                  color: Colors.blue),
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()));
                            },
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
