import 'package:covid19_app/app/services/api.dart';
import 'package:covid19_app/app/services/api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class DataRepository {
  DataRepository({@required this.apiService});
  final APIService apiService;

  String _accessToken;

  Future<int> getEndpointData(Endpoint endpoint) async {
    try {
      if (_accessToken == null) {
        _accessToken = await apiService.getAccessTocken();
      }
      return await apiService.getEndPointData(
          accessToken: _accessToken, endPoint: endpoint);
    } on Response catch (response) {
      //! Si no estas autorizado (o el token esta caducado), recoge el accesstoken de nuevo
      if (response.statusCode == 401) {
        _accessToken = await apiService.getAccessTocken();
        return await apiService.getEndPointData(
            accessToken: _accessToken, endPoint: endpoint);
      }
      rethrow;
    }
  }
}
