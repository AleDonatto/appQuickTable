// To parse this JSON data, do
//
//     final reservacion = reservacionFromJson(jsonString);

import 'dart:convert';

Reservacion reservacionFromJson(String str) =>
    Reservacion.fromJson(json.decode(str));

String reservacionToJson(Reservacion data) => json.encode(data.toJson());

class Reservacion {
  Reservacion({
    this.id,
    this.unidad,
    this.mesa,
    this.usuarioId,
    this.fecha,
    this.hora,
    this.pax,
    this.status,
  });

  int id;
  int unidad;
  int mesa;
  int usuarioId;
  String fecha;
  String hora;
  int pax;
  int status;

  factory Reservacion.fromJson(Map<String, dynamic> json) => Reservacion(
        id: json["id"],
        unidad: json["unidad"],
        mesa: json["mesa"],
        usuarioId: json["usuario_id"],
        fecha: json["fecha"],
        hora: json["hora"],
        pax: json["pax"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "unidad": unidad,
        "mesa": mesa,
        "usuario_id": usuarioId,
        "fecha": fecha,
        "hora": hora,
        "pax": pax,
        "status": status,
      };
}
