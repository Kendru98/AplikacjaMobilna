import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:moja_apka/src/firebase_storage_service.dart';
import 'package:moja_apka/src/validator.dart';
import '../variables.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class AddComment extends StatelessWidget {
  AddComment(
      {Key? key,
      required this.titleget,
      required this.contentget,
      required this.postkeyget,
      required this.avatarpathget,
      required this.timeget,
      required this.usernameget})
      : super(key: key);
  String titleget; //final?
  String contentget;
  String postkeyget;
  String avatarpathget;
  String timeget;
  String usernameget;
  final Storage storage = Storage();
  final ref2 = FirebaseDatabase.instance.ref('Comments');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _commentController = TextEditingController();
  final _focuscomment = FocusNode();

  DatabaseReference reference =
      FirebaseDatabase.instance.ref().child('Comments');

  @override
  Widget build(BuildContext context) {
    final refcomments_ = FirebaseDatabase.instance
        .ref('Comments')
        .orderByChild('commentid')
        .equalTo(postkeyget);
    final _formCommentKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: dark_background,
      appBar: AppBar(
        backgroundColor: const Color(0xff660000),
        title: const Text('Komentarze!'),
      ),
      body: Scrollbar(
        child: Container(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: FutureBuilder(
                            future: storage.downloadURL(avatarpathget),
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.hasData) {
                                return CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.blueGrey[300],
                                    backgroundImage: NetworkImage(
                                      snapshot.data!,
                                    ));
                              }
                              if (snapshot.connectionState ==
                                      ConnectionState.waiting ||
                                  snapshot.hasError) {
                                return const CircleAvatar(
                                    //jest git
                                    radius: 40,
                                    child: CircularProgressIndicator());
                              }
                              return Container(
                                color: Colors.grey,
                              );
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment
                              .bottomCenter, //const Alignment(-0.90, 3),
                          child: Text(
                            usernameget,
                            style: TextStyle(
                              color: Colors.amber[900],
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    // odzielić tekst od avatara
                    width: 10,
                  ),
                  Expanded(
                      flex: 7,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: SizedBox(
                              child: Text(
                                titleget,
                                style: const TextStyle(
                                    color: Colors.orange, fontSize: 18),
                              ),
                            ),
                          ),
                          Align(
                              alignment: Alignment.topCenter,
                              child: SizedBox(
                                child: Text(
                                  contentget,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              )),
                        ],
                      )),
                  Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              timeget,
                              style: TextStyle(color: Colors.blue[500]),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
              Divider(
                color: Colors.grey[600],
                thickness: 3,
                height: 10,
              ),
              Flexible(
                child: FirebaseAnimatedList(
                  defaultChild: const CircularProgressIndicator(),
                  query: refcomments_,
                  itemBuilder: (
                    BuildContext context,
                    DataSnapshot snapshot,
                    Animation<double> animation,
                    int index,
                  ) {
                    Map comment = snapshot.value as Map<dynamic, dynamic>;

                    comment['key'] = snapshot.key;
                    var commentKey = snapshot.key;

                    return _buildComments(
                      comment: comment,
                      key: commentKey,
                    );
                  },
                ),
              ), //

              Form(
                  key: _formCommentKey,
                  child: TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: _commentController,
                      validator: (value) =>
                          Validator.validateText(text: value!),
                      focusNode: _focuscomment,
                      decoration: InputDecoration(
                        fillColor: dark_background,
                        focusColor: darkredft1,
                        hoverColor: darkredft1,
                        suffixIcon: IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () {
                              if (_formCommentKey.currentState!.validate()) {
                                FocusManager.instance.primaryFocus
                                    ?.unfocus(); //schowanie klawiatury

                                zapiszKomentarz(); //wyslanie komentarza
                                _commentController.clear();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Komentarz musi mieć przynajmniej 3 znaki')));
                              }
                              //wyczyszczenie textfield
                            }),
                        border: const OutlineInputBorder(
                            //borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                        hintText: 'Napisz komentarz!',
                        hintStyle: const TextStyle(color: Colors.white),
                        prefixIcon: const Icon(
                          Icons.subject,
                          size: 30,
                        ),
                        filled: true,
                      ))),
            ],
          ),

          //expanded zamkniecie
        ),
      ),
    );
  }

  //zapis komentarza
  void zapiszKomentarz() async {
    String text = _commentController.text;
    final user = _auth.currentUser;
    final uid = user!.uid;
    final username = user.displayName;
    final commentid = postkeyget;
    String getdate = DateTime.now().toString();
    Map<dynamic, dynamic> comment = {
      'username': username,
      'userID': uid,
      'comment': text,
      'commentid': commentid,
      'commenttime': getdate,
    };

    ref2.push().set(comment); //dodaje komentarz do bazy
    {}
  }

  Widget _buildComments({Map? comment, String? key}) {
    final user = _auth.currentUser;
    final uid = user!.uid;
    String commentuseravatarpath = comment!['userID'];
    String czascommenta = comment['commenttime'];
    var terazczas = DateTime.now();
    DateTime czascommentaparse = DateTime.parse(czascommenta);
    var czasdiff = terazczas.difference(czascommentaparse);
    print(czasdiff.inMinutes);
    String timeif() {
      if (czasdiff.inSeconds < 60) {
        //licze czas
        String czas = czasdiff.inSeconds.toString() + 's';
        return czas;
      } else if (czasdiff.inMinutes < 60) {
        String czas = czasdiff.inMinutes.toString() + 'm';
        return czas;
      } else if (czasdiff.inHours < 24) {
        String czas = czasdiff.inHours.toString() + 'h';
        return czas;
      } else if (czasdiff.inDays <= 30) {
        String czas = czasdiff.inDays.toString() + 'd';
        return czas;
      }
      String error = 'error';
      return error;
    }

    ///Wyświetlanie sekcji komentarzy
    return Column(
      children: [
        Container(
          color: Colors.grey[900],
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: FutureBuilder(
                            future: storage.downloadURL(
                                commentuseravatarpath), //wywołanie funkcji która pobiera avatar użytkownika
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.hasData) {
                                return CircleAvatar(
                                    //jest git
                                    radius: 35,
                                    backgroundColor: Colors.blueGrey[300],
                                    backgroundImage: NetworkImage(
                                      snapshot.data!,
                                    ));
                              }
                              if (snapshot.connectionState ==
                                      ConnectionState.waiting ||
                                  snapshot.hasError) {
                                return const CircleAvatar(
                                    radius: 35,
                                    child: CircularProgressIndicator());
                              }
                              return Container(
                                color: Colors.grey,
                              );
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            comment['username'], //Wyświetlam nazwe użytkownika
                            style: TextStyle(
                              color: Colors.amber[900],
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 7,
                      child: Column(
                        children: [
                          Align(
                              alignment: Alignment.topCenter,
                              child: SizedBox(
                                child: Text(
                                  comment['comment'],
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              )),
                        ],
                      )),
                  Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              timeif(),
                              style: TextStyle(color: Colors.blue[500]),
                            ),
                          ),
                          Align(
                              child: PopupMenuButton(
                                  icon: const Icon(
                                    Icons.more_horiz,
                                    color: Colors.blue,
                                  ),
                                  color: dark_background,
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      const PopupMenuItem(
                                        value: 'Kopiuj',
                                        child: Text(
                                          'Kopiuj',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      if (uid == commentuseravatarpath)
                                        const PopupMenuItem(
                                          value: 'Usuwanie',
                                          child: Text('Usuń komentarz',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      if (uid != commentuseravatarpath)
                                        const PopupMenuItem(
                                          value: 'Odpowiedz',
                                          child: Text('Odpowiedz',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                    ];
                                  },
                                  onSelected: (String
                                          value) => //obsluga opcji komentarza przekazanie wartości
                                      actionPopUpItemSelected(
                                          value,
                                          comment['key'],
                                          comment['comment'],
                                          comment['username'])))
                        ],
                      )),
                ],
              ),
            ],
          ),
        ),
        Divider(
          thickness: 0.7,
          color: Colors.grey[700],
        ),
      ],
    );
  }

  void actionPopUpItemSelected(
      String value, String name, String comment, String username) {
    if (value == 'Kopiuj') {
      Clipboard.setData(ClipboardData(text: comment));
    } else if (value == 'Usuwanie') {
      reference.child(name).remove(); //usuniecie komentarza

    } else if (value == 'Odpowiedz') {
      Clipboard.setData(ClipboardData(text: comment));
      _commentController.text = '"' + username + ':' + comment + '"';
    } else {}
  }
}
