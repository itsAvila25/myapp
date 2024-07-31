
import 'package:flutter/material.dart';

class detalleHistorialPedido extends StatelessWidget {
  const detalleHistorialPedido({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Historial de Pedido"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network('https://floristerialatata.com/wp-content/uploads/2020/02/cropped-latata2-5-337x138.png'), // Replace with your image path
            Card(
              color: Color.fromARGB(255, 255, 170, 222),
              margin: EdgeInsets.all(10),
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 10),
                    Text(
                      'ARREGLO DE ANIVERSARIO',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    Text('Descripción: Arreglo floral para aniversarios',
                        style: TextStyle(
                           fontSize: 20)),
                    const SizedBox(height: 10),
                    Text('Precio:200.000',
                        style: TextStyle(
                            fontSize: 20)),
                    const SizedBox(height: 10),
                    Text('Cantidad: 2',
                        style: TextStyle(
                            fontSize: 20)),
                    Text('Subtotal: 400.000',
                        style: TextStyle(
                            fontSize: 20)),
                    Image.network('https://floristeriaalnaturalmedellin.com/wp-content/uploads/2020/11/WhatsApp-Image-2020-11-19-at-9.14.14-PM-1.jpeg'),
                    
                  ],
                ),
              ),
            ),
          ],
        ),
     ),
);
}
}