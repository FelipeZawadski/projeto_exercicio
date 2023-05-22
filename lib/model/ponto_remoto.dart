

import 'package:intl/intl.dart';

class PontoRemoto{

  static const CAMPO_ID = 'id';
  static const DATA = 'data';
  static const LONGITUDE = 'longitude';
  static const LATITUDE = 'latitude';
  static const NOME_TABLE = 'pontoremoto';

  int? id;
  String? data;
  double? longitude;
  double? latitude;

  PontoRemoto({
    this.id,
    required this.data,
    required this.longitude,
    required this.latitude,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
    CAMPO_ID: id,
    DATA: data == null ? null : data,
    LONGITUDE: longitude,
    LATITUDE: latitude,
  };

  factory PontoRemoto.fromMap(Map<String, dynamic>  map) => PontoRemoto(
    id: map[CAMPO_ID] is int ? map[CAMPO_ID] : null,
    data: map[DATA] is String ? map[DATA] : null,
    longitude: map[LONGITUDE] is double ? map[LONGITUDE] : 0,
    latitude: map[LATITUDE] is double ? map[LATITUDE] : 0,
  );
}