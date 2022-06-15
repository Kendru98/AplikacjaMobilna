import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moja_apka/screens/forumview.dart';
import 'package:moja_apka/screens/loginpage.dart';
import 'package:moja_apka/screens/profilepage.dart';
import '../variables.dart';

class MyDrawer extends StatelessWidget {
  final userl = FirebaseAuth.instance.currentUser;

  MyDrawer({Key? key}) : super(key: key);
  get user => userl;

  @override
  Widget build(BuildContext context) {
    const TextStyle styletext = TextStyle(color: Colors.white, fontSize: 18);
    return SizedBox(
        width: 240,
        child: Drawer(
          backgroundColor: dark_background,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(40),
                curve: Curves.easeInOutCubic,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  color: darkred, //color rozwijanego menu
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text('Menu',
                      style: TextStyle(
                          height: 2,
                          fontSize: 40,
                          fontFamily: 'RobotoMono',
                          color: text)),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.home_outlined,
                  color: darkredft1,
                ),
                title: Text('Strona Główna', style: styletext),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ForumView()),
                  );
                },
              ),
              const Divider(
                thickness: 0.5,
                height: 1,
                color: Colors.white,
              ),
              ListTile(
                leading: const Icon(
                  Icons.person_rounded,
                  color: darkredft1,
                ),
                title: const Text('Twój profil', style: styletext),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ProfilePage(user: user)));

                  // Update the state of the app
                },
              ),
              const Divider(
                thickness: 0.5,
                height: 1,
                color: Colors.white,
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: darkredft1,
                ),
                title: const Text('Wyloguj się', style: styletext),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();

                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    ModalRoute.withName('/'),
                  );
                },
              ),
              const Divider(
                thickness: 0.5,
                height: 1,
                color: Colors.white,
              ),
              const Padding(
                padding: EdgeInsets.all(40),
                child: Text(
                  "2022 © Kwiatek Szymon",
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              )
            ],
          ),
        ));
  }
}
