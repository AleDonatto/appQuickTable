import 'package:flutter/material.dart';
import 'package:quicktable/models/unidades_model.dart';
import 'package:quicktable/utils/api_laravel.dart';
import 'package:quicktable/utils/arguments.dart';
import 'package:quicktable/widgets/menu.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final apiLaravel = new ApiLaravel();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final bloc = Provider.of(context);

    return Scaffold(
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
          title: const Text('Restaurantes'),
        ),
      ),
      drawer: _menuOptions(),
      body: _listRestaurantes(context),
      /*Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 130),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Shipping Address",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.edit,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            ListTile(
              title: Text(
                "John Doe",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
              subtitle: Text("1278 Loving Acres Road Kansas City, MO 64110"),
            ),
            SizedBox(height: 10.0),
            Text(
              "Payment Method",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            Card(
              elevation: 4.0,
              child: ListTile(
                title: Text("John Doe"),
                subtitle: Text(
                  "5506 7744 8610 9638",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                leading: Icon(
                  Icons.credit_card,
                  size: 50.0,
                  color: Theme.of(context).accentColor,
                ),
                trailing: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              "Items",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),*/
      /*ListView(
        padding: EdgeInsets.all(30.0),
        children: <Widget>[
          Text("Mis Reservaciones"),
          //_listReservaciones(context),
          //_listReservaciones(context),
          Divider(),
          Text('Restaurantes'),
          _listRestaurantes(context),
        ],
      ),*/
    );
  }

  Widget _menuOptions() {
    return MenuDrawer();
  }

  Widget _listRestaurantes(BuildContext context) {
    return FutureBuilder(
      future: apiLaravel.getRestaurantes(),
      builder: (context, AsyncSnapshot<List<Unidades>> snapshot) {
        if (snapshot.hasData) {
          final restaurant = snapshot.data;
          /*ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: restaurant.length,
            itemBuilder: (context, i) =>
                _createRestaurant(context, restaurant[i]),
          );*/
          return ListView.builder(
            padding: EdgeInsets.all(30.0),
            itemCount: restaurant.length,
            itemBuilder: (context, i) =>
                _createRestaurant(context, restaurant[i]),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _createRestaurant(BuildContext context, Unidades unidad) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            "add_reservacion",
            arguments: ScreenArguments(unidad.idUnits, unidad.nameUnit),
          );
        },
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 0.0, right: 10.0),
              child: Container(
                height: MediaQuery.of(context).size.width / 2.5,
                width: MediaQuery.of(context).size.width / 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    'assets/break.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 2.0),
                Text(
                  "${unidad.nameUnit}",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 10.0),
                Row(
                  children: <Widget>[
                    Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 0.5,
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 25.0,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 25.0,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 25.0,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 25.0,
                        ),
                        Icon(
                          Icons.star_border,
                          color: Colors.yellow,
                          size: 25.0,
                        ),
                      ],
                    ),
                    /*SmoothStarRating(
                      starCount: 1,
                      color: Constants.ratingBG,
                      allowHalfRating: true,
                      rating: 5.0,
                      size: 12.0,
                    ),
                    SizedBox(width: 6.0),
                    Text(
                      "5.0 (23 Reviews)",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),*/
                  ],
                ),
                SizedBox(height: 2.0),
                Row(
                  children: <Widget>[
                    Text(
                      "Tiempo de Cancelacion:",
                      style: TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      "${unidad.cancelationTimeLimit} hora/s",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.0),
                Text(
                  "Telefonos: ${unidad.phone1}, ${unidad.phone2}",
                  style: TextStyle(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(height: 1.0),
                Text(
                  "Sitio web: ${unidad.weSite}",
                  style: TextStyle(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    /*return Card(
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
          Text(unidad.nameUnit),
          Text("Tiempo de Cancelacion: ${unidad.cancelationTimeLimit} Hora/s"),
          Text("Telefonos: ${unidad.phone1}, ${unidad.phone2}"),
          FlatButton.icon(
            icon: Icon(Icons.table_chart),
            label: Text("Reservar Ahora"),
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: () {
              _createReservacion(context);
            },
          ),
          /*Container(
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
          ),*/
        ],
      ),
    );*/
  }

  /*_createReservacion(BuildContext context) {
    Navigator.pushNamed(context, "add_reservacion");
  }

  _editReservacion(BuildContext context) {
    Navigator.pushNamed(context, "edit_reservacion");
  }*/
}
