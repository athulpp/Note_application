import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:noteapp/model/note_model.dart';
import 'package:noteapp/screens/home.dart';
import 'package:noteapp/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

GoogleSignInAccount? googleData;
String userEmail = 'a';
String userPhoto = '';
String userName = '';
bool isSigned = false;

signIn(context) async {
  try {
    googleData = await GoogleSignIn().signIn();
    // ignore: nullable_type_in_catch_clause
  } catch (PlatformException) {
    print('Network Error');
  }
  if (googleData == null) return;
  SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.setString('userEmail', googleData!.email);
  await pref.setString('userName', googleData!.displayName ?? '');
  await pref.setString('userImage', googleData!.photoUrl ?? '');
  userEmail = googleData!.email;
  userName = googleData!.displayName ?? '';
  userPhoto = googleData!.photoUrl ?? '';
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: ((context) => HomePage())));
}

signOut(context) async {
  googleData = await GoogleSignIn().signOut();
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => LoginPage()));
}



Future<String> createNote(NoteModel note) async {
  final fireStore = FirebaseFirestore.instance
      .collection(
        userEmail,
      )
      .doc();
  note.id = fireStore.id;
  await fireStore.set(
    note.toJson(),
  );
  return fireStore.id;
}

Stream<List<NoteModel>> getNote() =>
    FirebaseFirestore.instance.collection(userEmail).snapshots().map(
          (snapshot) => snapshot.docs
              .map(
                (json) => NoteModel.fromJson(
                  json.data(),
                ),
              )
              .toList(),
        );

Future updateNotes(NoteModel note) async {
  final noteInstance = FirebaseFirestore.instance
      .collection(
        userEmail,
      )
      .doc(
        note.id,
      );
  await noteInstance.update(
    note.toJson(),
  );
}

Future deleteNote(NoteModel note) async {
  await FirebaseFirestore.instance
      .collection(
        userEmail,
      )
      .doc(
        note.id,
      )
      .delete();
}
