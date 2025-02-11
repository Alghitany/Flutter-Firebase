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
    //  QuerySnapshot usersData = await users.where("lang", arrayContainsAny: ['fr']).get();
    QuerySnapshot usersData = await users.orderBy("age",descending: false).get();
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
            return InkWell(
              onTap: (){
                DocumentReference documentReference = FirebaseFirestore.instance
                    .collection('users')
                    .doc(data[i].id);

                FirebaseFirestore.instance.runTransaction((transaction) async {
                  DocumentSnapshot snapshot = await transaction.get(documentReference);
                  if(snapshot.exists){
                    var snapshotData = snapshot.data();
                    if(snapshotData is Map<String, dynamic>){
                      int money = snapshotData['money']+100;
                      transaction.update(documentReference, {
                         "money": money
                      });
                    }
                  }
                }).then((value){
                  Navigator.of(context).pushNamedAndRemoveUntil("FilterFirestore", (route) => false);
                });
              },
              child: Card(
                child: ListTile(
                  trailing: Text("${data[i]['money']}\$",
                  style: const TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 18),),
                  subtitle: Text("age : ${data[i]['age']}  "),
                  title: Text(
                    data[i]['username'],
                    style: const TextStyle(
                      fontSize: 30
                    ),
                  ),
                ),
              ),
            );
          }),

    );
  }
}
