import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../components/customButtonAuth.dart';
import '../components/customTextFieldAdd.dart';


class EditCategory extends StatefulWidget {
  final String docId;
  final String oldName;
  const EditCategory({super.key, required this.docId, required this.oldName});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {

  GlobalKey <FormState> formState = GlobalKey();
  TextEditingController name = TextEditingController();

  CollectionReference categories = FirebaseFirestore.instance.collection('categories');

  bool isLoading = false;

  editCategory() async {
    if (formState.currentState!.validate()){
      try{
        isLoading = true;
        setState(() {});
        // await categories.doc(widget.docId).update({"name" : name.text});
        await categories.doc(widget.docId).set({"name" : name.text},SetOptions(merge: true));
        Navigator.of(context).pushNamedAndRemoveUntil("Homepage", (route) => false);
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
    name.text = widget.oldName;
  }
  @override
  void dispose() {
    super.dispose();
    name.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Edit Category"),
      ),
      body: Form(
        key: formState,
        child: isLoading? const Center(child: CircularProgressIndicator(),)
            :Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric( vertical: 20,horizontal: 25),
              child: CustomTextFormFieldAdd(
                  hintText : "Enter Name",
                  myController: name,
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
                editCategory();
              },)
          ],
        ),
      ),
    );
  }
}
