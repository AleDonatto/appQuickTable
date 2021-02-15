// To parse this JSON data, do
//
//     final unidades = unidadesFromJson(jsonString);

import 'dart:convert';

Unidades unidadesFromJson(String str) => Unidades.fromJson(json.decode(str));

String unidadesToJson(Unidades data) => json.encode(data.toJson());

class Unidades {
  Unidades({
    this.idUnits,
    this.idcompany,
    this.rfc,
    this.nameUnit,
    this.phone1,
    this.phone2,
    this.address,
    this.weSite,
    this.nameContact,
    this.cancelationTimeLimit,
    this.imagen,
  });

  int idUnits;
  int idcompany;
  String rfc;
  String nameUnit;
  String phone1;
  String phone2;
  String address;
  String weSite;
  String nameContact;
  int cancelationTimeLimit;
  String imagen;

  factory Unidades.fromJson(Map<String, dynamic> json) => Unidades(
        idUnits: json["idUnits"],
        idcompany: json["idcompany"],
        rfc: json["RFC"],
        nameUnit: json["nameUnit"],
        phone1: json["phone1"],
        phone2: json["phone2"],
        address: json["address"],
        weSite: json["webSite"],
        nameContact: json["nameContact"],
        cancelationTimeLimit: json["cancelation_time_limit"],
        imagen: json["imagen"],
      );

  Map<String, dynamic> toJson() => {
        "idUnits": idUnits,
        "idcompany": idcompany,
        "RFC": rfc,
        "nameUnit": nameUnit,
        "phone1": phone1,
        "phone2": phone2,
        "address": address,
        "weSite": weSite,
        "nameContact": nameContact,
        "cancelation_time_limit": cancelationTimeLimit,
        "imagen": imagen,
      };
}
