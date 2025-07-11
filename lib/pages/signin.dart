import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter_clone_app/pages/signup.dart';
import 'package:twitter_clone_app/providers/user_provider.dart';

class SignIn extends ConsumerStatefulWidget {
  const SignIn({super.key, required this.title});
  final String title;

  @override
  ConsumerState<SignIn> createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignIn> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _signInKey = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final RegExp emailValid = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _signInKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
           const FaIcon(
            FontAwesomeIcons.twitter,
            color: Colors.blue,
            size: 70,
            ),
            const Text(
              "Log in to Twitter",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 30, 15, 0),
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Email your email",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  )
                ),
                validator: (value){
                  if(value == null || value.isEmpty){
                    return "Please enter a email";
                  }else if(!emailValid.hasMatch(value)){
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              
              ),
            ), //email
            Container(
              margin: EdgeInsets.all(15),
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextFormField(
                obscureText: true,
                style: const TextStyle(color: Colors.black),
                controller: _passwordController,
                decoration: const InputDecoration(
                  hintText: "Enter a Password",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  )
                ),
                validator: (value){
                  if(value == null || value.isEmpty){
                    return "Please enter a password";
                  }else if(value.length < 6){
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
            ),
             //password
            Container(
              width: 250,
              decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(30)),
              child: TextButton(onPressed: () async {
                if(_signInKey.currentState!.validate()){
                  //debugPrint("Email: ${_emailController.text}");
                  //debugPrint("Password: ${_passwordController.text}");
                  try{
                   await _auth.signInWithEmailAndPassword(
                    email: _emailController.text, 
                    password: _passwordController.text,
                    );
                    ref.read(userProvider.notifier).login(_emailController.text);
                  }catch(e){
                    debugPrint("Error: $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString()),),
                    );
                  }
                }
              }, child: Text("Log in", 
                style: TextStyle(color: Colors.white, fontSize: 18),
                )
              ),
            ),

            TextButton(onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Signup()));
              },
              child: const Text(
                "Don't have an account? Sign up here",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                )
              )
            ),
          ]
        )
      )
    );
  }
}
  