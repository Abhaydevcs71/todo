import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/screens/home.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  //-----------------------------------------------
  final _formKey = GlobalKey<FormState>();
  var _email = '';
  var _password = '';
  var _username = '';
  bool isLoginPage = false;
  //-----------------------------------------------

  startauthentication() {
    final validity = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (validity) {
      _formKey.currentState?.save();
      submitform(_email, _password, _username);
    }
  }

  submitform(String email, String password, String username) async {
    final auth = FirebaseAuth.instance;
    UserCredential authResult;
    try {
      if (isLoginPage) {
        authResult = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String uid = authResult.user!.uid;
        FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set({'username': username, 'email': email});
      }
    } catch (error) {
      print('error');
    }
  }

  //-----------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(children: [
        Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!isLoginPage)
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        key: ValueKey('Username'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Incorrect Username';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _username = value!;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide()),
                            labelText: 'Enter Username',
                            labelStyle: GoogleFonts.roboto()),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      key: ValueKey('email'),
                      validator: (value) {
                        if (value!.isEmpty || !value!.contains('@')) {
                          return 'Incorrect Email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _email = value!;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide()),
                          labelText: 'Enter Email',
                          labelStyle: GoogleFonts.roboto()),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      obscureText: true,
                      keyboardType: TextInputType.emailAddress,
                      key: ValueKey('password'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Incorrect password';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _password = value!;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide()),
                          labelText: 'Enter password',
                          labelStyle: GoogleFonts.roboto()),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        padding: EdgeInsets.all(5),
                        width: double.infinity,
                        height: 70,
                        child: ElevatedButton(
                          onPressed: () {
                            startauthentication();
                          },
                          child: isLoginPage
                              ? Text(
                                  'Login',
                                  style: GoogleFonts.roboto(fontSize: 16),
                                )
                              : Text(
                                  'SignUp',
                                  style: GoogleFonts.roboto(fontSize: 16),
                                ),
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: Colors.teal[400]),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: TextButton(
                          onPressed: () {
                            setState(() {
                              isLoginPage = !isLoginPage;
                            });
                          },
                          child: isLoginPage
                              ? Text('Nat a member')
                              : Text('Already a Member?')),
                    )
                  ],
                )),
          ),
        )
      ]),
    );
  }
}
