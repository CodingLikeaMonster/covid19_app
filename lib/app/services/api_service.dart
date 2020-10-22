import 'dart:convert';
import 'package:covid19_app/app/services/api.dart';
import 'package:covid19_app/app/services/endpoint_data.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class APIService {
  APIService(this.api);
  final API api;

  Future<String> getAccessTocken() async {
    final response = await http.post(api.tokenUri().toString(),
        headers: {'Authorization': 'Basic ${api.apiKey}'});
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final accessToken = data['access_token'];
      if (accessToken != null) {
        return accessToken;
      }
    }
    print(
        'Petición: Fallo en ${api.tokenUri()}\nRespuesta: ${response.statusCode} ${response.reasonPhrase}');
    throw response;
  }

  Future<EndpointData> getEndPointData(
      {@required String accessToken, @required Endpoint endPoint}) async {
    final uri = api.endpointUri(endPoint);
    final response = await http
        .get(uri.toString(), headers: {'Authorization': 'Bearer $accessToken'});
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        final Map<String, dynamic> endpointData = data[0];
        final String responseJsonKey = _responseJsonKeys[endPoint];
        final int value = endpointData[responseJsonKey];
        final String dateString = endpointData['date'];
        final date = DateTime.tryParse(dateString);
        if (value != null) {
          return EndpointData(value: value, date: date);
        }
      }
    }
    print(
        'Petición: Fallo en $uri\nRespuesta: ${response.statusCode} ${response.reasonPhrase}');
    throw response;
  }

  static Map<Endpoint, String> _responseJsonKeys = {
    Endpoint.cases: "cases",
    Endpoint.casesSuspected: "data",
    Endpoint.casesConfirmed: "data",
    Endpoint.deaths: "data",
    Endpoint.recovered: "data"
  };
}
