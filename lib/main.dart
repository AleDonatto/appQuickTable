import 'package:flutter/material.dart';
import 'package:quicktable/blocs/provider.dart';
import 'package:quicktable/pages/form_edit_booking.dart';
import 'package:quicktable/pages/form_reservacion.dart';
import 'package:quicktable/pages/home_page.dart';
import 'package:quicktable/pages/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        initialRoute: 'login',
        routes: {
          'login': (BuildContext context) => LoginPage(),
          'home': (BuildContext context) => HomePage(),
          'add_reservacion': (BuildContext context) => FormReservaciones(),
          'edit_reservacion': (BuildContext context) => FormEditBookin(),
        },
      ),
    );
  }
}
