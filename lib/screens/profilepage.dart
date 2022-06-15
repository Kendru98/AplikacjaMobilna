// ignore_for_file: file_names

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moja_apka/src/firebase_storage_service.dart';
import 'package:moja_apka/src/validator.dart';
import 'package:moja_apka/variables.dart';
import '../widgets/my_drawer.dart';
import 'fire_auth.dart';
import 'loginpage.dart';

class ProfilePage extends StatefulWidget {
  final User user;

  const ProfilePage({required this.user});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth =
      FirebaseAuth.instance; //zmien tu tak jak w editpost

  late User _currentUser;
  late bool avatarUrl = false;
  bool _isSendingVerification = false;
  bool _isSigningOut = false;

  ImagePicker picker = ImagePicker();

  @override
  void initState() {
    _currentUser = widget.user;

    super.initState();
  }

  final _currentpassword = TextEditingController();
  final _newpassword = TextEditingController();
  final _focuscurrentpassword = FocusNode();
  final _focusnewpassword = FocusNode();
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
        primary: darkredft1,
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
    final _formKey = GlobalKey<FormState>();
    final Storage storage = Storage();
    final user = _auth.currentUser;
    final uid = user!.uid;

    Future pickPhotoFromGallery() async {
      XFile? image = await picker.pickImage(
          source: ImageSource.gallery, // źródło zdjęcia
          imageQuality: 85, // jakość zdjęcia
          maxHeight: 500, // wysokość zdjęcia
          maxWidth: 500); // szerokość zdjęcia
      File _image = File(image!.path);

      setState(() {
        storage.uploadFile(_image.path, uid).then((value) => print(
            'done')); // zmiana nazwy zdjęcia na uid użytkownika i wysłanie zdjęcia do bazy

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            // wyświetlenie informacji dla użytkownika
            content:
                Text('Jeżeli avatar się nie zmienił, użyj przycisku odśwież')));
      });
    }

    return Scaffold(
        backgroundColor: dark_background,
        resizeToAvoidBottomInset:
            false, //aby nie wystepowal overflow przy wpisywaniu
        appBar: AppBar(
          backgroundColor: darkred,
          title: const Text('Profil'),
          actions: [
            //prawa strona appbarudaj tu refresh
          ],
        ),
        drawer: MyDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(33),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const SizedBox(height: 16.0),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Pseudonim: ${_currentUser.displayName}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.merge(TextStyle(color: Colors.white)),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Email: ${_currentUser.email}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.merge(TextStyle(color: Colors.white)),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: _currentUser.emailVerified
                              ? Text(
                                  'Email verified',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(color: Colors.green),
                                )
                              : Text(
                                  'Email not verified',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(color: Colors.red),
                                ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: ElevatedButton(
                            style: style,
                            onPressed: () async {
                              await _currentUser.sendEmailVerification();
                            },
                            child: Text(
                              'Potwierdź email',
                              style: TextStyle(color: text),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: ElevatedButton(
                            style: style,
                            onPressed: () async {
                              User? user =
                                  await FireAuth.refreshUser(_currentUser);
                              if (user != null) {
                                setState(() {
                                  _currentUser = user;
                                });
                              }
                            },
                            child: const Text(
                              'Odśwież',
                              style: TextStyle(color: text),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => pickPhotoFromGallery(),
                    child: FutureBuilder(
                      future: storage.downloadURL(uid),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          return CircleAvatar(
                              radius: 60,
                              backgroundImage: NetworkImage(
                                snapshot.data!,
                                //scale: 3000,
                              ));
                        }
                        if (snapshot.connectionState ==
                                ConnectionState.waiting ||
                            snapshot.hasError) {
                          return const CircleAvatar(
                              //jest git
                              radius: 60,
                              child: CircularProgressIndicator());
                        }
                        return Container(
                          color: Colors.grey,
                        );
                      },
                    ),
                  )
                ],
              ),
              Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25.0))),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: darkredft2)),
                            labelText: 'Aktualne hasło',
                            labelStyle: TextStyle(color: Colors.white)),
                        controller: _currentpassword,
                        focusNode: _focuscurrentpassword,
                        obscureText: true,
                        validator: (value) =>
                            Validator.sprawdzHaslo(password: (value!)),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25.0))),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: darkredft2)),
                            labelText: 'Nowe hasło',
                            labelStyle: TextStyle(color: Colors.white)),
                        controller: _newpassword,
                        focusNode: _focusnewpassword,
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
                                  email: _currentUser.email.toString(),
                                  password: _currentpassword.text,
                                );
                                if (user != null) {
                                  FirebaseAuth.instance.currentUser
                                      ?.updatePassword(_newpassword.text);

                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              LoginPage()));
                                } else {}
                              }
                            },
                            child: const Text(
                              'Zmień hasło',
                              style: TextStyle(color: text),
                            ),
                          ),
                          // controller: _emailTextController,
                          //focusNode: _focusEmail,
                          // validator: (value) =>
                          //    Validator.validateEmail(email: value!),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
