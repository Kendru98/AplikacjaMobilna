import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:moja_apka/screens/add_comment.dart';
import 'package:moja_apka/screens/edit_post.dart';
import 'package:moja_apka/src/firebase_storage_service.dart';
import 'package:moja_apka/variables.dart';
import 'package:moja_apka/widgets/my_drawer.dart';

import 'add_post.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class ForumView extends StatefulWidget {
  const ForumView({Key? key}) : super(key: key);

  @override
  _ForumState createState() => _ForumState();
}

class _ForumState extends State<ForumView> {
  late Query _ref;
  DatabaseReference reference = FirebaseDatabase.instance.ref().child('Posts');
  @override
  void initState() {
    super.initState();

    _ref = FirebaseDatabase.instance.ref('Posts').orderByChild('posttime');
  }

  Widget _buildPost({Map? post, key}) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Storage storage = Storage();
    final user = _auth.currentUser;
    final uid = user!.uid;
    String userAvatarpath = post!['userID'];
    String tytul = post['title'];
    String tresc = post['content'];
    String username = post['username'];

    var postID = key;
    String timeif(String czas) {
      var terazczas = DateTime.now(); // aktualny czas
      DateTime czaspostaparse =
          DateTime.parse(czas); // zamiana łancucha znakowego na date
      var czasdiff = terazczas.difference(czaspostaparse); // różnica czasu
      if (czasdiff.inSeconds < 60) {
        // jeżeli różnica mniejsza niż 60 sekund wyświetlam czas w sekundach
        String czas = czasdiff.inSeconds.toString() + 's';
        return czas;
      } else if (czasdiff.inMinutes < 60) {
        // jeżeli różnica mniejsza niż 60 minut wyświetlam czas w minutach
        String czas = czasdiff.inMinutes.toString() + 'm';
        return czas;
      } else if (czasdiff.inHours < 24) {
        // jeżeli różnica mniejsza niż 24 godziny wyświetlam czas w godzinach
        String czas = czasdiff.inHours.toString() + 'h';
        return czas;
      } else if (czasdiff.inDays <= 30) {
        // jeżeli różnica mniejsza niż 30 dni wyświetlam czas w dniach
        String czas = czasdiff.inDays.toString() + 'd';
        return czas;
      } else if (czasdiff.inDays > 30) {
        // jeżeli różnica wieksza niż 30 dni wyświetlam czas w dniach
        String czas = ' ' + czaspostaparse.month.toString() + 'M';

        return czas;
      }
      String error = 'error'; // jeżeli błąd, zwróć błąd
      return error;
    }

    return Padding(
      padding: const EdgeInsets.all(5),
      child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => AddComment(
                        titleget: tytul,
                        contentget: tresc,
                        postkeyget: postID,
                        avatarpathget: userAvatarpath,
                        timeget: timeif(post['posttime']),
                        usernameget: username,
                      )),
            );
          },
          child: Container(
            color: Colors.grey[850],

            //width: 100,
            height: 110,
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
                              future: storage.downloadURL(userAvatarpath),
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.hasData) {
                                  return CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.blueGrey[300],
                                      backgroundImage: NetworkImage(
                                        snapshot.data!,
                                        //scale: 3000,
                                      ));
                                }
                                if (snapshot.connectionState ==
                                        ConnectionState.waiting ||
                                    snapshot.hasError) {
                                  return const CircleAvatar(
                                      radius: 30,
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
                              username,
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
                        flex: 6,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: SizedBox(
                                width: 260,
                                height: 30,
                                child: Text(
                                  tytul,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    color: Colors.orange,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                                alignment: Alignment.topCenter,
                                child: SizedBox(
                                  width: 220,
                                  height: 60,
                                  child: Text(
                                    tresc,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                )),
                          ],
                        )),
                    Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Align(
                                alignment: Alignment.bottomLeft,
                                child: post['editdate'] == null
                                    ? Text(
                                        timeif(post['posttime']),
                                        style:
                                            TextStyle(color: Colors.blue[500]),
                                      )
                                    : Text(
                                        timeif(post['posttime']) +
                                            "\n" +
                                            '(edytowano' +
                                            timeif(post['editdate']) +
                                            " temu)",
                                        style: TextStyle(
                                            color: Colors.blue[500]))),
                            PopupMenuButton(
                                icon: const Icon(
                                  Icons.more_horiz,
                                  color: Colors.blue,
                                ),
                                color: dark_background,
                                itemBuilder: (BuildContext context) {
                                  return [
                                    if (uid == userAvatarpath)
                                      const PopupMenuItem(
                                        value: 'edit',
                                        child: Text(
                                          'Edytuj post',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    if (uid == userAvatarpath)
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: Text('Usuń post',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                  ];
                                },
                                onSelected: (String value) =>
                                    actionPopUpItemSelected(value, postID))
                          ],
                        )),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  void actionPopUpItemSelected(String value, String name) {
    String message;
    if (value == 'edit') {
      message = 'zaznaczyles edytowanie posta ';
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => EditPost(postKey: name)));
//Nawiguje do ekranu edytowania posta
    } else if (value == 'delete') {
      _showDeleteDialog(name);
      message = 'Zaznaczyles usuwanie';

      // Usuwam wpis.
    } else {
      message = 'Not implemented';
    }
    print(message);
  }

  _showDeleteDialog(String deletekey) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Usuń post'),
            content: const Text('Jesteś pewny że chcesz usunąć ten post?'),
            actions: [
              TextButton(
                  onPressed: () {
                    reference
                        .child(deletekey)
                        .remove()
                        .whenComplete(() => Navigator.pop(context));
                  },
                  child: const Text('Tak - usuń')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Nie - nie usuwaj'))
            ],
          );
        });
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], //ustawiam tlo strony glownej
      appBar: AppBar(
        title: const Text('Strona Główna'),
        backgroundColor: darkred,
        foregroundColor: Colors.white,
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xff660000),
                  child: IconButton(
                    icon: const Icon(
                      Icons.add_comment_rounded,
                      color: Color(0xffffffff),
                      size: 40,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const AddPost()),
                      );
                    },
                  ),
                ),
              ))
        ],
      ),

      body: Scrollbar(
          thickness: 6, //scrollbar grubosc
          child: SizedBox(
              height: double.infinity,
              child: FirebaseAnimatedList(
                  reverse: true,
                  query: _ref, //pickquery?
                  itemBuilder: (
                    BuildContext context,
                    DataSnapshot snapshot,
                    Animation<double> animation,
                    int index,
                  ) {
                    Map post = snapshot.value as Map<dynamic,
                        dynamic>; //snapshot value = rzecz textcontroler if i 2 return?
                    post['key'] = snapshot.key;
                    var postKey = snapshot.key;

                    return _buildPost(
                      post: post,
                      key: postKey,
                    );
                  }))),

      drawer: MyDrawer(), //klasa drawer menu
    );
  }
}
