import 'package:flutter/material.dart';

class MenuDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Container(),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/drawer.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.blue),
            title: Text("Home"),
            onTap: () => Navigator.pushReplacementNamed(context, 'home'),
          ),
          ListTile(
            leading: Icon(Icons.list, color: Colors.blue),
            title: Text("Mis Reservaciones"),
            onTap: () =>
                Navigator.pushReplacementNamed(context, 'misreservaciones'),
          ),
          ListTile(
              leading: Icon(Icons.settings, color: Colors.blue),
              title: Text("Configuracion"),
              onTap: () =>
                  Navigator.pushReplacementNamed(context, 'configuraciones')),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.blue),
            title: Text("Logout"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
