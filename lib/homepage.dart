import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List <QueryDocumentSnapshot> data = [];

  bool isLoading = true;

  getData()async{
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection("categories")
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
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
          Navigator.of(context).pushNamed("AddCategory");
       },
          child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Homepage'),
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
      body: isLoading == true ?
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
              onLongPress: (){
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.warning,
                  animType: AnimType.rightSlide,
                  title: 'Error',
                  desc: 'Are you sure about deleting this document ?',
                  btnOkOnPress: ()async{
                    await FirebaseFirestore.instance.collection("categories").doc(data[index].id).delete();
                    Navigator.of(context).pushReplacementNamed("Homepage");
                  },
                  btnCancelOnPress: (){
                    print("Cancelled");
                  }
                ).show();
              },
              child: Card(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Image.asset("images/folder.png", height: 100,),
                      Text("${data[index]['name']}")
                    ],
                  ),
                ),
              ),
            );
        },
      ),
    );
  }
}
