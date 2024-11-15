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
      final response = await http.get(Uri.parse('http://localhost:8000/api/pedido'));

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


Future<void> _aceptarPedido(int id) async {
    try {
      final csrfResponse = await http.get(
        Uri.parse('https://prueba-floristeria-production.up.railway.app/api/csrf-token'),
      );

      if (csrfResponse.statusCode == 200) {
        final csrfToken = json.decode(csrfResponse.body)['csrf_token'];

        final response = await http.post(
          Uri.parse('https://prueba-floristeria-production.up.railway.app/api/pedido/aceptar/$id'),
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-TOKEN': csrfToken,
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          print('Estado del pedido actualizado: ${data['pedido']['estado']}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Pedido aceptado')),
          );
          _fetchData();
        } else {
          print('Error al actualizar el estado del pedido. Código de estado: ${response.statusCode}');
          print('Respuesta del servidor: ${response.body}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al actualizar el estado del pedido: ${response.body}')),
          );
        }
      } else {
        print('Error al obtener el token CSRF. Código de estado: ${csrfResponse.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al obtener el token CSRF: ${csrfResponse.statusCode}')),
        );
      }
    } catch (error) {
      print("Error al aceptar pedido: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al aceptar pedido: $error")),
      );
    }
  }

Future<void> _rechazarPedido(int id) async {
  try {
    final csrfResponse = await http.get(
      Uri.parse('https://prueba-floristeria-production.up.railway.app/api/csrf-token'),
    );

    if (csrfResponse.statusCode == 200) {
      final csrfToken = json.decode(csrfResponse.body)['csrf_token'];
      print('Token CSRF obtenido: $csrfToken'); // Logging del token CSRF

      final response = await http.delete(
        Uri.parse('https://prueba-floristeria-production.up.railway.app/api/pedido/rechazar/$id'),
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-TOKEN': csrfToken,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Estado del pedido actualizado: ${data['message']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pedido rechazado y eliminado correctamente')),
        );
        _fetchData();
      } else {
        print('Error al actualizar el estado del pedido. Código de estado: ${response.statusCode}');
        print('Respuesta del servidor: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el estado del pedido: ${response.body}')),
        );
      }
    } else {
      print('Error al obtener el token CSRF. Código de estado: ${csrfResponse.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al obtener el token CSRF: ${csrfResponse.statusCode}')),
      );
    }
  } catch (error) {
    print("Error al aceptar pedido: $error");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error al aceptar pedido: $error")),
    );
  }
}


  void _verDetalle(int id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetallePedido(pedidoId: id),
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
          onTap: () => _verDetalle(data['id']), // Navegar al detalle al hacer tap en cualquier parte del card
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
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                      _buildActionButton(
                        label: 'Aceptar',
                        onPressed: () => _aceptarPedido(data['id']),
                        color: Colors.green,
                      ),
                      _buildActionButton(
                        label: 'Rechazar',
                        onPressed: () => _rechazarPedido(data['id']),
                        color: Colors.red,
                      ),
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

Widget _buildActionButton({required String label, required Function onPressed, required Color color}) {
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