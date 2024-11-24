import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'layout.dart';
import 'detalle_compra.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Compras',
      color: Colors.pink[100],
      home: Compra(title: 'Lista de Comrpas'),
    );
  }
}

class Compra extends StatefulWidget {
  const Compra({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Compra> {
  List<dynamic> _data = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:8000/api/compra'));

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

  Future<void> _anularCompra(int id) async {
    final response = await http.delete(
      Uri.parse('http://10.0.2.2:8000/api/compra/anular/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Compra anulada con éxito'),
      ),
    );
  }



   void _verDetalle(int id) {
     Navigator.push(
       context,
       MaterialPageRoute(
         builder: (context) => DetalleCompra(id: id),
       ),
     );
  }

  @override
Widget build(BuildContext context) {
  return CommonScaffold(
    title: widget.title,
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Control de Compras',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.pink[800],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ElevatedButton(
            onPressed: () {
              // Lógica para agregar una nueva compra
              print('Agregar compra');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            ),
            child: Text(
              'Agregar',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: _data.length,
            itemBuilder: (BuildContext context, int index) {
              final data = _data[index];
              DateTime fechaCompra = DateTime.parse(data['created_at']);
              String formattedDate =
                  DateFormat('dd/MM/yy').format(fechaCompra);

                return GestureDetector(
                  onTap: () => _verDetalle(data[
                      'id']),
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
                              'Compra ID: ${data['id']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'Proveedor: ${data['id_proveedor']}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Total: ${data['costo_total']}'),
                        const SizedBox(height: 8),
                        Text('Fecha Compra: $formattedDate'),
                        const SizedBox(height: 8),
                        Text('Estado: ${data['estado']}'),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            _buildActionButton(
                            label: 'Ver detalle',
                            onPressed: () => _verDetalle(data['id']),
                            color: Colors.blue,
                          ),
                           _buildActionButton(
                              label: 'Anular',
                              onPressed: () => _anularCompra(data['id']),
                              color: Color.fromARGB(255, 250, 28, 28),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
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
