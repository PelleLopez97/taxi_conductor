import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:pide_taxi_conductor_v2/provider/provider_google_apis.dart';
import 'package:provider/provider.dart';

import '../flirebase_messaging_key.dart';
import '../global/variables_globales.dart';
import '../models/ruta_actual.dart';
import '../screens/login_screen.dart';
import '../widgets/dialogo_progreso.dart';

class ProviderHomeScreen extends ChangeNotifier {
  static late GoogleMapController googleMapController;

  static late Position posicionActual;

  static late BuildContext contextoHomeScreen;

  List<RutaActual> _listaRutasActuales = [];

  Set<Marker> _listaMarkers = {};
  Set<Polyline> _polylineRuta = {};

  bool _solicitandoRuta = false;

  set listaRutasActuales(List<RutaActual> lista) {
    _listaRutasActuales = lista;
    notifyListeners();
  }

  List<RutaActual> get listaRutasActuales => _listaRutasActuales;

  set solicitandoRuta(bool valor) {
    _solicitandoRuta = valor;
    notifyListeners();
  }

  bool get solicitandoRuta => _solicitandoRuta;
  set listaMarkers(Set<Marker> lista) {
    _listaMarkers = lista;
    notifyListeners();
  }

  set polylineRuta(Set<Polyline> polyline) {
    _polylineRuta = polyline;
    notifyListeners();
  }

  Set<Polyline> get polylineRuta => _polylineRuta;
  Set<Marker> get listaMarkers => _listaMarkers;

  static Future<void> permisoUbicacion() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.

      permission = await Geolocator.requestPermission();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    posicionActual = await Geolocator.getCurrentPosition();

    moverCamara();
    _escucharPosicionActualTiempoReal();
  }

  static void moverCamara() {
    googleMapController.moveCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            bearing: 192.8334901395799,
            target: LatLng(posicionActual.latitude, posicionActual.longitude),
            tilt: 59.440717697143555,
            zoom: 15)));
  }

  static Future<void> escucharRutasActuales() async {
    streamEscucharRutaActual = FirebaseFirestore.instance
        .collection("solicitudes")
        .where("id_taxista", isEqualTo: usuarioActual.uid.toString())
        .where("status", isNotEqualTo: "terminado")
        .orderBy("status")
        .snapshots()
        .listen((event) {
      List<RutaActual> listaRutas = [];

      if (event.docs.isEmpty) {
        Provider.of<ProviderHomeScreen>(contextoHomeScreen, listen: false)
            .listaRutasActuales = [];
        Provider.of<ProviderHomeScreen>(contextoHomeScreen, listen: false)
            .listaMarkers = {};
        Provider.of<ProviderHomeScreen>(contextoHomeScreen, listen: false)
            .polylineRuta = {};
        return;
      } else {
        // RutaActual objRuta = RutaActual();
        final rutasActuales = event.docs.map((e) {
          final objRutaActual = RutaActual.fromJson(e.data());

          objRutaActual.idSolicitud = e.id;

          return objRutaActual;
        }).toList();

        for (var ruta in rutasActuales) {
          // if(ruta.status == "aceptado" || ruta.status == "enRuta" || ruta.status == "pagando"){ // esta validacion no es necesario porque ya se valida en el filtro de firestore que solo muestre rutas que no esten terminadas
          listaRutas.add(ruta);
          // }
        }

        Future.delayed(const Duration(milliseconds: 200)).then((value) {
          Provider.of<ProviderHomeScreen>(contextoHomeScreen, listen: false)
              .listaRutasActuales = listaRutas;
          ProviderHomeScreen.calcularRuta(listaRutas.first);
        });
      }
    });
  }

  static void consultarUsuario() async {
    usuarioActual = FirebaseAuth.instance.currentUser!;
    final tokenActual = await FirebaseMessaging.instance.getToken();
    FirebaseFirestore.instance
        .collection("taxistas")
        .doc(usuarioActual.uid)
        .update({"token": tokenActual});
  }

  static void _escucharPosicionActualTiempoReal() {
    streamSubscriptionEscucharPosicionActual = Geolocator.getPositionStream(
            locationSettings: const LocationSettings(distanceFilter: 10))
        .listen((position) async {
      await FirebaseFirestore.instance
          .collection("taxistas-disponibles")
          .doc(usuarioActual.uid)
          .set({'lat': position.latitude, 'lng': position.longitude});
    });
  }

  static Future<http.Response?> aceptarSolicitud(String idSolicitud) async {
    final documentoSolicitud = await FirebaseFirestore.instance
        .collection("solicitudes")
        .doc(idSolicitud)
        .get();
    if (documentoSolicitud.exists) {
      final objetoSolicitudRuta =
          RutaActual.fromJson(documentoSolicitud.data()!);

      if (objetoSolicitudRuta.idTaxista == "no-data") {
        final documentoTaxista = await FirebaseFirestore.instance
            .collection("taxistas")
            .doc(usuarioActual.uid)
            .get();
        final datosTaxista = documentoTaxista.data()!;

        await FirebaseFirestore.instance
            .collection("solicitudes")
            .doc(idSolicitud)
            .update({
          "id_taxista": documentoTaxista.id,
          "status": "aceptado",
          "datos_auto_taxista": {
            "modelo": datosTaxista['auto_modelo'],
            "placa": datosTaxista['auto_placa'],
            "color": datosTaxista['auto_color'],
          },
          "telefono_taxista": datosTaxista['telefono'],
          "token_taxista": datosTaxista['token'],
          "nombre_taxista": datosTaxista['nombre'],
        });

        final documentoSolicitud = await FirebaseFirestore.instance
            .collection("solicitudes")
            .doc(idSolicitud)
            .get();
        final rutaActual = RutaActual.fromJson(documentoSolicitud.data()!);
        return await _enviarNotificacion(rutaActual.tokenCliente);
      } else {
        Navigator.pop(contextoHomeScreen);
        showDialog(
            context: contextoHomeScreen,
            builder: (context) => const DialogoProgreso(
                  titulo: "La solicitud ya fue aceptada por otro taxista",
                  color: Colors.amber,
                ));
        return null;
      }
    } else {
      //PARA CERRAR EL DIALOGO DE SOLICITUD
      Navigator.pop(contextoHomeScreen);
      showDialog(
          context: contextoHomeScreen,
          builder: (context) => const DialogoProgreso(
                titulo: "La solicitud ha sido cancelada",
                color: Colors.amber,
              ));
      return null;
    }
  }

  static void calcularRuta(RutaActual rutaActual) async {
    _enviarPosicionActualTiempoReal(rutaActual);

    final rutaApiGoogle = await ProviderGoogleApis.obtenerRuta(rutaActual);

    final latlngInicio = LatLng(rutaActual.coordenadasInicio.latitud,
        rutaActual.coordenadasInicio.longitud);
    final latlngDestino = LatLng(rutaActual.coordenadasDestino.latitud,
        rutaActual.coordenadasDestino.longitud);
    final nombreLugarInicio = rutaActual.lugarInicio;
    final nombreLugarDestino = rutaActual.lugarInicio;

    Set<Marker> markers = {};
    markers.add(Marker(
      markerId: const MarkerId("Marker-posicion-actual"),
      position: latlngInicio,
      infoWindow: InfoWindow(
          title: "Posicion del pasajero", snippet: nombreLugarInicio),
    ));

    markers.add(Marker(
      markerId: const MarkerId("Marker-posicion-destino"),
      position: latlngDestino,
      infoWindow: InfoWindow(
          title: "Destino del pasajero", snippet: nombreLugarDestino),
    ));

    List<LatLng> pLineCoordinates = [];
    Set<Polyline> polylineSet = {};
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodePolylinePointsResult =
        polylinePoints.decodePolyline(rutaApiGoogle.rutaCodificada);

    if (decodePolylinePointsResult.isNotEmpty) {
      for (var pointLatLng in decodePolylinePointsResult) {
        pLineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      }
    }

    Polyline polyline = Polyline(
        polylineId: const PolylineId("ruta-codificada"),
        color: Colors.black,
        jointType: JointType.round,
        points: pLineCoordinates,
        width: 4);

    polylineSet.add(polyline);

    Provider.of<ProviderHomeScreen>(contextoHomeScreen, listen: false)
        .listaMarkers = markers;
    Provider.of<ProviderHomeScreen>(contextoHomeScreen, listen: false)
        .polylineRuta = polylineSet;
  }

  static void _enviarPosicionActualTiempoReal(RutaActual rutaActual) async {
    await FirebaseFirestore.instance
        .collection("solicitudes")
        .doc(rutaActual.idSolicitud)
        .update({
      "coordenadas_posicion_taxista": {
        "latitud": posicionActual.latitude,
        "longitud": posicionActual.longitude
      }
    });
  }

  static void escucharNotificacionesAppAbierta() {
    streamSuscriptionEscucharNotificacionesAppAbierta =
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final dataMap = message.data;

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPluginMessaging.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: "launch_background",
            ),
          ),
        );

        showDialog(
            barrierDismissible: false,
            context: contextoHomeScreen,
            builder: (context) => DialogoProgreso(
                  titulo: "Nueva solicitud de taxi",
                  child: Column(
                    children: [
                      ListTile(
                          title: Text("${dataMap['id_solicitud']}"),
                          subtitle: const Text("Numero de solicitud")),
                      ListTile(
                          title: Text("${notification.body}"),
                          subtitle: const Text("informacion de la solicitud")),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              child: const Text("Aceptar"),
                              onPressed: () async => await aceptarSolicitud(
                                  dataMap['id_solicitud'])),
                          ElevatedButton(
                              child: const Text("Cancelar"),
                              onPressed: () => Navigator.pop(context)),
                        ],
                      )
                    ],
                  ),
                ));
      }
    });
  }

  static void escucharNotificacionesAppSinAbrir() {
    streamSuscriptionEscucharNotificacionesAppSinAbrir =
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final dataMap = message.data;

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPluginMessaging.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: "launch_background",
            ),
          ),
        );

        showDialog(
            barrierDismissible: false,
            context: contextoHomeScreen,
            builder: (context) => DialogoProgreso(
                  titulo: "Nueva solicitud de taxi",
                  child: Column(
                    children: [
                      ListTile(
                          title: Text("${dataMap['id_solicitud']}"),
                          subtitle: const Text("Numero de solicitud")),
                      ListTile(
                          title: Text("${notification.body}"),
                          subtitle: const Text("informacion de la solicitud")),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              child: const Text("Aceptar"),
                              onPressed: () async => await aceptarSolicitud(
                                  dataMap['id_solicitud'])),
                          ElevatedButton(
                              child: const Text("Cancelar"),
                              onPressed: () => Navigator.pop(context)),
                        ],
                      )
                    ],
                  ),
                ));
      }
    });
  }

  static void cerrarSesion(BuildContext context) async {
    streamSuscriptionEscucharNotificacionesAppAbierta.cancel();
    streamSuscriptionEscucharNotificacionesAppSinAbrir.cancel();
    streamEscucharRutaActual.cancel();
    streamSubscriptionEscucharPosicionActual.cancel();
    Navigator.pushNamedAndRemoveUntil(
        context, LoginScreen.idScreen, (route) => false);
    await FirebaseAuth.instance.signOut();
  }

  static Future<void> cambiarStatusRutaActual(
      String idSolicitud, String status) async {
    return await FirebaseFirestore.instance
        .collection("solicitudes")
        .doc(idSolicitud)
        .update({"status": status});
  }

  static Future<http.Response> _enviarNotificacion(String token) async {
    Uri uri = Uri.parse("https://fcm.googleapis.com/fcm/send");

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "key=$firebaseMessagingKey"
    };

    Map<String, String> dataMap = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
    };

    Map<String, dynamic> notificationMap = {
      "title": "Un taxista acepto tu solicitud!",
      "body": "Un taxi va en camino al lugar que indicaste en la solicitud"
    };

    Map<String, dynamic> body = {
      "to": token,
      "notification": notificationMap,
      "data": dataMap
    };
    return await http.post(uri, headers: headers, body: json.encode(body));
  }
}
