




import 'package:flutter/material.dart';



final temaOscuro = ThemeData.light().copyWith(

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.amber,
    elevation : 0.0
    // color: Colors.blue es lo mismo que backgroundColor
    ),
  

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(

      
      elevation: MaterialStateProperty.all(4),
      foregroundColor: MaterialStateProperty.all(Colors.black) ,
      textStyle: MaterialStateProperty.all(const TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
      backgroundColor: MaterialStateProperty.all(Colors.white)
    )
  ),

  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.amber[600],
    elevation: 0
  ),

  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: Colors.amber
  ),  

  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Colors.amber,

  ),

  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Colors.amber,
    
  ),

  inputDecorationTheme: InputDecorationTheme(
    
    labelStyle: const TextStyle(fontSize: 16, color: Colors.black,fontWeight: FontWeight.bold,),
    hintStyle:  const TextStyle(fontSize: 16, color: Colors.grey,fontWeight: FontWeight.bold),  
    
    suffixIconColor: Colors.grey,
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.brown,
        style: BorderStyle.solid,
        width: 1
        ),
      borderRadius: BorderRadius.circular(10)),

     contentPadding: const EdgeInsets.all(10),

     disabledBorder: OutlineInputBorder(
     borderSide: const BorderSide(
       color: Colors.amber,                                        
       width: 1,
       style: BorderStyle.solid),
       borderRadius: BorderRadius.circular(10),
     ),
     
     focusedErrorBorder: OutlineInputBorder(
     borderSide: const BorderSide(
       color: Colors.red,                                        
       width: 1,
       style: BorderStyle.solid),
       borderRadius: BorderRadius.circular(10),
     ),

     errorBorder: OutlineInputBorder(
     borderSide: const BorderSide(
       color: Colors.red,                                        
       width: 1,
       style: BorderStyle.solid),
       borderRadius: BorderRadius.circular(10),
     ),

    focusedBorder: OutlineInputBorder(
     borderSide: const BorderSide(
       color: Colors.amber, 
       width: 1,
       style: BorderStyle.solid  
     ),
     borderRadius:  BorderRadius.circular(10),
   ),
  ),
);


