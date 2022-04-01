import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../controller/google_auth.dart';
import '../model/note_model.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

String? title;
String? desc;

class _AddNoteState extends State<AddNote> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.arrow_back_ios),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey[700])),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      addNote();
                    },
                    child: Icon(
                      Icons.save,
                      color: Colors.green,
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey[700])),
                  )
                ],
              ),
              TextFormField(
                decoration: InputDecoration.collapsed(hintText: "Title"),
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
                onChanged: (value) {
                  title = value;
                },
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.75,
                padding: const EdgeInsets.only(top: 10),
                child: TextFormField(
                  decoration: InputDecoration.collapsed(hintText: "Note"),
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                  onChanged: (value) {
                    desc = value;
                  },
                  maxLines: 20,
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  // void add() {
  //   //save to db
  //   CollectionReference<Map<String, dynamic>> ref = FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser?.uid)
  //       .collection('notes');

  //   var data = {
  //     'title': title,
  //     'descripition': desc,
  //     'created': DateTime.now()
  //   };

  //   ref.add(data);

  //   Navigator.pop(context);
  // }

  addNote() async {
    if (title!.isEmpty && desc!.isEmpty) {
      return;
    }
    NoteModel note = NoteModel(
      title: title,
      content: desc,
      dateTime: DateTime.now(),
    );
    await createNote(note);
    Navigator.pop(context);
  }
}
