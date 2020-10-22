import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

class EndpointData {
  EndpointData({@required this.value, this.date}) : assert(value != null);
  final int value;
  final DateTime date;

  @override
  String toString() => 'Fecha: $date, Valor: $value';
}
