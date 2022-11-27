import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../global/variables_globales.dart';
import '../provider/provider.recuperacion.contrasena.dart';

class RecuperarContrasena extends StatelessWidget {
  static const idScreen = 'recuperar';

  const RecuperarContrasena({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(),
        body: Stack(
          fit: StackFit.expand,
          children: [
            _FondoScreen(size: size),
            _LogoInicioSesion(size: size),
            _ContenedorFormulario(size: size),
          ],
        ));
  }
}

class _LogoInicioSesion extends StatelessWidget {
  final Size size;

  const _LogoInicioSesion({
    required this.size,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Pide Taxi',
          style: TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        ),
        Image.asset(
          'assets/logo.png',
          width: 80,
          height: 80,
        ),
      ],
      // )
    );
  }
}

class _FondoScreen extends StatelessWidget {
  final Size size;

  const _FondoScreen({
    required this.size,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              stops: [0.5, 0.8],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.amber, Colors.white])),
    );
  }
}

class _ContenedorFormulario extends StatelessWidget {
  final Size size;

  const _ContenedorFormulario({
    required this.size,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          height: size.height * 0.30,
          margin: EdgeInsets.only(
              top: size.height / 3.3,
              left: size.width * 0.05,
              right: size.width * 0.05),
          padding: const EdgeInsets.symmetric(horizontal: 60),
          decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black, blurRadius: 10, offset: Offset(0, 5))
              ]),
          child: const _FormularioRecuperarcontrasena()),
    );
  }
}

class _FormularioRecuperarcontrasena extends StatelessWidget {
  const _FormularioRecuperarcontrasena({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
        autovalidateMode: AutovalidateMode.disabled,
        key: ProviderRecuperacionContrasena
            .keyEstadoFormularioRecuperarContrasena,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: controllerCorreoUsuario,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    hintText: 'ejemplo@gmail.com',
                    labelText: 'Correo electronico',
                    suffixIcon: Icon(Icons.people)),
                validator: (value) {
                  String pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp = RegExp(pattern);
                  return regExp.hasMatch(value ?? '')
                      ? null
                      : 'Correo no valido';
                }),
            ElevatedButton(
                child: const Text("Enviar",
                    style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold")),
                onPressed: () =>
                    ProviderRecuperacionContrasena.validarFormulario()
                        ? enviarSolicitudRecuperacionContrasena(context)
                        : null)
          ],
        ));
  }

  void enviarSolicitudRecuperacionContrasena(BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: controllerCorreoUsuario.text);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Solitud enviada")));
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("${error.message}")));
    }
  }
}
