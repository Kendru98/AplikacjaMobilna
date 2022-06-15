import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moja_apka/src/validator.dart';

import '../variables.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class PasswordResetPage extends StatefulWidget {
  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final _ressetFormKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  final bool _isProcessing = false;

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
            'Zresetuj hasło',
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
                  key: _ressetFormKey,
                  child: Container(
                    width: 300,
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 16.0),
                        TextFormField(
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
                        _isProcessing
                            ? const CircularProgressIndicator()
                            : Row(
                                children: [
                                  const SizedBox(height: 100),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: style,
                                      onPressed: () {
                                        auth.sendPasswordResetEmail(
                                            email: _emailTextController
                                                .text); //pobieram email
                                      },
                                      child: const Text(
                                        'Zresetuj hasło!',
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
