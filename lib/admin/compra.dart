import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'layout.dart';
import 'add_compra.dart';
import 'detalle_compra.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Compras',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.pink[50],
      ),
      home: Compra(title: 'Lista de Compras'),
    );
  }
}

class Compra extends StatefulWidget {
  const Compra({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _CompraState createState() => _CompraState();
}

class _CompraState extends State<Compra> {
  List<dynamic> _data = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:8000/api/compra'));

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
      Uri.parse('http://localhost:8000/api/compra/anular/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Compra anulada con éxito'),
      ),
    );
    _fetchData(); // Refresca la lista después de anular la compra
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Control de Compras',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 0, 0, 0), // Color de título ajustado
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CompraScreen(),
                  ),
                );
                if (result == true) {
                  _fetchData(); // Refresca la lista después de agregar una compra.
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF5B95FF), // Ajustado al tono de rosa
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
              child: Text(
                'Agregar Compra',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Número de columnas
                crossAxisSpacing: 16.0, // Espacio entre las columnas
                mainAxisSpacing: 16.0, // Espacio entre las filas
                childAspectRatio: 1.2, // Ajusta el aspecto de las tarjetas
              ),
              itemCount: _data.length,
              itemBuilder: (BuildContext context, int index) {
                final data = _data[index];
                DateTime fechaCompra = DateTime.parse(data['created_at']);
                String formattedDate =
                    DateFormat('dd/MM/yy').format(fechaCompra);

                return Card(
                  color: Color(0xFFF7C5A8), // Color de las tarjetas ajustado
                  elevation: 3,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center, // Centra los textos
                      crossAxisAlignment: CrossAxisAlignment.center, // Alineación central
                      children: [
                        Text(
                          'Compra #${data['id']}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          textAlign: TextAlign.center, // Centra el texto
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Fecha: $formattedDate',
                          style: TextStyle(fontSize: 14),
                          textAlign: TextAlign.center, // Centra el texto
                        ),
                        Text(
                          'Proveedor: ${data['proveedor_nombre']}',
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                          textAlign: TextAlign.center, // Centra el texto
                        ),
                        Text(
                          'Total: \$${data['costo_total']}',
                          style: TextStyle(fontSize: 14),
                          textAlign: TextAlign.center, // Centra el texto
                        ),
                        Text(
                          'Estado: ${data['estado']}',
                          style: TextStyle(fontSize: 14),
                          textAlign: TextAlign.center, // Centra el texto
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center, // Centra los botones
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                  color: Colors.blue, // Borde azul
                                  width: 1,
                                ),
                              ),
                              child: IconButton(
                                onPressed: () => _verDetalle(data['id']),
                                icon: Icon(
                                  Icons.remove_red_eye,
                                  color: Color.fromARGB(255, 76, 169, 255),
                                  size: 30,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.red[50],
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                  color: Colors.red, // Borde rojo
                                  width: 1,
                                ),
                              ),
                              child: IconButton(
                                onPressed: () => _anularCompra(data['id']),
                                icon: Icon(
                                  Icons.cancel,
                                  color: const Color.fromARGB(255, 253, 76, 73),
                                  size: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
}
