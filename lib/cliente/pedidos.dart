// pedidos.dart
import 'package:flutter/material.dart';
import 'layout.dart';

class pedidos extends StatefulWidget {
  const pedidos({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _pedidosState createState() => _pedidosState();
}

class _pedidosState extends State<pedidos> {
  List<dynamic> _data = [
    {
      'id': 1,
      'fecha': '2024-06-06',
      'estado': 'Enviado',
    },
    // Agrega más datos quemados aquí
  ];

  void _ver(int id) {
    // Implementar lógica para aceptar el pedido
    print('Ver PQRS: $id');
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: widget.title,
      body: ListView.builder(
        itemCount: _data.length,
        itemBuilder: (BuildContext context, int index) {
          final data = _data[index];

          return Column(
            children: <Widget>[
              Image.network('https://floristerialatata.com/wp-content/uploads/2020/02/cropped-latata2-5-337x138.png'),
              Card(
                color: Color.fromARGB(255, 255, 170, 222),
                margin: EdgeInsets.all(10),
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'ID: ${data['id']}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            Text('Fecha Pedido: ${data['fecha']}'),
                            const SizedBox(height: 10),
                            Text('Estado: ${data['estado']}'),
                          ],
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () => _ver(data['id']),
                            child: Text(
                              'Ver PQRS',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 255, 102, 204),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
