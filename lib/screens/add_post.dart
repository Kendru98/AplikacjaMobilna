import 'package:flutter/material.dart';
import 'package:moja_apka/src/validator.dart';
import '../variables.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  _AddPostsState createState() => _AddPostsState();
}

//@override
//void initState() {}

final ref = FirebaseDatabase.instance.ref('Posts');

final FirebaseAuth _auth = FirebaseAuth.instance;
var _titleController = TextEditingController();
var _postController = TextEditingController();

class _AddPostsState extends State<AddPost> {
  @override
  Widget build(BuildContext context) {
    final _formPostKey = GlobalKey<FormState>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: darkred,
        title: const Text('Dodaj post'),
      ),
      backgroundColor: dark_background,
      body: Form(
        key: _formPostKey,
        child: Container(
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                  validator: (value) => Validator.validateText(text: value!),
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.multiline,
                  maxLines: 2,
                  maxLength: 60,
                  controller: _titleController,
                  decoration: const InputDecoration(
                    counterStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    hintText: 'Tytuł',
                    prefixIcon: Icon(
                      Icons.title,
                      size: 30,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  )),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                  validator: (value) => Validator.validateText(text: value!),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: _postController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    hintText: 'Tresc',
                    prefixIcon: Icon(
                      Icons.subject,
                      size: 30,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  )),
              const SizedBox(
                height: 10, //odstep od gornego pola
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formPostKey.currentState!.validate()) {
                    FocusManager.instance.primaryFocus
                        ?.unfocus(); //schowanie klawiatury
                    savePost();
                    _titleController.clear();
                    _postController.clear();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content:
                            Text('Komentarz musi mieć przynajmniej 3 znaki')));
                  }
                },
                child: const Text('Dodaj'),
                style: ElevatedButton.styleFrom(
                    primary: Colors.orange,
                    textStyle: const TextStyle(fontSize: 20),
                    minimumSize: const Size(180, 40),
                    padding: EdgeInsets.zero),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void savePost() async {
    String title = _titleController.text;
    String text = _postController.text;
    String getdate = DateTime.now().toString();
    final user = _auth.currentUser;
    final username = user!.displayName;
    final uid = user.uid;
    Map<dynamic, dynamic> post = {
      'username': username,
      'userID': uid,
      'title': title,
      'content': text,
      'posttime': getdate
    };
    ref.push().set(post);
    {
      Navigator.pop(context);
    }
  }
}
