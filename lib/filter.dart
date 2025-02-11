import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FilterFirestore extends StatefulWidget {
  const FilterFirestore({super.key});

  @override
  State<FilterFirestore> createState() => _FilterFirestoreState();
}

class _FilterFirestoreState extends State<FilterFirestore> {
  List<QueryDocumentSnapshot> data= [];
  initialData() async{
    CollectionReference users = FirebaseFirestore.instance.collection("users");
    QuerySnapshot usersData = await users.where("lang", arrayContainsAny: ['fr']).get();
    for (var element in usersData.docs) {
      data.add(element);
    }
  setState(() {});
  }
  @override
  void initState() {
    super.initState();
    initialData();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter'),
      ),
      body: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context,i){
            return Card(
              child: ListTile(
                subtitle: Text("age : ${data[i]['age']}  "),
                title: Text(
                  data[i]['username'],
                  style: const TextStyle(
                    fontSize: 30
                  ),
                ),
              ),
            );
          }),

    );
  }
}
