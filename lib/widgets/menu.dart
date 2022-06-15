import 'package:flutter/material.dart';

class menu extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xff7c4dff)),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                ),
              ),
            ),
            ListTile(
                leading: Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                  /* Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => settings(),
                          )); to jest do nawigacji miedzy ekranami osobne pliki*/
                }),
          ]), //ListView
        ),
        appBar: AppBar(
          title: const Text('Home Page'),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
        ));
  }
}
