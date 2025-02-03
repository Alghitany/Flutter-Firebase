import 'package:flutter/material.dart';
import 'package:week2/components/textFormField.dart';

import '../components/custombuttonauth.dart';
import '../components/customlogoauth.dart';


class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Column(
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
                CustomTextFormField(hintText: 'Enter Your Username', myController: username),
                Container(height: 10,),
                const Text(
                  "Email",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                  ),),
                Container(height: 10,),
                CustomTextFormField(hintText: 'Enter Your Email', myController: email),
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
                  myController: password,),
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
            CustomButtonAuth( onPressed: (){}, title: 'Login',),
            Container(height: 20,),
            const Text(
              "Or Login With",
              textAlign: TextAlign.center,
            ),
            Container(height: 20,),
            InkWell(
              onTap: (){
                Navigator.of(context).pushNamed("Login");
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
