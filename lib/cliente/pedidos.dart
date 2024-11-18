import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'layout.dart';
import 'package:intl/intl.dart';
import './detalle_pedido.dart';
import 'package:shared_preferences/shared_preferences.dart';

class pedidos extends StatefulWidget {
  const pedidos({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _pedidosState createState() => _pedidosState();
}

class _pedidosState extends State<pedidos> {
  List<dynamic> _data = [];

  @override
  void initState() {
    super.initState();
    _fetchPedidos();
  }

  Future<void> _fetchPedidos() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token =
          prefs.getString('access_token'); // Obtener el token almacenado
      String? userId = prefs.getString('user_id');// Obtener el ID del usuario almacenado
      
      print("El usuario :{$token}");
      print("El usuario es:{$userId}");
      final response = await http.get(
        Uri.parse(
            'http://localhost:8000/api/pedido/cliente/$userId'), // Usar el ID en la URL
        headers: {
          'Authorization': 'Bearer $token', // Agregar el token en las cabeceras
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          _data = responseData; // Asignar los datos obtenidos
        });
      } else {
        throw Exception('Error al cargar los pedidos');
      }
    } catch (error) {
      print('Error al obtener pedidos: $error');
    }
  }

  void _verDetalle(int id) {
    // Aquí iría la navegación o funcionalidad para ver el detalle
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetallePedido(id: id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: widget.title,
      body: ListView.builder(
        itemCount: _data.length,
        itemBuilder: (BuildContext context, int index) {
          final data = _data[index];

          DateTime fechaPedido = DateTime.parse(data['fechapedido']);

          String formattedDate = DateFormat('dd/MM/yy').format(fechaPedido);

          return Column(
            children: <Widget>[
              Image.network(
                  'https://floristerialatata.com/wp-content/uploads/2020/02/cropped-latata2-5-337x138.png'),
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
                            Text('Fecha Pedido: $formattedDate'),
                            const SizedBox(height: 10),
                            Text('Estado: ${data['estado']}'),
                            const SizedBox(height: 10),
                            Text('Total: ${data['total']}'),
                          ],
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () => _verDetalle(data['id']),
                            child: Text(
                              'Ver Detalle',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 255, 102, 204),
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
