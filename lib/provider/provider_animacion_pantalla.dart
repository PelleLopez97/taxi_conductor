import 'package:flutter/material.dart';


enum EstadoPantalla{
  pantallaGrande,
  pantallaPequena
}


class ProviderAnimacionPantalla extends ChangeNotifier{

  EstadoPantalla estadoPantalla = EstadoPantalla.pantallaGrande;


  void cambiarPantallaPequena(){
    estadoPantalla = EstadoPantalla.pantallaPequena;
    notifyListeners();
  }
  void cambiarPantallaGrande(){
    estadoPantalla = EstadoPantalla.pantallaGrande;
    notifyListeners();
  }


}
