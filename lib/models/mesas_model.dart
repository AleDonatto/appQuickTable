// To parse this JSON data, do
//
//     final mesas = mesasFromJson(jsonString);

import 'dart:convert';

Mesas mesasFromJson(String str) => Mesas.fromJson(json.decode(str));

String mesasToJson(Mesas data) => json.encode(data.toJson());

class Mesas {
  Mesas({
    this.idTables,
    this.units,
    this.numMesa,
    this.numberChairs,
    this.status,
  });

  int idTables;
  int units;
  String numMesa;
  int numberChairs;
  String status;

  factory Mesas.fromJson(Map<String, dynamic> json) => Mesas(
        idTables: json["idTables"],
        units: json["units"],
        numMesa: json["num_mesa"],
        numberChairs: json["number_chairs"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "idTables": idTables,
        "units": units,
        "num_mesa": numMesa,
        "number_chairs": numberChairs,
        "status": status,
      };
}
