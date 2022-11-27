

import 'package:flutter/material.dart';

class ProviderRecuperacionContrasena{

  static GlobalKey<FormState> keyEstadoFormularioRecuperarContrasena = GlobalKey<FormState>();
 
   
  static bool validarFormulario(){
     return keyEstadoFormularioRecuperarContrasena.currentState?.validate() ?? false;
   } 

}