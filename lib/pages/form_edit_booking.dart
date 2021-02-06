import 'package:flutter/material.dart';

class FormEditBookin extends StatefulWidget {
  @override
  _FormEditBookinState createState() => _FormEditBookinState();
}

class _FormEditBookinState extends State<FormEditBookin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Reservacion"),
      ),
    );
  }
}
