import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'detalle_pedido.dart';
import 'layout.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pedidos',
      color: Colors.pink[100],
      home: MyHomePage(title: 'Lista de Pedidos'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> _data = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:8000/api/pedido'));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          _data = responseData;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print("Error al cargar los datos: $error");
    }
  }

  Future<void> _aceptarPedido(int id, String action) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8000/api/pedido/aceptar/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'action': action}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // Usar el mensaje devuelto por el backend
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );
        // Recargar los pedidos después del cambio de estado
        _fetchData();
      } else {
        throw Exception('Failed to update order');
      }
    } catch (error) {
      print("Error al aceptar el pedido: $error");
    }
  }

  Future<void> _rechazarPedido(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:8000/api/pedido/rechazar/$id'),
      );

      if (response.statusCode == 200) {
        // Recargar los pedidos después de eliminarlo
        _fetchData();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Pedido rechazado correctamente')));
      } else {
        throw Exception('Failed to reject order');
      }
    } catch (error) {
      print("Error al rechazar el pedido: $error");
    }
  }

  void _verDetalle(int id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetallePedido(id: id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: widget.title,
      body: ListView.builder(
        itemCount: _data.length,
        itemBuilder: (BuildContext context, int index) {
          final data = _data[index];

          DateTime fechaPedido = DateTime.parse(data['fechapedido']);

          String formattedDate = DateFormat('dd/MM/yy').format(fechaPedido);

          return GestureDetector(
            onTap: () => _verDetalle(data[
                'id']), // Navegar al detalle al hacer tap en cualquier parte del card
            child: Card(
              color: Color.fromARGB(255, 255, 185, 210),
              margin: EdgeInsets.all(10),
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pedido ID: ${data['id']}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          'Usuario: ${data['user_id']}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Total: ${data['total']}'),
                    const SizedBox(height: 8),
                    Text('Fecha Pedido: $formattedDate'),
                    const SizedBox(height: 8),
                    Text('Estado: ${data['estado']}'),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        if (data['estado'] != 'entregado') ...[
                          _buildActionButton(
                            label: 'Aceptar',
                            onPressed: () =>
                                _aceptarPedido(data['id'], 'accept'),
                            color: Colors.green,
                          ),
                          _buildActionButton(
                            label: 'Rechazar',
                            onPressed: () => _rechazarPedido(data['id']),
                            color: Colors.red,
                          ),
                        ],
                        _buildActionButton(
                          label: 'Ver detalle',
                          onPressed: () => _verDetalle(data['id']),
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButton(
      {required String label,
      required Function onPressed,
      required Color color}) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      child: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.hovered)) {
            return color.withOpacity(0.8); // Color con opacidad al hacer hover
          } else {
            return color;
          }
        }),
      ),
    );
  }
}
