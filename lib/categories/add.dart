import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/customButtonAuth.dart';
import '../components/customTextFieldAdd.dart';


class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {

  GlobalKey <FormState> formState = GlobalKey();
  TextEditingController name = TextEditingController();

  CollectionReference categories = FirebaseFirestore.instance.collection('categories');

  addCategory() async {
    if (formState.currentState!.validate()){
      try{
        DocumentReference response = await categories.add(
            {"name": name.text, "id": FirebaseAuth.instance.currentUser!.uid});
        Navigator.of(context).pushReplacementNamed("Homepage");
      }catch(e){
        print("Error $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Add Category"),
      ),
      body: Form(
        key: formState,
        child: Column(
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
              title: 'Add',
            onPressed: (){
              addCategory();
            },)
          ],
        ),
      ),
    );
  }
}
