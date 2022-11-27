
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;

import '../google_maps_api_key.dart';
import '../models/ruta_actual.dart';
import '../models/ruta_api_google.dart';


class ProviderGoogleApis extends ChangeNotifier {
  
  static Future<RutaApiGoogle> obtenerRuta(RutaActual rutaActual) async {
    
  final latlngInicio  = LatLng(rutaActual.coordenadasInicio.latitud,  rutaActual.coordenadasInicio.longitud);
  final latlngDestino = LatLng(rutaActual.coordenadasDestino.latitud, rutaActual.coordenadasDestino.longitud);
    
    final uri = Uri.parse("https://maps.googleapis.com/maps/api/directions/json?origin=${latlngInicio.latitude},${latlngInicio.longitude}&destination=${latlngDestino.latitude},${latlngDestino.longitude}&key=$googleMapsApiKey");
    final response = await http.get(uri);
    final decodedData = json.decode(response.body);
   
    return RutaApiGoogle.fromJson(decodedData);      
   
  }

}

