import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noteapp/screens/edit_note.dart';
import 'package:noteapp/screens/home.dart';

import '../controller/google_auth.dart';
import '../model/note_model.dart';

class ViewNote extends StatefulWidget {
  ViewNote(
      {Key? key,
      required this.head,
      required this.content,
      required this.date,
      required this.ref})
      : super(key: key);
  String head;
  String content;
  DateTime date;
  final ref;
  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.yellow.shade100,
          elevation: 0,
          leading: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.yellow[100])),
          ),
          actions: [
            Row(
              children: [],
            )
          ],
        ),
        backgroundColor: Colors.yellow.shade100,
        body: SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // addNote();
                      NoteModel note = NoteModel(
                          title: widget.head,
                          content: widget.content,
                          dateTime: widget.date,
                          id: widget.ref);
                      deleteNote(note);
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => HomePage()));
                    },
                    child: Icon(
                      Icons.delete,
                      color: Colors.green,
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.yellow[700])),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // addNote();
                      NoteModel note = NoteModel(
                          title: widget.head,
                          content: widget.content,
                          dateTime: widget.date,
                          id: widget.ref);
                      // updateNote(note);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditNote(
                                title: widget.head,
                                content: widget.content,
                                dateTime: widget.date,
                                ref: widget.ref,
                              )));
                    },
                    child: Icon(
                      Icons.update,
                      color: Colors.green,
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.yellow[700])),
                  )
                ],
              ),
              Text(
                widget.head,
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.65,
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  widget.content,
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                child: Text(DateFormat.yMMMd().add_jm().format(widget.date),
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
              )
            ],
          ),
        )),
      ),
    );
  }
}
