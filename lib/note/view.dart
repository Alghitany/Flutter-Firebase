import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:week2/note/add.dart';

import 'edit.dart';

class NoteView extends StatefulWidget {
  final String categoryId;
  const NoteView({super.key, required this.categoryId});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {

  List <QueryDocumentSnapshot> data = [];

  bool isLoading = true;

  getData()async{
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection("categories").doc(widget.categoryId).collection("note").get();
    data.addAll(querySnapshot.docs);
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
      FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddNote(docId: widget.categoryId)));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Note'),
        actions: [
          IconButton(onPressed: () async {
            GoogleSignIn googleSignIn = GoogleSignIn();
            googleSignIn.disconnect();
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushNamedAndRemoveUntil("Login", (route) => false);
          },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: WillPopScope(child: isLoading == true ?
      const Center(
        child: CircularProgressIndicator(),
      ) : GridView.builder(
        itemCount: data.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 160
        ),
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: (){
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context)=> EditNote(
                    noteDocId: data[index].id,
                    categoryDocId: widget.categoryId,
                    value: data[index]['note'],
                  )));
            },
            onLongPress: (){
              AwesomeDialog(
                  context: context,
                  dialogType: DialogType.warning,
                  animType: AnimType.rightSlide,
                  title: 'Error',
                  desc: 'Are You Sure Of Deleting This Note?',
                  btnCancelOnPress: () async {

                  },
                  btnOkOnPress: ()async{
                    await FirebaseFirestore.instance
                        .collection("categories")
                        .doc(widget.categoryId)
                        .collection("note")
                        .doc(data[index].id)
                        .delete();
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> NoteView(categoryId: widget.categoryId)));
                  }
              ).show();
            },
            child: Card(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text("${data[index]['note']}")
                  ],
                ),
              ),
            ),
          );
        },
      ), onWillPop: (){
        Navigator.of(context).pushNamedAndRemoveUntil("Homepage", (route)=> false);
        return Future.value(false);
    })
    );
  }
}
