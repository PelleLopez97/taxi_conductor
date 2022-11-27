import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pide_taxi_conductor_v2/screens/detalles_taxista_screen.dart';
import 'package:provider/provider.dart';

import 'global/metodos_globales.dart';
import 'global/variables_globales.dart';
import 'provider/provider_home_screen.dart';
import 'provider/provider_login_screen.dart';
import 'provider/provider_registro_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/recuperar_contrasena_screen.dart';
import 'screens/registro_screen.dart';
import 'theme/theme_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );
  }

  flutterLocalNotificationsPluginMessaging = FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPluginRealtime = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPluginMessaging
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await flutterLocalNotificationsPluginRealtime
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProviderHomeScreen()),
        ChangeNotifierProvider(create: (context) => ProviderLoginScreen()),
        ChangeNotifierProvider(create: (context) => ProviderRegistroScreen()),
      ],
      child: MaterialApp(
        theme: temaOscuro,
        title: 'Material App',
        initialRoute: FirebaseAuth.instance.currentUser == null
            ? LoginScreen.idScreen
            : HomeScreen.idScreen,
        routes: {
          HomeScreen.idScreen: (context) => const HomeScreen(),
          LoginScreen.idScreen: (context) => const LoginScreen(),
          RegistroScreen.idScreen: (context) => const RegistroScreen(),
          RecuperarContrasena.idScreen: (context) =>
              const RecuperarContrasena(),
          DetallesTaxistaScreen.idScreen: (context) =>
              const DetallesTaxistaScreen(),
        },
      ),
    );
  }
}
