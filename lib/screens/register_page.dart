import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:moja_apka/screens/fire_auth.dart';
import 'package:moja_apka/screens/profilepage.dart';
import 'package:moja_apka/src/validator.dart';

import '../variables.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerFormKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
        shadowColor: Colors.black,
        primary: color5zielony,
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ));
    return GestureDetector(
      onTap: () {
        _focusName.unfocus();
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        backgroundColor: darkred,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: color5zielony,
          centerTitle: true,
          title: const Text(
            'Rejestracja',
            style: TextStyle(color: text),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Form(
                  key: _registerFormKey,
                  child: Container(
                    width: 300,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          style: const TextStyle(color: Colors.white),
                          controller: _nameTextController,
                          focusNode: _focusName,
                          validator: (value) => Validator.validateText(
                            text: value!,
                          ),
                          decoration: const InputDecoration(
                              labelStyle: TextStyle(
                                color: text,
                              ),
                              iconColor: Colors.white,
                              labelText: 'Pseudonim',
                              prefixIcon: Icon(Icons.person),
                              prefixIconColor: text,
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(
                                  color: darkredft2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(color: darkredft2))),
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          style: const TextStyle(color: Colors.white),
                          controller: _emailTextController,
                          focusNode: _focusEmail,
                          validator: (value) => Validator.sprawdzEmail(
                            email: value!,
                          ),
                          decoration: const InputDecoration(
                              labelStyle: TextStyle(
                                color: text,
                              ),
                              iconColor: Colors.white,
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.mail),
                              prefixIconColor: text,
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(
                                  color: darkredft2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(color: darkredft2))),
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          style: const TextStyle(color: Colors.white),
                          controller: _passwordTextController,
                          focusNode: _focusPassword,
                          obscureText: true,
                          validator: (value) => Validator.sprawdzHaslo(
                            password: value!,
                          ),
                          decoration: const InputDecoration(
                              labelStyle: TextStyle(color: text),
                              iconColor: Colors.white,
                              prefixIcon: Icon(Icons.password),
                              prefixIconColor: text,
                              labelText: 'Hasło',
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
                        ),
                        _isProcessing
                            ? const CircularProgressIndicator()
                            : Row(
                                children: [
                                  const SizedBox(height: 100),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: style,
                                      onPressed: () async {
                                        setState(() {
                                          _isProcessing = true;
                                        });

                                        if (_registerFormKey.currentState!
                                            .validate()) {
                                          User? user = await FireAuth
                                              .registerUsingEmailPassword(
                                            name: _nameTextController.text,
                                            email: _emailTextController.text,
                                            password:
                                                _passwordTextController.text,
                                          );

                                          if (user != null) {
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfilePage(user: user),
                                              ),
                                              ModalRoute.withName('/'),
                                            );
                                          }
                                        } else {
                                          setState(() {
                                            _isProcessing = false;
                                          });
                                        }
                                      },
                                      child: const Text(
                                        'Załóż konto!',
                                        style: TextStyle(color: text),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
