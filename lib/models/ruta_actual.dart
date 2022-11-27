

class RutaActual {


  CoordenadasDestino coordenadasDestino = CoordenadasDestino();
  CoordenadasInicio coordenadasInicio = CoordenadasInicio();
  CoordenadasPosicionTaxista coordenadasPosicionTaxista = CoordenadasPosicionTaxista();
  CoordenadasPosicionCliente coordenadasPosicionCliente = CoordenadasPosicionCliente();
  DatosAutoTaxista datosAutoTaxista = DatosAutoTaxista();
  String idSolicitud = "no-data";
  String fecha = "no-data";
  String nombreTaxista = "no-data";
  String duracionRuta = "no-data";
  String distanciaRuta = "no-data";
  String idCliente = "no-data";
  String nombreCliente = "no-data";
  String telefonoCliente = "no-data";
  String tipoSolicitud = "no-data";
  String tokenCliente = "no-data";
  String idTaxista = "no-data";
  String tokenTaxista = "no-data";
  String telefonoTaxista = "no-data";
  String lugarDestino = "no-data";
  String lugarInicio = "no-data";
  String status = "no-data";
  int cantidadPasajeros = 0;
  double costoRuta = 0;

  RutaActual();

  RutaActual.fromJson(Map<String,dynamic> dataMap){
    coordenadasDestino = CoordenadasDestino.fromJson(dataMap["coordenadas_destino"]);
    coordenadasInicio  = CoordenadasInicio.fromJson(dataMap["coordenadas_inicio"]);
    coordenadasPosicionCliente = CoordenadasPosicionCliente.fromJson(dataMap["coordenadas_posicion_cliente"]);
    coordenadasPosicionTaxista = CoordenadasPosicionTaxista.fromJson(dataMap["coordenadas_posicion_taxista"]);
    datosAutoTaxista   = DatosAutoTaxista.fromJson(dataMap["datos_auto_taxista"]);
    fecha              = dataMap["fecha"];
    duracionRuta       = dataMap["duracion_ruta"];
    distanciaRuta      = dataMap["distancia_ruta"];
    idCliente          = dataMap["id_cliente"];
    nombreCliente      = dataMap["nombre_cliente"];
    telefonoCliente    = dataMap["telefono_cliente"];
    tipoSolicitud      = dataMap["tipo_solicitud"];
    tokenCliente       = dataMap["token_cliente"];  
    idTaxista          = dataMap["id_taxista"];
    nombreTaxista      = dataMap["nombre_taxista"];
    tokenTaxista       = dataMap["token_taxista"];  
    telefonoTaxista    = dataMap["telefono_taxista"];
    lugarDestino       = dataMap["lugar_destino"];
    lugarInicio        = dataMap["lugar_inicio"];
    status             = dataMap["status"];
    cantidadPasajeros  = dataMap["cantidad_pasajeros"];   
    costoRuta          = dataMap["costo_ruta"];  
  }
}

class CoordenadasDestino {

double latitud = 0.0;
double longitud = 0.0;

CoordenadasDestino();

    CoordenadasDestino.fromJson(Map<String,dynamic> dataMap){
      latitud = dataMap["latitud"]!;
      longitud = dataMap["longitud"]!;
    }
}
class CoordenadasInicio {


double latitud = 0.0;
double longitud = 0.0;

CoordenadasInicio();

    CoordenadasInicio.fromJson(Map<String,dynamic> dataMap){
      latitud = dataMap["latitud"]!;
      longitud = dataMap["longitud"]!;
    }
}


class CoordenadasPosicionCliente {

double latitud = 0.0;
double longitud = 0.0;

CoordenadasPosicionCliente();

    CoordenadasPosicionCliente.fromJson(Map<String,dynamic> dataMap){
      latitud = dataMap["latitud"]!;
      longitud = dataMap["longitud"]!;
    }
}



class CoordenadasPosicionTaxista {

double latitud = 0.0;
double longitud = 0.0;

CoordenadasPosicionTaxista();

    CoordenadasPosicionTaxista.fromJson(Map<String,dynamic> dataMap){
      latitud = dataMap["latitud"]!;
      longitud = dataMap["longitud"]!;
    }
}

class DatosAutoTaxista {

String modelo = "no-data";
String color = "no-data";
String placa = "no-data";

DatosAutoTaxista();

    DatosAutoTaxista.fromJson(Map<String,dynamic> dataMap){
      modelo = dataMap["modelo"]!;
      color  = dataMap["color"]!;
      placa  = dataMap["placa"]!;
    }
}