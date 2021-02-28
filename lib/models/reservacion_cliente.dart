// To parse this JSON data, do
//
//     final reservacionCliente = reservacionClienteFromJson(jsonString);

import 'dart:convert';

ReservacionCliente reservacionClienteFromJson(String str) =>
    ReservacionCliente.fromJson(json.decode(str));

String reservacionClienteToJson(ReservacionCliente data) =>
    json.encode(data.toJson());

class ReservacionCliente {
  ReservacionCliente({
    this.nameUnit,
    this.numMesa,
    this.idBooking,
    this.businessUnitId,
    this.tableId,
    this.usuarioId,
    this.bdate,
    this.bhour,
    this.pax,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  String nameUnit;
  String numMesa;
  int idBooking;
  int businessUnitId;
  int tableId;
  int usuarioId;
  DateTime bdate;
  String bhour;
  int pax;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  factory ReservacionCliente.fromJson(Map<String, dynamic> json) =>
      ReservacionCliente(
        nameUnit: json["nameUnit"],
        numMesa: json["num_mesa"],
        idBooking: json["idBooking"],
        businessUnitId: json["businessUnit_id"],
        tableId: json["table_id"],
        usuarioId: json["usuario_id"],
        bdate: DateTime.parse(json["bdate"]),
        bhour: json["bhour"],
        pax: json["pax"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "nameUnit": nameUnit,
        "num_mesa": numMesa,
        "idBooking": idBooking,
        "businessUnit_id": businessUnitId,
        "table_id": tableId,
        "usuario_id": usuarioId,
        "bdate":
            "${bdate.year.toString().padLeft(4, '0')}-${bdate.month.toString().padLeft(2, '0')}-${bdate.day.toString().padLeft(2, '0')}",
        "bhour": bhour,
        "pax": pax,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
