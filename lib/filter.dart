import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FilterFirestore extends StatefulWidget {
  const FilterFirestore({super.key});

  @override
  State<FilterFirestore> createState() => _FilterFirestoreState();
}

class _FilterFirestoreState extends State<FilterFirestore> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('users').snapshots();

  // List<QueryDocumentSnapshot> data= [];
  // initialData() async{
  //   CollectionReference users = FirebaseFirestore.instance.collection("users");
  //   //  QuerySnapshot usersData = await users.where("lang", arrayContainsAny: ['fr']).get();
  //   QuerySnapshot usersData = await users.orderBy("age",descending: false).get();
  //   for (var element in usersData.docs) {
  //     data.add(element);
  //   }
  // setState(() {});
  // }
  @override
  void initState() {
    super.initState();
  // initialData();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter'),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        CollectionReference users = FirebaseFirestore.instance.collection('users');
        DocumentReference doc1 = FirebaseFirestore.instance.collection('users').doc("1");
        DocumentReference doc2 = FirebaseFirestore.instance.collection('users').doc("2");
        WriteBatch batch = FirebaseFirestore.instance.batch();
        batch.delete(doc1);
        batch.set(doc2, {
          "username" : "Shady",
          "money" : 600,
          "phone" : "654321",
          "age" : 33
        });
        batch.commit();
      },
      child: const Icon(Icons.add),),
      body: StreamBuilder(builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.hasError){
          return const Text("Error");
        }
        if(snapshot.connectionState == ConnectionState.waiting){
            return const Text("Loading...");
        }
        return ListView.builder(
          itemBuilder: (context, index){
            return InkWell(
              onTap: (){
                DocumentReference documentReference = FirebaseFirestore.instance
                    .collection('users')
                    .doc(snapshot.data!.docs[index].id);

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
                });
              },
              child: Card(child: ListTile(
                trailing: Text("${snapshot.data!.docs[index]['money']}"),
                subtitle: Text("${snapshot.data!.docs[index]['age']}"),
                title: Text("${snapshot.data!.docs[index]['username']}"),),),
            );
          },
          itemCount: snapshot.data!.docs.length,
        );
      }, stream: _usersStream,)
      //ListView.builder(
      //     itemCount: data.length,
      //     itemBuilder: (context,i){
      //       return InkWell(
      //         onTap: (){
      //
      //         },
      //         child: Card(
      //           child: ListTile(
      //             trailing: Text("${data[i]['money']}\$",
      //             style: const TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 18),),
      //             subtitle: Text("age : ${data[i]['age']}  "),
      //             title: Text(
      //               data[i]['username'],
      //               style: const TextStyle(
      //                 fontSize: 30
      //               ),
      //             ),
      //           ),
      //         ),
      //       );
      //     }),

    );
  }
}
