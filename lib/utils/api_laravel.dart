import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quicktable/models/mesas_model.dart';
import 'package:quicktable/models/reservacion_cliente.dart';
import 'package:quicktable/models/reservacion_model.dart';
import 'package:quicktable/models/unidades_model.dart';
import 'package:quicktable/utils/preferenciasUsuario.dart';

class ApiLaravel {
  final String _url = "http://3.138.117.89/api";
  var token;
  var status;

  /*getToken() async {
    SharedPreferences localstorage = await SharedPreferences.getInstance();
    token = convert.jsonDecode(localstorage.getString('token'))['token'];
  }*/

  Future<Map<String, dynamic>> loginAPI(String email, String password) async {
    String apiURI = "$_url/appLogin";

    final response = await http.post(apiURI,
        headers: {'Accept': 'application/json'},
        body: {"email": "$email", "password": "$password"});

    var data = json.decode(response.body);

    if (data['status'] == 'invalid_credentials') {
      return {
        'ok': false,
        'mensaje': '${data["message"]}',
      };
    } else {
      final prefs = new PreferenciasUsuario();
      int id = data["data"]["id"];

      prefs.token = data["token"];
      prefs.name = data["data"]["name"];
      prefs.lastname = data["data"]["lastname"];
      prefs.email = data["data"]["emial"];
      prefs.id = id.toString();

      return {
        'ok': true,
        'token': '${data["token"]}',
        'data': '${data["data"]}',
      };
    }
  }

  getToken() {
    final prefs = new PreferenciasUsuario();
    final value = prefs.token;
    print('read : $value');
  }

  logoutAPI() async {}

  Future<List<ReservacionCliente>> getAllReservaciones(int usuario) async {
    final url = "$_url/getallreservacionesCliente/$usuario";

    final response = await http.get(url);
    final List decodeData = json.decode(response.body)["data"];

    if (response.statusCode != 200) {
      throw Exception('Error getting tweets.');
    }

    return decodeData
        .map((item) => new ReservacionCliente.fromJson(item))
        .toList();

    /*if (decodeData == null) return [];

    decodeData.forEach((key, value) {
      final reservaciontem = ReservacionCliente.fromJson(value);
      reservaciones.add(reservaciontem);
    });

    return reservaciones;*/
  }

  Future<List<Unidades>> getRestaurantes() async {
    final url = "$_url/getAllUnits";
    final List<Unidades> unidades = new List();

    final response = await http.get(url);

    final decodeData = json.decode(response.body);

    if (decodeData == null) return [];

    decodeData.forEach((key, value) {
      final unidadesTemp = Unidades.fromJson(value[0]);
      unidades.add(unidadesTemp);
    });

    return unidades;
  }

  Future<List<Mesas>> getMesas(Reservacion res) async {
    final url = "$_url/buscarMesas";

    final response = await http.post(url, body: {
      "fecha": "${res.fecha}",
      "hora": "${res.hora}",
      "businessUnit": "${res.unidad}"
    });

    final List decodeData = json.decode(response.body)["data"];

    if (response.statusCode != 200) {
      throw Exception('Error getting tweets.');
    }

    return decodeData.map((item) => new Mesas.fromJson(item)).toList();

    /*decodeData.forEach((key, value) {
      final mesastemp = Mesas.fromJson(value[0]);
      mesas.add(mesastemp);
    });*/

    //return mesas;
  }

  Future<int> cancelarRservacion(int id) async {
    final url = "$_url/cancelarReservacion/$id";
    final response = await http.put(url);

    //print(convert.jsonDecode(response.body));

    return 1;
  }

  Future<bool> cambiarReservacion(Reservacion reservacion) async {
    final url = "$_url/cambiarReservacion";

    final response = await http.put(url, body: reservacionToJson(reservacion));

    final decodeData = json.decode(response.body);

    print(decodeData);

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

  Future<String> createReservacion(Reservacion reservacion) async {
    final url = "$_url/createReservacion";

    print(reservacionToJson(reservacion));

    final response = await http.post(url, headers: {
      'Accept': 'application/json'
    }, body: {
      "unidad": "${reservacion.unidad}",
      "mesa": "${reservacion.mesa}",
      "usuario_id": "${reservacion.usuarioId}",
      "fecha": "${reservacion.fecha}",
      "hora": "${reservacion.hora}",
      "pax": "${reservacion.pax}",
    });

    final decodeData = json.decode(response.body);
    print(decodeData);

    if (response.statusCode == 200) {
      return decodeData["message"].toString();
    }
    return decodeData["errors"].toString();
  }
}
