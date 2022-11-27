
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../global/variables_globales.dart';
import '../provider/provider_login_screen.dart';
import 'recuperar_contrasena_screen.dart';
import 'registro_screen.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const idScreen = "login";

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
        _ContenedorFormulario( size: size),
        _OpcionesLogin(size: size),
     ],
    )
  );
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
        const Text('Pide Taxi',textAlign: TextAlign.center,style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic)),
        Image.asset('assets/logo.png',  width: 80,height: 80,),
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
           stops: [
             0.5,
             0.8
           ],
           begin: Alignment.topCenter,
           end: Alignment.bottomCenter,
           colors: [
             Colors.amber,
            Colors.white
           ]
        )
              ),
            );
  }
}



class _OpcionesLogin extends StatelessWidget {
  const _OpcionesLogin({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.67),
      child: SingleChildScrollView(
        child: Column(
             children: [
                TextButton(
                           onPressed: () => Navigator.pushNamed(context, RegistroScreen.idScreen),
                           child: const Text("No tienes una cuenta? Registrate aqui", 
                           style: TextStyle(decoration: TextDecoration.underline, color: Colors.black),
                           )),
               TextButton(
                           onPressed: () => Navigator.pushNamed(context, RecuperarContrasena.idScreen),
                           child: const Text("¿Olvidaste tu contraseña?",
                             style: TextStyle(decoration: TextDecoration.underline, color: Colors.black),
                           )),
      
             ],
         ),
      ),
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
    return  SingleChildScrollView(
        child: Container(
          height: size.height / 2.5,
          margin: EdgeInsets.only(
            top: size.height * 0.20,
            left: size.width * 0.05, 
            right: size.width * 0.05),
          padding: const EdgeInsets.symmetric(horizontal:40),
           decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 10,
                            offset: Offset(0, 5)
                          )
                        ]
                      ),      
          child: const _FormularioLogin()
        ),
    );
  }  
}

  class _FormularioLogin extends StatelessWidget {

  const _FormularioLogin({Key? key}) : super(key: key);
  
    @override
    Widget build(BuildContext context) {

      return Form(
        key: ProviderLoginScreen.formStateKeyLogin,
        autovalidateMode: AutovalidateMode.disabled,
        child:  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextFormField(                        
                        controller: controllerCorreoUsuario,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.emailAddress,     
                        textInputAction: TextInputAction.next,                   
                        decoration: const InputDecoration(
                          hintText: 'usuario@gmail.com', 
                          labelText: 'Correo electronico', 
                          suffixIcon: Icon(Icons.alternate_email)),
                        validator: ( value ) {
                          String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                          RegExp regExp  = RegExp(pattern);

                          return regExp.hasMatch(value?? '') ? null : 'Correo no valido';

                        },                        
                        ),

                      TextFormField(
                        controller: controllerContrasenaUsuario,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        obscureText: Provider.of<ProviderLoginScreen>(context).contrasenaVisible,
                        keyboardType: TextInputType.text,     
                        decoration:  InputDecoration(
                          suffixIcon: IconButton(onPressed: ()=> Provider.of<ProviderLoginScreen>(context,listen: false).contrasenaVisible = !Provider.of<ProviderLoginScreen>(context,listen: false).contrasenaVisible,
                                                   icon: Icon( Provider.of<ProviderLoginScreen>(context,listen: false).contrasenaVisible ? Icons.visibility_off : Icons.visibility )),
                          hintText: '********',
                          labelText: 'Contraseña',
                           ),
                        validator: (value) => (value != null && value.length >= 6) ? null : 'La contraseña debe ser mayor o igual a 6 caracteres',  
                          ),
                        
                      ElevatedButton.icon(                      
                        icon:  const Icon(Icons.login),
                        label: const Text('Iniciar sesion'), 
                        onPressed: () => ProviderLoginScreen.validarFormularioUsuario() ? ProviderLoginScreen.login(context) : null, 
                      )
                    ],)
        
        );
    }

   

    }