import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quicktable/models/reservacion_cliente.dart';
import 'package:quicktable/utils/api_laravel.dart';
import 'package:quicktable/utils/arguments_booking.dart';
import 'package:quicktable/utils/preferenciasUsuario.dart';
import 'package:quicktable/widgets/menu.dart';

class MisReservaciones extends StatelessWidget {
  @override
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  final _apiLaravel = new ApiLaravel();
  final _prefs = new PreferenciasUsuario();

  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Color.fromRGBO(3, 85, 216, 1),
        actions: [],
        flexibleSpace: FlexibleSpaceBar(
          stretchModes: <StretchMode>[
            StretchMode.zoomBackground,
            StretchMode.blurBackground,
            StretchMode.fadeTitle,
          ],
          centerTitle: true,
          title: const Text('Mis Reservaciones'),
        ),
      ),
      drawer: _menuOptions(),
      body: _listReservaciones(context),
    );
  }

  Widget _menuOptions() {
    return MenuDrawer();
  }

  Widget _listReservaciones(BuildContext context) {
    int id = int.parse(_prefs.id);
    return FutureBuilder(
      future: _apiLaravel.getAllReservaciones(id),
      builder: (context, AsyncSnapshot<List<ReservacionCliente>> snapshot) {
        if (snapshot.hasData) {
          final reservaciones = snapshot.data;

          return ListView.builder(
            padding: EdgeInsets.all(30.0),
            itemCount: reservaciones.length,
            itemBuilder: (context, i) =>
                _createReservaciones(context, reservaciones[i]),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  _createReservaciones(BuildContext context, ReservacionCliente reservaciones) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(reservaciones.bdate);

    return Center(
      child: Card(
        elevation: 10.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(reservaciones.nameUnit),
              subtitle: Text(
                  'Mesa ${reservaciones.numMesa} Pax: ${reservaciones.pax} Dia: $formattedDate - ${reservaciones.bhour}'),
              leading: Icon(Icons.disc_full),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: _opciones(
                    context, int.parse(reservaciones.status), reservaciones)),
          ],
        ),
      ),
    );
  }

  _showAlertDialog(BuildContext context, int id) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cerrar"),
      onPressed: () => Navigator.of(context).pop(),
    );
    Widget continueButton = FlatButton(
      child: Text("Confirmar"),
      onPressed: () async {
        String response;

        response = await _apiLaravel.cancelarReservacion(id);
        Navigator.of(context).pop();
        mostrarSnackbar(response);

        Timer _timer = new Timer(const Duration(milliseconds: 5000), () {
          Navigator.pushReplacementNamed(context, "misreservaciones");
        });
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Cancelar Reservacion"),
      content: Text("¿ Esta Seguro que desea cancelar la reservacion ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _opciones(
      BuildContext context, int status, ReservacionCliente reservaciones) {
    if (status == 1) {
      return <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              "edit_reservacion",
              arguments: ArgumentsBooking(
                reservaciones.pax,
                reservaciones.tableId,
                reservaciones.bdate,
                reservaciones.bhour,
                reservaciones.numMesa,
                reservaciones.businessUnitId,
                reservaciones.idBooking,
              ),
            );
          },
          child: Text(
            'Editar',
            style: TextStyle(color: Colors.blue),
          ),
        ),
        FlatButton(
          onPressed: () => _showAlertDialog(context, reservaciones.idBooking),
          child: Text(
            'Cancelar',
            style: TextStyle(color: Colors.blue),
          ),
        )
      ];
    }

    return <Widget>[
      FlatButton(
        onPressed: () {},
        child: Text(
          'Reservacion Cancelada',
          style: TextStyle(color: Colors.red),
        ),
      ),
    ];
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
