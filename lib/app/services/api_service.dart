import 'dart:convert';
import 'package:covid19_app/app/services/api.dart';
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
}
