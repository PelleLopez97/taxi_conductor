import 'package:flutter/material.dart';

class DialogoProgreso extends StatelessWidget {
  const DialogoProgreso({
    Key? key,
    required this.titulo,
    this.color = Colors.white,
    this.child    
    }) : super(key: key);

  final String titulo;
  final Color? color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {


    return Dialog(
      alignment: Alignment.center,
      insetPadding: const EdgeInsets.all(30),
      backgroundColor: color,
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15)
          ),
          child: Padding(
            padding:  const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:  [
                Text(titulo,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                const SizedBox(height: 5,),
                child ?? const SizedBox.shrink(),
              ],
            ),
          ),
      ),
    );
  }
}

