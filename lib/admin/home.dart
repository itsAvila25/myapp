import 'package:flutter/material.dart';
import 'layout.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drawer Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: AdminDashboardScreen(), // Cambiado a HomePage
    );
  }
}

class AdminDashboardScreen  extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'Sección de administración',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 10), // Espacio entre el texto y la imagen
            Image.network(
              'https://floristerialatata.com/wp-content/uploads/2020/02/cropped-latata2-5-337x138.png',
              width: 300, 
              height: 200, // Altura de la imagen
            ),
            Text('Bienvenido Usuario',
            style:TextStyle(
              fontSize: 20
            )
            )
          ],
        ),
      ),
    );
  }
}
