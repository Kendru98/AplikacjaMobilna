import 'package:flutter/material.dart';
import '../variables.dart';
import 'package:firebase_database/firebase_database.dart';
import 'Profilepage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditPost extends StatefulWidget {
  EditPost({Key? key, required this.postKey}) : super(key: key);
  String postKey;
  @override
  _EditPostsState createState() => _EditPostsState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class _EditPostsState extends State<EditPost> {
  late TextEditingController _titleController, _postController; // do state
  late DatabaseReference ref;
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(); //state controllers
    _postController = TextEditingController();
    ref = FirebaseDatabase.instance.ref('Posts');
    getPostDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: topbarcolor,
          title: const Text('Edytuj post'),
        ),
        body: Container(
            color: dark_background,
            padding: const EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.multiline,
                    maxLines: 2,
                    maxLength: 60,
                    controller: _titleController,
                    decoration: const InputDecoration(
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
                    savePost();
                    _titleController.clear();
                    _postController.clear();
                  },
                  child: const Text('Edytuj'),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      textStyle: const TextStyle(fontSize: 20),
                      minimumSize: const Size(180, 40),
                      padding: EdgeInsets.zero),
                ),
              ],
            )));
  }

  getPostDetail() async {
    DatabaseEvent snapshot = await ref.child(widget.postKey).once();

    Map post = snapshot.snapshot.value as Map<dynamic, dynamic>;
    print(post);

    _titleController.text = post['title'];
    _postController.text = post['content'];
    setState(() {});
  }

  void savePost() {
    String title = _titleController.text;
    String text = _postController.text;
    String getdate = DateTime.now().toString();
    Map<String, String> post = {
      'title': title,
      'content': text,
      'editdate': getdate,
    };
    ref.child(widget.postKey).update(post).then((value) {
      Navigator.pop(context);
    });
  }
}
