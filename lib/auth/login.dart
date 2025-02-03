import 'package:flutter/material.dart';
import 'package:week2/components/textFormField.dart';

import '../components/custombuttonauth.dart';
import '../components/customlogoauth.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
            MaterialButton(
              height: 40,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
              ),
              color: Colors.red[700],
              textColor: Colors.white,
              onPressed: (){},
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
                Navigator.of(context).pushNamed("Signup");
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
