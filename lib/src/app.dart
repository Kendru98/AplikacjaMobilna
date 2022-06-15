import 'package:flutter/material.dart';
import 'package:moja_apka/screens/add_post.dart';
import 'package:moja_apka/screens/forumview.dart';
import 'package:moja_apka/variables.dart';
import 'package:moja_apka/widgets/my_drawer.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  static const appTitle = 'Home Screen';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(scaffoldBackgroundColor: dark_background),
      home: const MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dark_background, //ustawiam tlo strony glownej
      appBar: AppBar(
        title: Text(title),
        backgroundColor: topbarcolor,
        actions: [
          //prawa strona appbaru
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: topbarcolor,
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

      body: ForumView(),

      drawer: MyDrawer(), //klasa drawer menu
    );
  }
}
