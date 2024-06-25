import 'package:flutter/material.dart';
import 'layout.dart'; // Importamos el archivo donde está definido Layout

class FloristeriaTata extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Layout(
      title: 'Floristería la Tata',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Image.network(
              'https://floristerialatata.com/wp-content/uploads/2020/02/cropped-latata2-5-337x138.png',
              width: 300,
              height: 200,
            ),
            Text(
              'Bienvenido a Floristería LA TATA',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
