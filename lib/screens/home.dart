import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noteapp/screens/add_note.dart';
import 'package:noteapp/screens/view.dart';

import '../controller/google_auth.dart';
import '../model/note_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

final myColors = [
  Colors.yellow[200],
  Colors.red[200],
  Colors.green[200],
  Colors.deepPurple[200]
];

CollectionReference<Map<String, dynamic>> ref = FirebaseFirestore.instance
    .collection('users')
    .doc(FirebaseAuth.instance.currentUser?.uid)
    .collection('notes');

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(
              MaterialPageRoute(
                builder: (context) => AddNote(),
              ),
            )
                .then((value) {
              print('Calling Set state');
              setState(() {});
            });
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Colors.grey[700],
        ),
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('My Notes'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                signOut(context);
              },
              icon: Icon(Icons.logout),
            )
          ],
        ),
        body: StreamBuilder<List<NoteModel>>(
          stream: getNote(),
          builder: (context, AsyncSnapshot<List<NoteModel>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Random random = new Random();
                    Color? bg = myColors[random.nextInt(4)];
                    String? data_title = snapshot.data?[index].title;
                    String? data_content = snapshot.data?[index].content;
                    DateTime? data_time = snapshot.data?[index].dateTime;

                    return InkWell(
                      onTap: (() {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ViewNote(
                                  head: data_title!,
                                  content: data_content!,
                                  date: data_time!,
                                  ref: snapshot.data![index].id,
                                )));
                      }),
                      child: Card(
                          color: bg,
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data_title!,
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    child: Text(data_content!,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                  ),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                        DateFormat.yMMMd()
                                            .add_jm()
                                            .format(data_time!),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                  )
                                ]),
                          )),
                    );
                  });
            } else {
              return Center(
                child: Text('Loading...'),
              );
            }
          },
        ));
  }
}
