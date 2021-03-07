import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quicktable/models/reservacion_model.dart';
import 'package:quicktable/utils/api_laravel.dart';
import 'package:quicktable/utils/arguments_booking.dart';
import 'package:quicktable/utils/preferenciasUsuario.dart';

class FormEditBookin extends StatefulWidget {
  @override
  _FormEditBookinState createState() => _FormEditBookinState();
}

class _FormEditBookinState extends State<FormEditBookin> {
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  ApiLaravel _apiLaravel = new ApiLaravel();
  Reservacion _reservacion = new Reservacion();
  PreferenciasUsuario _prefs = new PreferenciasUsuario();

  String _date = "";
  String _hora = "";

  TextEditingController _textDate = new TextEditingController();
  TextEditingController _textHora = new TextEditingController();
  TextEditingController _textPax = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ArgumentsBooking _argumentsBooking =
        ModalRoute.of(context).settings.arguments;

    /*_textPax.text = _argumentsBooking.pax.toString();
    _textDate = TextEditingController(text: formattedDate);
    _textHora.text = _argumentsBooking.hora.toString();*/

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Modificar Reservacion"),
        backgroundColor: Color.fromRGBO(3, 85, 216, 1),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(30.0),
          child: _formEditBooking(_argumentsBooking),
        ),
      ),
    );
  }

  Widget _formEditBooking(ArgumentsBooking args) {
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          _createInputNumMesa(args.mesa, args.numMesa),
          SizedBox(
            height: 10.0,
          ),
          _createInputFecha(context, args.fecha),
          SizedBox(
            height: 10.0,
          ),
          _createHora(context, args.hora),
          SizedBox(
            height: 10.0,
          ),
          _createPax(args.pax),
          SizedBox(
            height: 10.0,
          ),
          _createButton(args.businessUnitId, args.mesa, args.idReservacion),
        ],
      ),
    );
  }

  Widget _createInputNumMesa(int mesa, String numero) {
    return TextFormField(
      enableInteractiveSelection: false,
      //initialValue: numero,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        labelText: numero,
        suffixIcon: Icon(Icons.restaurant_menu),
        icon: Icon(Icons.restaurant),
      ),
      enabled: false,
    );
  }

  Widget _createInputFecha(BuildContext context, DateTime initialdate) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(initialdate);
    return TextFormField(
      enableInteractiveSelection: false,
      controller: _textDate,
      //initialValue: formattedDate,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        labelText: formattedDate,
        suffixIcon: Icon(Icons.calendar_today),
        icon: Icon(Icons.date_range),
        //helperText: "Fecha",
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        _selectDate(context);
      },
      validator: (value) {
        if (value.isEmpty) {
          return "Este campo es requerido";
        } else {
          return null;
        }
      },
      onSaved: (value) {
        _reservacion.fecha = value;
      },
    );
  }

  _selectDate(BuildContext context) async {
    DateTime picket = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(2021),
      lastDate: new DateTime(2022),
    );

    if (picket != null) {
      setState(() {
        String formattedDate = DateFormat('yyyy-MM-dd').format(picket);
        _date = formattedDate;
        _textDate.text = _date;

        print(_textDate);
      });
    }
  }

  Widget _createPax(int numPersonas) {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: _textPax,
      //initialValue: numPersonas.toString(),
      decoration: InputDecoration(
        labelText: numPersonas.toString(),
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
        _reservacion.pax = int.parse(value);
      },
    );
  }

  Widget _createHora(BuildContext context, String hora) {
    return TextFormField(
      enableInteractiveSelection: false,
      controller: _textHora,
      //initialValue: hora,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        labelText: hora.toString(),
        suffixIcon: Icon(Icons.timer),
        icon: Icon(Icons.timer),
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        _selectTime(context);
      },
      validator: (value) {
        if (value.isEmpty) {
          return "Este campo es requerido";
        } else {
          return null;
        }
      },
      onSaved: (value) {
        _reservacion.hora = value;
      },
    );
  }

  _selectTime(BuildContext context) {
    Future<TimeOfDay> selectedTime24Hour = showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
    );

    if (selectedTime24Hour != null) {
      setState(() {
        selectedTime24Hour.then((value) => {
              _hora = value.format(context),
              _textHora.text = _hora,
            });
      });
    }
  }

  Widget _createButton(int unidad, int mesa, int reservacion) {
    _reservacion.unidad = unidad;
    _reservacion.mesa = mesa;
    _reservacion.id = reservacion;

    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Colors.deepPurpleAccent,
      textColor: Colors.white,
      onPressed: _submit,
      icon: Icon(Icons.save),
      label: Text("Guardar Cambios"),
    );
  }

  _submit() async {
    if (!formKey.currentState.validate()) return;

    _reservacion.usuarioId = int.parse(_prefs.id);
    formKey.currentState.save();
    String response;

    response = await _apiLaravel.cambiarReservacion(_reservacion);
    mostrarSnackbar(response);

    Timer _timer = new Timer(const Duration(milliseconds: 5000), () {
      Navigator.pushReplacementNamed(context, "misreservaciones");
    });
  }

  mostrarSnackbar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(
        mensaje,
      ),
      duration: Duration(milliseconds: 5000),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
  }
}
