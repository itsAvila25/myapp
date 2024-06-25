import 'package:flutter/material.dart';

class detallePQRS extends StatelessWidget {
  const detallePQRS({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalle de PQRS"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
                'https://floristerialatata.com/wp-content/uploads/2020/02/cropped-latata2-5-337x138.png'), // Replace with your image path
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
                      'TIPO: Queja',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    Text('Motivo:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    const SizedBox(height: 10),
                    Text('Mal estado de los productos entregados'),
                    const SizedBox(height: 10),
                    Text('Descripción:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    const SizedBox(height: 10),
                    Text(
                        'Buen día, espero se encuentre muy bien, quiero quejarme por el mal estado de mi arreglo floral recibido el día 1 de junio de 2024, las flores llegaron marchitas y los dulces en mal estado'),
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
