import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:week2/components/textFormField.dart';

import '../components/customButtonAuth.dart';
import '../components/customLogoAuth.dart';




class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Form(
              key: formState,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 50,),
                  const CustomLogoAuth(),
                  Container(height: 20,),
                  const Text(
                    "Signup",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),),
                  Container(height: 10,),
                  const Text(
                    "Signup to continue using the app",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  Container(height: 20,),
                  const Text(
                    "Username",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                    ),),
                  Container(height: 10,),
                  CustomTextFormField(hintText: 'Enter Your Username', myController: username ,validator : (val){
                    if (val == ""){
                      return "Can't be empty";
                    }
                    return null;
                  }),
                  Container(height: 10,),
                  const Text(
                    "Email",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                    ),),
                  Container(height: 10,),
                  CustomTextFormField(hintText: 'Enter Your Email', myController: email, validator : (val){
                    if (val == ""){
                      return "Can't be empty";
                    }
                    return null;
                  }),
                  Container(height: 10,),
                  const Text(
                    "Password",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                    ),),
                  Container(height: 10,),
                  CustomTextFormField(
                    hintText: 'Enter Your Password',
                    myController: password,
                      validator : (val){
                        if (val == ""){
                          return "Can't be empty";
                        }
                        return null;
                      }),
                  Container(
                    alignment: Alignment.topRight,
                    margin: const EdgeInsets.only(top: 10,bottom: 20),
                    child: const Text(
                      "Forget Password ?",
                      style: TextStyle(
                          fontSize: 14
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CustomButtonAuth( title: 'Signup',
                onPressed: () async {
                  if (formState.currentState!.validate()){
                    try {
                      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: email.text,
                        password: password.text,
                      );
                      FirebaseAuth.instance.currentUser!.sendEmailVerification();
                      Navigator.of(context).pushReplacementNamed('Login');
                    } on FirebaseAuthException catch (e) {
                      print(e.code);
                      if (e.code == 'weak-password') {
                        print('The password provided is too weak.');
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'Error',
                          desc: 'The password provided is too weak.',
                        ).show();
                      } else if (e.code == 'email-already-in-use') {
                        print('The account already exists for that email.');
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'Error',
                          desc: 'The account already exists for that email.',
                        ).show();
                      }
                    } catch (e) {
                      print(e);
                    }
                  }else{
                    print("Not Valid");
                  }
                },),
            Container(height: 20,),
            const Text(
              "Or Login With",
              textAlign: TextAlign.center,
            ),
            Container(height: 20,),
            InkWell(
              onTap: (){
                Navigator.of(context).pushReplacementNamed("Login");
              },
              child: const Center(
                child: Text.rich(
                    TextSpan(
                        children: [
                          TextSpan(
                            text: "Have An Account ? ",
                          ),
                          TextSpan(
                              text: "Login",
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              )
                          )
                        ]
                    )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
