import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gestion_hopital/login_page.dart';
import 'package:gestion_hopital/navbar_roots.dart';

class SignUppage extends StatefulWidget {
  const SignUppage({super.key});

  @override
  State<SignUppage> createState() => _SignUppageState();
}

class _SignUppageState extends State<SignUppage> {
  bool passToggle = true;
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  String? name;
  String? email;
  String? phone;
  String? password;
  String? typeuser;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: formstate,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Image.asset("Image/imagess.jpg"),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 15,
                  ),
                  child: TextFormField(
                    onSaved: (newValue) {
                      name = newValue;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return " name cant be empty";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Full Name",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 15,
                  ),
                  child: TextFormField(
                    onSaved: (newValue) {
                      email = newValue;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return " email cant be empty";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Email Address",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 15,
                  ),
                  child: TextFormField(
                    onSaved: (newValue) {
                      phone = newValue;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return " phone cant be empty";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Phone Number",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 15,
                  ),
                  child: TextFormField(
                    onSaved: (newValue) {
                      password = newValue;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return " password cant be empty";
                      }
                      return null;
                    },
                    obscureText: passToggle ? true : false,
                    decoration: InputDecoration(
                      labelText: "Email Password",
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.person),
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
                const SizedBox(height: 10),
                DropdownButton(
                  hint: const Text('User Type'),
                  value: typeuser,
                  items: const [
                    DropdownMenuItem(
                      value: 'medecin',
                      child: Text('Medecin'),
                    ),
                    DropdownMenuItem(
                      value: 'patient',
                      child: Text('Patient'),
                    ),
                  ],
                  onChanged: (val) {
                    setState(() {
                      typeuser = val;
                    });
                  },
                ),
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

                              if (typeuser == null) {
                                AwesomeDialog(
                                  context: context,
                                  title: 'Error',
                                  desc: 'Select User Type',
                                ).show();
                              } else {
                                try {
                                  EasyLoading.show(status: "loading.....");
                                  await FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                    email: email!,
                                    password: password!,
                                  )
                                      .then(
                                    (value) async {
                                      await FirebaseFirestore.instance
                                          .collection(typeuser!)
                                          .add(
                                        {
                                          'name': name,
                                          'email': email,
                                          'phone': phone,
                                          'userId': FirebaseAuth
                                              .instance.currentUser!.uid,
                                        },
                                      ).then(
                                        (value) {
                                          EasyLoading.dismiss();
                                          if (typeuser == 'patient') {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const NavBarRoots(),
                                              ),
                                            );
                                          } else {
                                            //! NAVIGATE TO DOCTOR PAGE

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const NavBarRoots(), //! medecin_page..
                                              ),
                                            );
                                          }
                                        },
                                      );
                                    },
                                  );
                                } on FirebaseAuthException catch (error) {
                                  EasyLoading.dismiss();
                                  error.code == 'email-already-in-use'
                                      ? AwesomeDialog(
                                          context: context,
                                          title: 'Error',
                                          desc: 'Account Already Exist',
                                        ).show()
                                      : null;

                                  error.code == 'weak-password'
                                      ? AwesomeDialog(
                                          context: context,
                                          title: 'Error',
                                          desc: 'Weak Password',
                                        ).show()
                                      : null;
                                }
                              }
                            }
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 40),
                          child: Center(
                            child: Text(
                              'Create Account',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have account?",
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
                              builder: (context) => const Loginpage(),
                            ));
                      },
                      child: const Text(
                        "Log In",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7165D6),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
