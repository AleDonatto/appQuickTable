import 'package:flutter/material.dart';
import 'package:quicktable/blocs/provider.dart';
import 'package:quicktable/pages/form_edit_booking.dart';
import 'package:quicktable/pages/form_reservacion.dart';
import 'package:quicktable/pages/home_page.dart';
import 'package:quicktable/pages/list_bookings.dart';
import 'package:quicktable/pages/login_page.dart';
import 'package:quicktable/utils/preferenciasUsuario.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final prefs = new PreferenciasUsuario();
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        initialRoute: _rutainicial(),
        routes: {
          'login': (BuildContext context) => LoginPage(),
          'home': (BuildContext context) => HomePage(),
          'add_reservacion': (BuildContext context) => FormReservaciones(),
          'edit_reservacion': (BuildContext context) => FormEditBookin(),
          'misreservaciones': (BuildContext context) => MisReservaciones(),
        },
      ),
    );
  }

  _rutainicial() {
    if (prefs.token == null) {
      return 'login';
    }
    return 'home';
  }
}
