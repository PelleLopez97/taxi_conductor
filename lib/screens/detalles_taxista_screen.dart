import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pide_taxi_conductor_v2/global/variables_globales.dart';
import 'package:pide_taxi_conductor_v2/models/ruta_actual.dart';

class DetallesTaxistaScreen extends StatelessWidget {
  const DetallesTaxistaScreen({super.key});

  static const idScreen = "ganancias";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          _GananciasRaitingItem(size: size),
          _RutasTerminadas(size: size)

          // =======================================
          // GANANCIAS
        ],
      )),
    );
  }
}

class _RutasTerminadas extends StatelessWidget {
  final Size size;
  const _RutasTerminadas({required this.size});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: size.width * 0.02,
          right: size.width * 0.02,
          top: size.height * 0.005),
      width: size.width,
      height: size.height * 0.50,
      decoration: const BoxDecoration(
          // color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: StreamBuilder(
        builder: (context, snapshot) {
          // print("lengh data => ${snapshot.data!.docs.length}");

          if (!snapshot.hasData) {
            return const Text("no data");
          }

          final registrosViajesTerminados = snapshot.data!.docs
              .map((DocumentSnapshot e) =>
                  RutaActual.fromJson(e.data() as Map<String, dynamic>))
              .toList();

          return ListView.builder(
            itemCount: registrosViajesTerminados.length,
            itemBuilder: (context, index) {
              return _ItemDetallesRutaActual(
                  rutaActual: registrosViajesTerminados[index], size: size);
            },
          );
        },
        stream: FirebaseFirestore.instance
            .collection("solicitudes")
            .where("id_taxista", isEqualTo: usuarioActual.uid.toString())
            .where("status", isEqualTo: "terminado")
            .snapshots(),
      ),
    );
  }
}

class _GananciasRaitingItem extends StatelessWidget {
  final Size size;
  const _GananciasRaitingItem({required this.size});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height * 0.40,
      margin: EdgeInsets.only(
          left: size.width * 0.02,
          right: size.width * 0.02,
          top: size.height * 0.02),
      decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("taxistas")
            .doc(usuarioActual.uid)
            .snapshots(),
        builder: (context, snapshot) {
          double ganancias = 0.0;
          double raiting = 0.0;

          if (snapshot.hasData) {
            ganancias =
                double.parse(snapshot.data!.data()!["ganancias"].toString())
                    .roundToDouble();
            raiting = double.parse(snapshot.data!.data()!["raiting"].toString())
                .roundToDouble();
          }

          return Column(
            children: [
              const Text(
                "Tus ganancias",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
              Container(
                // width: size.width,
                margin: EdgeInsets.only(
                    top: size.height * 0.02,
                    left: size.width * 0.15,
                    right: size.width * 0.15),
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Text(
                  "\$$ganancias",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
              // GANANCIAS
              // =======================================
              // =======================================
              // RAITING

              SizedBox(
                height: size.height * 0.05,
              ),

              const Text(
                "Tu evaluacion como taxista",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
              Container(
                // width: size.width,
                margin: EdgeInsets.only(
                    top: size.height * 0.02,
                    left: size.width * 0.22,
                    right: size.width * 0.22),
                padding: const EdgeInsets.all(35),
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
                child: Column(
                  children: [
                    Text(
                      "$raiting",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 22),
                    ),
                    RatingBar.builder(
                      itemSize: 18,
                      initialRating: raiting,
                      minRating: 1,
                      updateOnDrag: false,
                      tapOnlyMode: true,
                      glow: false,
                      itemCount: 5,
                      itemBuilder: (context, indice) => const Icon(
                        Icons.star_border_purple500_rounded,
                        color: Colors.amber,
                        size: 16,
                      ),
                      onRatingUpdate: (cantidadPasajero) => cantidadPasajero,
                    ),
                  ],
                ),
              ),
              // RAITING
              // =======================================
            ],
          );
        },
      ),
    );
  }
}

class _ItemDetallesRutaActual extends StatelessWidget {
  final Size size;

  final RutaActual rutaActual;

  const _ItemDetallesRutaActual({
    Key? key,
    required this.rutaActual,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.95,
      margin: EdgeInsets.all(size.width * 0.1),
      decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black, blurRadius: 1, spreadRadius: 1)
          ],
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Container(
            margin: const EdgeInsets.all(18),
            child: Column(
              children: [
                Text(
                  "Distancia ${rutaActual.distanciaRuta}",
                ),
                Text(
                  "Tiempo estimado ${rutaActual.duracionRuta}",
                ),
                Text(
                  "Costo de la ruta\$${rutaActual.costoRuta}",
                ),
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
            BoxShadow(color: Colors.black54, blurRadius: 1, spreadRadius: 0.5)
          ],
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(subtitle, style: const TextStyle(fontWeight: FontWeight.w300)),
        ],
      ),
    );
  }
}
