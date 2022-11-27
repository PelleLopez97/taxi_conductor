import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../global/metodos_globales.dart';
import '../global/variables_globales.dart';
import '../screens/home_screen.dart';

class ProviderRegistroScreen extends ChangeNotifier {
  static GlobalKey<FormState> formStateKeyUsuario = GlobalKey<FormState>();
  static GlobalKey<FormState> formStateKeyAuto = GlobalKey<FormState>();
  static PageController pageControllerRegistroScreen = PageController();

  bool _contrasenaVisible = false;

  set contrasenaVisible(bool valor) {
    _contrasenaVisible = valor;
    notifyListeners();
  }

  bool get contrasenaVisible => _contrasenaVisible;

  static bool validarFormularioUsuario() {
    return formStateKeyUsuario.currentState?.validate() ?? false;
  }

  static bool validarFormularioAuto() {
    return formStateKeyAuto.currentState?.validate() ?? false;
  }

  static void registrarUsuario(BuildContext context) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: controllerCorreoUsuario.text,
              password: controllerContrasenaUsuario.text);
      if (credential.user != null) {
        Map<String, dynamic> mapaUsuario = {
          "auto_modelo": controllerModeloAuto.text.trim(),
          "auto_placa": controllerPlacaAuto.text.trim(),
          "auto_color": controllerColorAuto.text.trim(),
          "contrasena": controllerContrasenaUsuario.text.trim(),
          "telefono": controllerTelefonoUsuario.text.trim(),
          "nombre": controllerNombreUsuario.text.trim(),
          "correo": controllerCorreoUsuario.text.trim(),
          "token": "no-token",
          "url_photo": 'no-image',
          "raiting": 0.1,
          "ganancias": 0.1
        };

        await FirebaseFirestore.instance
            .collection("taxistas")
            .doc(credential.user!.uid)
            .set(mapaUsuario)
            .then((value) {
          limpiarControlladoresTexto();

          Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.idScreen, (route) => false);
        });
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error ${e.message.toString()}")));
    }
  }
}
