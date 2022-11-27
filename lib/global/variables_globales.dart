import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';

// *********************************************************** //

TextEditingController controllerNombreUsuario = TextEditingController();
TextEditingController controllerTelefonoUsuario = TextEditingController();
TextEditingController controllerCorreoUsuario = TextEditingController();
TextEditingController controllerContrasenaUsuario = TextEditingController();
TextEditingController controllerModeloAuto = TextEditingController();
TextEditingController controllerPlacaAuto = TextEditingController();
TextEditingController controllerColorAuto = TextEditingController();
// *********************************************************** //
late Timer timerSolicitandoTaxi;
// *********************************************************** //
late String idSolicitudRuta;
// *********************************************************** //
// *********************************************************** //
int cantidadPasajeros = 1;
// *********************************************************** //
// *********************************************************** //
late StreamSubscription<Position> streamSubscriptionEscucharPosicionActual;
late StreamSubscription<RemoteMessage> streamSuscriptionEscucharNotificacionesAppAbierta;
late StreamSubscription<RemoteMessage> streamSuscriptionEscucharNotificacionesAppSinAbrir;
late StreamSubscription<QuerySnapshot<Map<String,dynamic>>> streamEscucharRutaActual;
// *********************************************************** //
// *********************************************************** //
late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPluginMessaging;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPluginRealtime;
// *********************************************************** //
late User usuarioActual; 
// *********************************************************** //
// *********************************************************** //
// *********************************************************** //