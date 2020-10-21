import 'package:covid19_app/app/repositories/endpoints_data.dart';
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

  Future<EndpointsData> _getAllEndpointsData() async {
    /*  final cases = await apiService.getEndPointData(
        accessToken: _accessToken, endPoint: Endpoint.cases);
    final casesConfirmed = await apiService.getEndPointData(
        accessToken: _accessToken, endPoint: Endpoint.casesConfirmed);
    final casesSuspected = await apiService.getEndPointData(
        accessToken: _accessToken, endPoint: Endpoint.casesSuspected);
    final deaths = await apiService.getEndPointData(
        accessToken: _accessToken, endPoint: Endpoint.deaths);
    final recovered = await apiService.getEndPointData(
        accessToken: _accessToken, endPoint: Endpoint.recovered); */
    final values = await Future.wait([
      apiService.getEndPointData(
          accessToken: _accessToken, endPoint: Endpoint.cases),
      apiService.getEndPointData(
          accessToken: _accessToken, endPoint: Endpoint.casesSuspected),
      apiService.getEndPointData(
          accessToken: _accessToken, endPoint: Endpoint.casesConfirmed),
      apiService.getEndPointData(
          accessToken: _accessToken, endPoint: Endpoint.deaths),
      apiService.getEndPointData(
          accessToken: _accessToken, endPoint: Endpoint.recovered)
    ]);
    return EndpointsData(values: {
      Endpoint.cases: values[0],
      Endpoint.casesSuspected: values[1],
      Endpoint.casesConfirmed: values[2],
      Endpoint.deaths: values[3],
      Endpoint.recovered: values[4],
    });
  }
}
