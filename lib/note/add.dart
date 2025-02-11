import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:week2/note/view.dart';

import '../components/customButtonAuth.dart';
import '../components/customTextFieldAdd.dart';


class AddNote extends StatefulWidget {
  final String docId;
  const AddNote({super.key, required this.docId});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {

  GlobalKey <FormState> formState = GlobalKey();
  TextEditingController note = TextEditingController();


  bool isLoading = false;

  addNote() async {
    CollectionReference collectionNote =
    FirebaseFirestore.instance.collection('categories')
        .doc(widget.docId)
        .collection("note");
    if (formState.currentState!.validate()){
      try{
        isLoading = true;
        setState(() {});
        DocumentReference response = await collectionNote.add(
            {"note": note.text});
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => NoteView(categoryId: widget.docId)));
      }catch(e){
        isLoading = false;
        setState(() {});
        print("Error $e");
      }
    }
  }
  @override
  void dispose() {
    super.dispose();
    note.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Add Note"),
      ),
      body: Form(
        key: formState,
        child: isLoading? const Center(child: CircularProgressIndicator(),)
            :Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric( vertical: 20,horizontal: 25),
              child: CustomTextFormFieldAdd(
                  hintText : "Enter Your Note",
                  myController: note,
                  validator : (val) {
                    if (val == ""){
                      return "Can't be empty";
                    }
                    return null;
                  }
              ),
            ),
            CustomButtonAuth(
              title: 'Add',
              onPressed: (){
                addNote();
              },)
          ],
        ),
      ),
    );
  }
}
