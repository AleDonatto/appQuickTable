import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quicktable/models/reservacion_model.dart';
import 'package:quicktable/models/unidades_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiLaravel {
  final String _url = "http://restaurant.test/api";
  var token;
  var status;

  /*_getToken() async {
    SharedPreferences localstorage = await SharedPreferences.getInstance();
    token = jsonDecode(localstorage.getString('token'))['token'];
  }*/

  loginAPI(String email, String password) async {
    String apiURI = "$_url/appLogin";

    final response = await http.post(apiURI,
        headers: {'Accept': 'application/json'},
        body: {"email": "$email", "password": "$password"});
    status = response.body.contains("error");
    var data = json.decode(response.body);

    if (status) {
      print('data : ${data["error"]}');
    } else {
      print('data : ${data["token"]}');
      _save(data["token"]);
    }
  }

  _save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = token;
    prefs.setString(key, value);
  }

  read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    print('read : $value');
  }

  logoutAPI() async {}

  Future<bool> createReservacion(Reservacion reservacion) async {
    final url = "$_url/reservaciones";

    final response = await http.post(url, body: reservacionToJson(reservacion));
    final decodeData = json.decode(response.body);

    print(decodeData);
    return true;
  }

  Future<List<Unidades>> getRestaurantes() async {
    final url = "$_url/getRestaurantes";
    final List<Unidades> unidades = new List();

    final response = await http.get(url);

    final Map<String, dynamic> decodeData = json.decode(response.body);

    if (decodeData == null) return [];

    decodeData.forEach((key, value) {
      final unidadesTemp = Unidades.fromJson(value);
      unidades.add(unidadesTemp);
    });

    print(unidades);

    return unidades;
  }
}
