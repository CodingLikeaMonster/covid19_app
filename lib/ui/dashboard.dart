import 'dart:io';

import 'package:covid19_app/app/repositories/data_repository.dart';
import 'package:covid19_app/app/repositories/endpoints_data.dart';
import 'package:covid19_app/app/services/api.dart';
import 'package:covid19_app/ui/endpoint_card.dart';
import 'package:covid19_app/ui/last_update_status_text.dart';
import 'package:covid19_app/ui/show_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  EndpointsData _endpointsData;
  @override
  void initState() {
    super.initState();
    final dataRepository = Provider.of<DataRepository>(context, listen: false);
    _endpointsData = dataRepository.getAllEndpointsCachedData();
    _updateData();
  }

  Future<void> _updateData() async {
    try {
      final dataRepository =
          Provider.of<DataRepository>(context, listen: false);
      final endpointsData = await dataRepository.getAllEndpointsData();
      setState(() => _endpointsData = endpointsData);
    } on SocketException catch (_) {
      showAlertDialog(
          context: context,
          title: 'Error de Conexión',
          content: 'No se pudo obtener los datos, inténtelo mas tarde',
          defaultActionText: 'Ok');
    } catch (_) {
      showAlertDialog(
          context: context,
          title: 'Error Desconocido',
          content: 'Inténtelo mas tarde',
          defaultActionText: 'Ok');
    }
  }

  Widget build(BuildContext context) {
    final formatter = LastUpdatedDateFormatter(
        lastUpdated: _endpointsData != null
            ? _endpointsData.values[Endpoint.cases]?.date
            : null);
    return Scaffold(
      appBar: AppBar(
        title: Text('Covid-19 Tracker'),
      ),
      body: RefreshIndicator(
        onRefresh: _updateData,
        child: ListView(
          children: <Widget>[
            LastUpdatedStatusText(text: formatter.lastUpdatedStatusText()),
            for (var endpoint in Endpoint.values)
              EndpointCard(
                  endpoint: endpoint,
                  value: _endpointsData != null
                      ? _endpointsData.values[endpoint]?.value
                      : null)
          ],
        ),
      ),
    );
  }
}
