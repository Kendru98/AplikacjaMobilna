import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:moja_apka/screens/forumview.dart';
import 'package:moja_apka/variables.dart';
import '../src/validator.dart';
import 'register_page.dart';
import 'fire_auth.dart';
import 'password_reset_page.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
        shadowColor: Colors.black,
        primary: darkredft1,
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));

    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: darkred,
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Form(
                key: _formKey,
                child: Container(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 90,
                      ),
                      Align(
                        child: DefaultTextStyle(
                          style: const TextStyle(
                            color: text,
                            fontSize: 22,
                          ),
                          child: AnimatedTextKit(
                            animatedTexts: [
                              WavyAnimatedText('Witaj '),
                            ],
                            isRepeatingAnimation: true,
                            onTap: () {
                              print("Tap Event");
                            },
                          ),
                        ),
                        alignment: Alignment.topLeft,
                      ),
                      const Align(
                        child: Text(
                          'aby korzystać z forum załóż swoje konto!',
                          style: TextStyle(color: text, fontSize: 16),
                        ),
                        alignment: Alignment.topLeft,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                            labelStyle: TextStyle(color: text),
                            labelText: 'Podaj email',
                            prefixIcon: Icon(Icons.mail),
                            prefixIconColor: text,
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(
                                color: darkredft2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: darkredft2))),
                        controller: _emailTextController,
                        focusNode: _focusEmail,
                        validator: (value) =>
                            Validator.sprawdzEmail(email: value!),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      TextFormField(
                        obscuringCharacter: '*',
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                            labelStyle: TextStyle(color: text),
                            iconColor: Colors.white,
                            labelText: 'Podaj hasło',
                            prefixIcon: Icon(Icons.password),
                            prefixIconColor: text,
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(
                                color: darkredft2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: darkredft2))),
                        controller: _passwordTextController,
                        focusNode: _focusPassword,
                        obscureText: true,
                        validator: (value) =>
                            Validator.sprawdzHaslo(password: (value!)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: style,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                User? user =
                                    await FireAuth.signInUsingEmailPassword(
                                  email: _emailTextController.text,
                                  password: _passwordTextController.text,
                                );
                                if (user != null) {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ForumView()));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Hasło lub email są nieprawidłowe')));
                                }
                              }
                            },
                            child: const Text(
                              'Zaloguj się',
                              style: TextStyle(color: text),
                            ),
                          ),
                          ElevatedButton(
                            style: style,
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const RegisterPage()),
                              );
                            },
                            child: const Text(
                              'Załóż konto',
                              style: TextStyle(color: text),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          PasswordResetPage()),
                                );
                              },
                              child: Text(
                                'Zapomniałeś hasła?',
                                style: TextStyle(color: Colors.blue[200]),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
