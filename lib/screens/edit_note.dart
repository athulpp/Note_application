import 'package:flutter/material.dart';
import 'package:noteapp/screens/add_note.dart';
import 'package:noteapp/screens/home.dart';

import '../controller/google_auth.dart';
import '../model/note_model.dart';

class EditNote extends StatefulWidget {
  EditNote(
      {Key? key,
      required this.title,
      required this.content,
      required this.dateTime,
      required this.ref})
      : super(key: key);
  var title;
  var content;
  DateTime dateTime;
  final ref;
  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  initEditButton() async {
    _titleController.text = widget.title;
    _contentController.text = widget.content;
  }

  updateNote(NoteModel note) async {
    NoteModel note = NoteModel(
        title: _titleController.text,
        content: _contentController.text,
        dateTime: DateTime.now(),
        id: widget.ref);
    if (_titleController.text.trim().isEmpty &&
        _contentController.text.trim().isEmpty) {
      await deleteNote(note);
      return;
    }
    await updateNotes(note);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.title != null) {
      initEditButton();
    }
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
                      NoteModel note = NoteModel(
                          title: widget.title,
                          content: widget.content,
                          dateTime: DateTime.now(),
                          id: widget.ref);
                      updateNotes(note);
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => HomePage()));
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
                controller: _titleController,
                decoration: InputDecoration.collapsed(hintText: "Title"),
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.75,
                padding: const EdgeInsets.only(top: 10),
                child: TextFormField(
                  controller: _contentController,
                  decoration: InputDecoration.collapsed(hintText: "Note"),
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                  maxLines: 20,
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
