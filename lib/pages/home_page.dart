import 'package:flutter/material.dart';
import 'package:quicktable/blocs/provider.dart';
import 'package:quicktable/models/reservacion_model.dart';
import 'package:quicktable/utils/api_laravel.dart';

class HomePage extends StatelessWidget {
  final apiLaravel = new ApiLaravel();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        backgroundColor: Color.fromRGBO(3, 85, 216, 1),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            tooltip: 'Opciones',
            onPressed: () {},
          ),
        ],
        flexibleSpace: FlexibleSpaceBar(
          stretchModes: <StretchMode>[
            StretchMode.zoomBackground,
            StretchMode.blurBackground,
            StretchMode.fadeTitle,
          ],
          centerTitle: true,
          title: const Text('Flight Report'),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(30.0),
        children: <Widget>[
          Text("Mis Reservaciones"),
          _listReservaciones(context),
          _listReservaciones(context),
          Divider(),
          Text('Restaurantes'),
          _listRestaurantes(context),
          _listRestaurantes(context),
        ],
      ),
    );
  }

  Widget _listReservaciones(BuildContext context) {
    return Center(
      child: Card(
        elevation: 10.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text('Hello'),
              subtitle: Text('I like my bitch'),
              leading: Icon(Icons.disc_full),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  onPressed: () {},
                  child: Text('Pucharse'),
                ),
                FlatButton(
                  onPressed: () {}, //_editReservacion(context),
                  child: Text('Editar'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _listRestaurantes(BuildContext context) {
    return FutureBuilder(
      future: apiLaravel.getRestaurantes(),
      builder:
          (BuildContext context, AsyncSnapshot<List<Reservacion>> snapshot) {
        if (snapshot.hasData) {
          return Container();
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 10.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FadeInImage(
            image: AssetImage('assets/break.jpg'),
            placeholder: AssetImage('assets/loading.gif'),
            fadeInDuration: Duration(milliseconds: 100),
            height: 300.0,
            fit: BoxFit.cover,
          ),
          Text("Nombre del restaurant"),
          Container(
            padding: EdgeInsets.all(10.0),
            width: 220.0,
            child: FlatButton.icon(
              icon: Icon(Icons.table_chart),
              label: Text("Reservar Ahora"),
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {
                _createReservacion(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  _createReservacion(BuildContext context) {
    Navigator.pushNamed(context, "add_reservacion");
  }

  _editReservacion(BuildContext context) {
    Navigator.pushNamed(context, "edit_reservacion");
  }
}
