import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gestion_hopital/signup_page.dart';

import 'navbar_roots.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  bool passToggle = true;
  String? email;
  String? password;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Form(
          key: formstate,
          child: SafeArea(
            child: Column(children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Image.asset('Image/imagess.jpg'),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextFormField(
                  onSaved: (newValue) {
                    email = newValue;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return " name cant be empty";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Enter Email'),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextFormField(
                  onSaved: (newValue) {
                    password = newValue;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return " name cant be empty";
                    }
                    return null;
                  },
                  obscureText: passToggle ? true : false,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    label: const Text('Enter Password'),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: InkWell(
                      onTap: () {
                        if (passToggle == true) {
                          passToggle = false;
                        } else {
                          passToggle = true;
                        }
                        setState(() {});
                      },
                      child: passToggle
                          ? const Icon(CupertinoIcons.eye_slash_fill)
                          : const Icon(CupertinoIcons.eye_fill),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  width: double.infinity,
                  child: Material(
                    color: const Color(0xFF7165D6),
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: () async {
                        FormState? formdata = formstate.currentState;
                        if (formdata != null) {
                          if (formdata.validate()) {
                            formdata.save();

                            try {
                              EasyLoading.show(status: "loading.....");
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                email: email!,
                                password: password!,
                              )
                                  .then(
                                (value) {
                                  EasyLoading.dismiss();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const NavBarRoots(),
                                    ),
                                  );
                                },
                              );
                            } on FirebaseAuthException catch (error) {
                              EasyLoading.dismiss();
                              error.code == 'user-not-found'
                                  ? AwesomeDialog(
                                      context: context,
                                      title: 'Error',
                                      desc: ' user not found',
                                    ).show()
                                  : null;

                              error.code == 'wrong-password'
                                  ? AwesomeDialog(
                                      context: context,
                                      title: 'Error',
                                      desc: 'Wrong Password',
                                    ).show()
                                  : null;
                            }
                          }
                        }
                      },
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                        child: Center(
                          child: Text(
                            'Log In',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have any account?",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUppage(),
                          ));
                    },
                    child: const Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7165D6),
                      ),
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
