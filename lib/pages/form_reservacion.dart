import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quicktable/models/mesas_model.dart';
import 'package:quicktable/models/reservacion_model.dart';
import 'package:quicktable/utils/api_laravel.dart';
import 'package:quicktable/utils/arguments.dart';
import 'package:quicktable/utils/preferenciasUsuario.dart';

class FormReservaciones extends StatefulWidget {
  @override
  _FormReservacionesState createState() => _FormReservacionesState();
}

class _FormReservacionesState extends State<FormReservaciones> {
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _guardando = false;
  bool _showMesas = false;
  String _date = "";
  String _hora = "";
  int _unidad = 0;

  ApiLaravel _apiLaravel = new ApiLaravel();
  Reservacion _reservacion = new Reservacion();
  List<Mesas> _mesas = new List();
  PreferenciasUsuario _prefs = new PreferenciasUsuario();

  TextEditingController _textEditingController = new TextEditingController();
  TextEditingController _textHora = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    _unidad = args.id;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Crear Reservacion"),
        backgroundColor: Color.fromRGBO(3, 85, 216, 1),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(30.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _createInputRestaurant(args.id, args.message),
                SizedBox(
                  height: 10.0,
                ),
                _createInputFecha(context),
                SizedBox(
                  height: 10.0,
                ),
                _createHora(),
                SizedBox(
                  height: 10.0,
                ),
                _createPax(),
                SizedBox(
                  height: 10.0,
                ),
                _createSelectMesas(),
                SizedBox(
                  height: 10.0,
                ),
                _createButtonBuscarMesas(),
                _createButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createInputRestaurant(int idres, String nombre) {
    return TextFormField(
      enableInteractiveSelection: false,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        //hintText: 'Fecha de la persona',
        labelText: nombre,
        //helperText: 'Solo es el fecha wee',
        suffixIcon: Icon(Icons.restaurant_menu),
        icon: Icon(Icons.restaurant),
      ),
      enabled: false,
    );
  }

  Widget _createInputFecha(BuildContext context) {
    return TextFormField(
      enableInteractiveSelection: false,
      controller: _textEditingController,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        //hintText: 'Fecha de la persona',
        labelText: 'Fecha',
        //helperText: 'Solo es el fecha wee',
        suffixIcon: Icon(Icons.calendar_today),
        icon: Icon(Icons.date_range),
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
        _textEditingController.text = _date;
      });
    }
  }

  Widget _createHora() {
    return TextFormField(
      enableInteractiveSelection: false,
      controller: _textHora,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        labelText: 'Hora',
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

  Widget _createPax() {
    if (_showMesas) {
      return TextFormField(
        keyboardType: TextInputType.number,
        initialValue: "1",
        //controller: _paxController,
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
          _reservacion.pax = int.parse(value);
        },
      );
    } else {
      return SizedBox(height: 0.0);
    }
  }

  Widget _createSelectMesas() {
    if (_showMesas) {
      return DropdownButtonFormField(
        items: getOpciones().toList(),
        decoration: InputDecoration(
          labelText: "Seleccione Mesa",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          icon: Icon(Icons.table_chart),
        ),
        //value: _mesas.idTable ? 0 : 0,
        onChanged: (value) {
          _reservacion.mesa = value;
        },
      );
    } else {
      return SizedBox(
        height: 0.0,
      );
    }
  }

  List<DropdownMenuItem<int>> getOpciones() {
    List<DropdownMenuItem<int>> list = new List();

    _mesas.forEach((element) {
      list.add(DropdownMenuItem(
        child: Text(element.numMesa),
        value: element.idTables,
      ));
    });

    return list;
  }

  Widget _createButtonBuscarMesas() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Colors.blue[700],
      textColor: Colors.white,
      onPressed: () {
        _submitMesas();
      },
      icon: Icon(Icons.search),
      label: Text("Buscar Mesas"),
    );
  }

  Widget _createButton() {
    if (_showMesas) {
      return RaisedButton.icon(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: Colors.deepPurpleAccent,
        textColor: Colors.white,
        onPressed: (_guardando) ? false : _submit,
        icon: Icon(Icons.save),
        label: Text("Crear Reservacion"),
      );
    } else {
      return SizedBox(height: 0.0);
    }
  }

  _submitMesas() async {
    if (!formKey.currentState.validate()) return;

    Reservacion resTem = new Reservacion();
    List<Mesas> mesastem = new List();

    formKey.currentState.save();

    resTem.unidad = _unidad;
    resTem.fecha = _reservacion.fecha;
    resTem.hora = _reservacion.hora;

    _reservacion.pax = 0;
    _reservacion.mesa = 0;

    mesastem = await _apiLaravel.getMesas(resTem);
    _mesas = mesastem;

    setState(() {
      _showMesas = true;
    });
  }

  _submit() async {
    if (!formKey.currentState.validate()) return;

    _reservacion.usuarioId = int.parse(_prefs.id);
    _reservacion.unidad = _unidad;
    formKey.currentState.save();
    String response;

    response = await _apiLaravel.createReservacion(_reservacion);
    mostrarSnackbar(response);

    Timer _timer = new Timer(const Duration(milliseconds: 5500), () {
      Navigator.pop(context);
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
