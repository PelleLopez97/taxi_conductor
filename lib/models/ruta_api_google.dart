class RutaApiGoogle {
  int valorDistancia = 0 ;
  int valorDuracion = 0;
  String textoDistancia = "";
  String textoDuracion = "";
  String rutaCodificada = "";

  RutaApiGoogle({
   required this.valorDistancia,
   required this.valorDuracion,
   required this.textoDistancia,
   required this.textoDuracion, 
   required this.rutaCodificada
  });

  RutaApiGoogle.fromJson(Map<String,dynamic> dataMap){    
         valorDistancia = dataMap['routes'][0]['legs'][0]['distance'] ['value'];
         valorDuracion  = dataMap['routes'][0]['legs'][0]['duration'] ['value'];
         textoDistancia = dataMap['routes'][0]['legs'][0]['distance'] ['text'];
         textoDuracion  = dataMap['routes'][0]['legs'][0]['duration'] ['text'];
         rutaCodificada = dataMap['routes'][0]['overview_polyline']['points'];
  }

}
