import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teacher_helper/register.dart';

import 'home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _name;
  int _phonenum;
  String cnfrm;
  String _password;
  String _email;
  bool isLoaded = true;
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();

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

  bool validateAndSave() {
    final FormState form = formKey1.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Login"),
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
                            height: 0.25 * height,
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
                                          .signInWithEmailAndPassword(
                                              email: _email,
                                              password: _password)
                                          .then((value) async {
                                        setState(() {
                                          isLoaded = true;
                                        });
                                        if (value != null) {
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Home()),
                                                  ModalRoute.withName('/'));
                                        }
                                      });
                                    } on FirebaseAuthException catch (e) {
                                      setState(() {
                                        isLoaded = true;
                                      });
                                      String errorDetails = "";
                                      switch (e.code) {
                                        case "user-not-found":
                                          errorDetails =
                                              "You need to register first.";
                                          break;
                                        case "wrong-password":
                                          errorDetails =
                                              "Please enter correct password and then try again.";
                                          break;
                                        default:
                                          errorDetails =
                                              "Please try again with correct credentials.";
                                          break;
                                      }
                                      dialog(
                                          title: "Cannot Login",
                                          details: errorDetails);
                                    } catch (e) {
                                      print("error");
                                      setState(() {
                                        isLoaded = true;
                                      });
                                      dialog(
                                          title: "Cannot Login",
                                          details: "Please try after sometime");
                                    }
                                  }
                                },
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Text(
                            "Are you a new user?",
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                          FlatButton(
                            child: Text(
                              'Register',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 15.0,
                                  color: Colors.blue),
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Register()));
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
