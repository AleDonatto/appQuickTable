import 'package:flutter/material.dart';
import 'package:quicktable/models/reservacion_model.dart';
import 'package:quicktable/utils/api_laravel.dart';

class FormReservaciones extends StatefulWidget {
  @override
  _FormReservacionesState createState() => _FormReservacionesState();
}

class _FormReservacionesState extends State<FormReservaciones> {
  final formKey = new GlobalKey<FormState>();

  ApiLaravel apiLaravel = new ApiLaravel();

  Reservacion reservacion = new Reservacion();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crear Reservacion"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _createFecha(),
                _createPax(),
                _createButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createFecha() {
    return TextFormField(
      keyboardType: TextInputType.datetime,
      initialValue: reservacion.fecha,
      decoration: InputDecoration(
        labelText: "Seleccione Fecha",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        suffixIcon: Icon(Icons.calendar_today),
        icon: Icon(Icons.date_range),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return "Este campo es requerido";
        } else {
          return null;
        }
      },
      onSaved: (value) {
        reservacion.fecha = value;
      },
    );

    /*return InputDatePickerFormField(
      firstDate: new DateTime.now(),
      lastDate: new DateTime(2022),
      
    );*/
  }

  Widget _createHora() {}

  Widget _createMesa() {}

  Widget _createPax() {
    return TextFormField(
      keyboardType: TextInputType.number,
      initialValue: reservacion.pax.toString(),
      decoration: InputDecoration(
        labelText: "Numero de Personas",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        suffixIcon: Icon(Icons.person_add),
        icon: Icon(Icons.format_list_numbered),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return "Este campo es Requerido";
        } else {
          return null;
        }
      },
      onSaved: (value) {
        reservacion.pax = int.parse(value);
      },
    );
  }

  Widget _createButton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Colors.deepPurpleAccent,
      textColor: Colors.white,
      onPressed: _submit,
      icon: Icon(Icons.save),
      label: Text("Crear Reservacion"),
    );
  }

  _selectDate(BuildContext context) async {
    DateTime picket = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(2020),
      lastDate: new DateTime(2022),
    );

    /*if (picket != null) {
      setState(() {
        String formattedDate = DateFormat('yyyy-MM-dd').format(picket);
        _fecha = formattedDate;
        _textEditingController.text = _fecha;
      });
    }*/
  }

  void _submit() {
    if (!formKey.currentState.validate()) return;
    print("pasado");
    formKey.currentState.save();

    apiLaravel.createReservacion(reservacion);
  }
}
