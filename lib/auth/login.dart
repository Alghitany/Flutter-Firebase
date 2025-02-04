import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:week2/components/textFormField.dart';

import '../components/customButtonAuth.dart';
import '../components/customLogoAuth.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  bool isLoading = false;

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if(googleUser == null){
      return;
    }
    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.of(context).pushNamedAndRemoveUntil("Homepage", (route) => false);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  isLoading == true ?
      const Center(
        child: CircularProgressIndicator(),
      ):
      Container(
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
                    "Login",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),),
                  Container(height: 10,),
                  const Text(
                      "Login to continue using the app",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  Container(height: 20,),
                  const Text(
                    "Email",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    ),),
                  Container(height: 10,),
                  CustomTextFormField(hintText: 'Enter Your Email', myController: email , validator : (val){
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
                  InkWell(
                    onTap: () async{
                      if (email.text == "")
                        {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'Error',
                            desc: 'Please type your email.',
                          ).show();
                          return;
                        }
                      try{
                        await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.info,
                          animType: AnimType.rightSlide,
                          title: 'Error',
                          desc: 'A link has been sent to your email. Please check your email',
                        ).show();
                      }catch(e){
                        print(e);
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'Error',
                          desc: 'Enter existing email please.',
                        ).show();
                      }

                    },
                    child: Container(
                      alignment: Alignment.topRight,
                      margin: const EdgeInsets.only(top: 10,bottom: 20),
                      child: const Text(
                          "Forget Password ?",
                          style: TextStyle(
                            fontSize: 14
                          ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CustomButtonAuth( title: 'Login',
                onPressed: () async {
                  if (formState.currentState!.validate()){
                    try {
                      isLoading = true;
                      setState(() {});
                      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: email.text,
                          password: password.text
                      );
                      isLoading = false;
                      setState(() {});
                      if(credential.user!.emailVerified){
                          Navigator.of(context).pushReplacementNamed("Homepage");
                      }else{
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'Error',
                          desc: 'Please check your email to verify.',
                        ).show();
                      }
                    } on FirebaseAuthException catch (e) {
                      print(e.code);
                      if (e.code == 'invalid-email') {
                        print('No user found for that email.');
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'Error',
                          desc: 'No user found for that email.',
                        ).show();
                      } else if (e.code == 'invalid-credential') {
                        print('Wrong password provided for that user.');
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'Error',
                          desc: 'Wrong password provided for that user.',
                        ).show();
                      }
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
            MaterialButton(
              height: 40,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
              ),
              color: Colors.red[700],
              textColor: Colors.white,
              onPressed: (){
                signInWithGoogle();
              },
              child:   Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Login With Google  "),
                  Image.asset(
                    "images/4.png",
                    width: 20,)
                ],
              ),
            ),
            Container(height: 20,),
            InkWell(
              onTap: (){
                Navigator.of(context).pushReplacementNamed("Signup");
              },
              child: const Center(
                child: Text.rich(
                    TextSpan(
                    children: [
                      TextSpan(
                          text: "Don't Have An Account ? ",
                      ),
                      TextSpan(
                        text: "Register",
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
