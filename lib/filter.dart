import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FilterFirestore extends StatefulWidget {
  const FilterFirestore({super.key});

  @override
  State<FilterFirestore> createState() => _FilterFirestoreState();
}

class _FilterFirestoreState extends State<FilterFirestore> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('users').snapshots();

  File? file;

  getImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? photo = await picker.pickImage(source: ImageSource.gallery);


    if(photo != null){
      file = File(photo.path);
    }
    setState(() {});
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Image Picker'),
        ),
        body: Container(
          child: Column(
            children: [
              MaterialButton(
                  onPressed: (){
                    getImage();
                  },
                  child: const Text("Get Image Camera"),
              ),
              if(file != null) Image.file(file!,
                width: 100,
                height: 100,
                fit: BoxFit.fill,
              ),
            ],
          ),
        ),
    );
  }
}
