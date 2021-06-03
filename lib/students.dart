import 'package:flutter/material.dart';

class Students extends StatefulWidget {
  final List<dynamic> students;

  const Students({this.students});

  @override
  _StudentsState createState() => _StudentsState();
}

class _StudentsState extends State<Students> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.students.length.toString() + " students"),
        centerTitle: true,
      ),
      body: Container(
          height: height,
          width: width,
          padding: EdgeInsets.all(10),
          child: widget.students.isEmpty
              ? Center(
                  child: Text("No students joined yet."),
                )
              : ListView.builder(
                  itemCount: widget.students.length,
                  itemBuilder: (context, i) {
                    return Container(
                        width: width * 0.8,
                        margin: EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.grey[500], width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: ListTile(
                          title: Text(widget.students[i]["rollnum"].toString()),
                          subtitle: Text(
                              "Contact: ${widget.students[i]["contact"]}  Email: ${widget.students[i]["email"]}"),
                        ));
                  },
                )),
    );
  }
}
