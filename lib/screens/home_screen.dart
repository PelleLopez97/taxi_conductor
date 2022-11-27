import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pide_taxi_conductor_v2/screens/detalles_taxista_screen.dart';
import 'package:provider/provider.dart';

import '../models/ruta_actual.dart';
import '../provider/provider_animacion_pantalla.dart';
import '../provider/provider_home_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const idScreen = 'home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    ProviderHomeScreen.contextoHomeScreen = context;
    ProviderHomeScreen.consultarUsuario();
    ProviderHomeScreen.permisoUbicacion();
    ProviderHomeScreen.escucharNotificacionesAppAbierta();
    ProviderHomeScreen.escucharNotificacionesAppSinAbrir();
    ProviderHomeScreen.escucharRutasActuales();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  tooltip: "esto es el tool",
                  onPressed: () => Navigator.pushNamed(
                      context, DetallesTaxistaScreen.idScreen),
                  icon: const Icon(Icons.attach_money_rounded)),
              IconButton(
                  tooltip: "Cerrar sesion",
                  onPressed: () => ProviderHomeScreen.cerrarSesion(context),
                  icon: const Icon(Icons.login_outlined)),
            ],
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              _MapaUsuario(size: size),
              Provider.of<ProviderHomeScreen>(context)
                      .listaRutasActuales
                      .isNotEmpty
                  ? _RutasActuales(size: size)
                  : const SizedBox.shrink()
            ],
          ),
        ));
  }
}

class _MapaUsuario extends StatefulWidget {
  final Size size;

  const _MapaUsuario({required this.size});

  @override
  State<_MapaUsuario> createState() => _MapaUsuarioState();
}

class _MapaUsuarioState extends State<_MapaUsuario> {
  final initialCameraPosition = const CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(17.553113673601146, -99.5135981438487),
      tilt: 59.440717697143555,
      zoom: 15);

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
        mapType: MapType.normal,
        markers: Provider.of<ProviderHomeScreen>(context).listaMarkers,
        polylines: Provider.of<ProviderHomeScreen>(context, listen: false)
            .polylineRuta,
        trafficEnabled: false,
        myLocationEnabled: true,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: false,
        myLocationButtonEnabled: true,
        mapToolbarEnabled: false,
        rotateGesturesEnabled: true,
        buildingsEnabled: false,
        compassEnabled: false,
        initialCameraPosition: initialCameraPosition,
        onMapCreated: (GoogleMapController controller) =>
            ProviderHomeScreen.googleMapController = controller);
  }
}

class _RutasActuales extends StatelessWidget {
  void deslizamientoVertical(DragUpdateDetails dragUpdateDetails) {
    if (dragUpdateDetails.primaryDelta! <= -7) {
      listenerAnimacionPantalla.cambiarPantallaGrande();
    } else if (dragUpdateDetails.primaryDelta! >= 10) {
      listenerAnimacionPantalla.cambiarPantallaPequena();
    }
  }

  double obtenerAnchoPantalla() {
    double top = 0.0;

    if (listenerAnimacionPantalla.estadoPantalla ==
        EstadoPantalla.pantallaPequena) {
      top = size.height * 0.82;
    } else if (listenerAnimacionPantalla.estadoPantalla ==
        EstadoPantalla.pantallaGrande) {
      top = size.height * 0.02;
    }
    return top;
  }

  final listenerAnimacionPantalla = ProviderAnimacionPantalla();

  final Size size;
  _RutasActuales({Key? key, required this.size}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final listaRutasActuales =
        Provider.of<ProviderHomeScreen>(context).listaRutasActuales;

    return AnimatedBuilder(
      animation: listenerAnimacionPantalla,
      builder: (context, child) {
        return AnimatedPositioned(
          duration: const Duration(milliseconds: 700),
          curve: Curves.elasticOut,
          height: size.height * 0.86,
          left: 0.0,
          right: 0.0,
          top: obtenerAnchoPantalla(),
          child: GestureDetector(
            onVerticalDragUpdate: deslizamientoVertical,
            child: PageView.builder(
              onPageChanged: (index) =>
                  ProviderHomeScreen.calcularRuta(listaRutasActuales[index]),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: listaRutasActuales.length,
              itemBuilder: ((context, index) => _ItemDetallesRutaActual(
                    rutaActual: listaRutasActuales[index],
                    size: size,
                    indiceRuta: index,
                  )),
            ),
          ),
        );
      },
    );
  }
}

class _ItemDetallesRutaActual extends StatelessWidget {
  final Size size;

  final RutaActual rutaActual;

  final int indiceRuta;

  const _ItemDetallesRutaActual(
      {Key? key,
      required this.rutaActual,
      required this.size,
      required this.indiceRuta})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: size.width * 0.95,
      margin: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.grey, blurRadius: 5, spreadRadius: 1)
          ],
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        const Text(
          "Ruta",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
        ),
        Text("${indiceRuta + 1}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
        Container(
          decoration: BoxDecoration(
              color: Colors.black54, borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.only(
              left: size.width * 0.27,
              right: size.width * 0.27,
              top: size.height * 0.01,
              bottom: size.height * 0.03),
          height: 5,
        ),
        Container(
            margin: const EdgeInsets.all(18),
            child: Column(
              children: [
                Text("Distancia ${rutaActual.distanciaRuta}",
                    style: const TextStyle(fontSize: 22)),
                Text("Tiempo estimado ${rutaActual.duracionRuta}",
                    style: const TextStyle(fontSize: 22)),
                Text("Costo de la ruta\$${rutaActual.costoRuta}",
                    style: const TextStyle(fontSize: 22)),
                _ListTileCustom(
                    size: size,
                    title: rutaActual.lugarInicio,
                    subtitle: "Mi ubicación"),
                _ListTileCustom(
                    size: size,
                    title: rutaActual.lugarDestino,
                    subtitle: "Mi destino"),
                _ListTileCustom(
                  size: size,
                  title: rutaActual.cantidadPasajeros.toString(),
                  subtitle: "Cantidad de pasajeros",
                ),
                _ListTileCustom(
                  size: size,
                  title: rutaActual.telefonoCliente,
                  subtitle: "Telefono del cliente",
                ),
                _ListTileCustom(
                  size: size,
                  title: rutaActual.nombreCliente,
                  subtitle: "Nombre del cliente",
                ),
              ],
            )),
        rutaActual.status == "pagando"
            ? const Text(
                "El usuario esta evaluando el servicio",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
              )
            : const SizedBox.shrink(),
        rutaActual.status == "pagando"
            ? const CupertinoActivityIndicator(
                radius: 20,
              )
            : const SizedBox.shrink(),
        rutaActual.status == "pagando"
            ? const SizedBox.shrink()
            : Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: rutaActual.status == "pagando" ? 0 : 50),
                child: ElevatedButton(
                  onPressed: rutaActual.status == "aceptado"
                      ? () async =>
                          await ProviderHomeScreen.cambiarStatusRutaActual(
                              rutaActual.idSolicitud, "enRuta")
                      : () async =>
                          await ProviderHomeScreen.cambiarStatusRutaActual(
                              rutaActual.idSolicitud, "pagando"),
                  child: Text(
                      rutaActual.status == "aceptado"
                          ? "He llegado"
                          : "cobrar viaje",
                      style: const TextStyle(fontSize: 18)),
                ),
              )
      ]),
    );
  }
}

class _ListTileCustom extends StatelessWidget {
  final Size size;
  const _ListTileCustom(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.size})
      : super(key: key);
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.90,
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.grey, blurRadius: 1, spreadRadius: 0.5)
          ],
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          Text(subtitle,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w300)),
        ],
      ),
    );
  }
}
