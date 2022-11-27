import 'package:firebase_messaging/firebase_messaging.dart';

import 'variables_globales.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);  
}


void limpiarControlladoresTexto(){
  controllerColorAuto.clear();
  controllerContrasenaUsuario.clear();
  controllerCorreoUsuario.clear();
  controllerModeloAuto.clear();
  controllerNombreUsuario.clear();
  controllerPlacaAuto.clear();
  controllerTelefonoUsuario.clear();
}