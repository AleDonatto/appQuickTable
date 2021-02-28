import 'package:flutter/material.dart';
import 'package:quicktable/utils/arguments_booking.dart';

class FormEditBookin extends StatefulWidget {
  @override
  _FormEditBookinState createState() => _FormEditBookinState();
}

class _FormEditBookinState extends State<FormEditBookin> {
  @override
  Widget build(BuildContext context) {
    final ArgumentsBooking _argumentsBooking =
        ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Modificar Reservacion"),
        backgroundColor: Color.fromRGBO(3, 85, 216, 1),
      ),
      body: _datos(_argumentsBooking),
    );
  }

  Widget _datos(ArgumentsBooking args) {
    return Text(
        "Datos: fecha = ${args.fecha} hora = ${args.hora} Pax = ${args.pax} ");
  }
}
