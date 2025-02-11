import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:week2/note/view.dart';

import '../components/customButtonAuth.dart';
import '../components/customTextFieldAdd.dart';


class EditNote extends StatefulWidget {
  final String noteDocId;
  final String value;
  final String categoryDocId;
  const EditNote({super.key, required this.noteDocId, required this.categoryDocId, required this.value});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {

  GlobalKey <FormState> formState = GlobalKey();
  TextEditingController note = TextEditingController();


  bool isLoading = false;

  editNote() async {
    CollectionReference collectionNote =
    FirebaseFirestore.instance.collection('categories')
        .doc(widget.categoryDocId)
        .collection("note");
    if (formState.currentState!.validate()){
      try{
        isLoading = true;
        setState(() {});
        await collectionNote.doc(widget.noteDocId).update(
            {"note": note.text});
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => NoteView(categoryId: widget.categoryDocId)));
      }catch(e){
        isLoading = false;
        setState(() {});
        print("Error $e");
      }
    }
  }
  @override
  void initState() {
    super.initState();
    note.text = widget.value;
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
        title: const Text("Edit Note"),
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
              title: 'Save',
              onPressed: (){
                editNote();
              },)
          ],
        ),
      ),
    );
  }
}
