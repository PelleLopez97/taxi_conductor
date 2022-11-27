import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../global/metodos_globales.dart';
import '../global/variables_globales.dart';
import '../screens/home_screen.dart';
import '../widgets/dialogo_progreso.dart';


class ProviderLoginScreen extends ChangeNotifier{


  
 static GlobalKey<FormState> formStateKeyLogin = GlobalKey<FormState>();


 bool _contrasenaVisible = false;
  // bool _cargandoLogin = false;

  // set cargandoLogin(bool valor){
  //   _cargandoLogin = valor;
  //   notifyListeners();
  // }

  // bool get cargandoLogin => _cargandoLogin;

  
set contrasenaVisible(bool valor){
  _contrasenaVisible = valor;
  notifyListeners();
}

bool get contrasenaVisible => _contrasenaVisible;


static bool validarFormularioUsuario(){
  return formStateKeyLogin.currentState?.validate()?? false;
}


static void login(BuildContext context)async{
     showDialog(context: context,barrierDismissible: false, builder: (context)=> const DialogoProgreso(titulo: "Cargando . . .",color: Colors.amber,));
    try{

    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: controllerCorreoUsuario.text, password: controllerContrasenaUsuario.text);
   

    if(credential.user != null){

      final documentoUsuario = await FirebaseFirestore.instance.collection("taxistas").doc(credential.user!.uid).get(); 

       if(documentoUsuario.exists){
         Navigator.pop(context);
         Navigator.pushNamedAndRemoveUntil(context, HomeScreen.idScreen, (route) => false);
         limpiarControlladoresTexto();
       }else{
         Navigator.pop(context);
         showDialog(context: context,barrierDismissible: true, builder: (context)=> const DialogoProgreso(titulo: "Su usuario no existe",color: Colors.redAccent,));
       }

    }
    
    }on FirebaseAuthException catch(exception){         
      Navigator.pop(context); // Para cerrar el dialogo de progreso
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${exception.message}")));

    }
  }


}