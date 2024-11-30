import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'compra.dart';

class CompraScreen extends StatefulWidget {
  @override
  _CompraScreenState createState() => _CompraScreenState();
}

class _CompraScreenState extends State<CompraScreen> {
  List<Map<String, dynamic>> proveedores = [];
  List<Map<String, dynamic>> categorias = [];
  List<Map<String, dynamic>> insumos = [];

  String? proveedorSeleccionado;
  String? categoriaSeleccionada;
  String? insumoSeleccionado;
  int cantidad = 0;

  @override
  void initState() {
    super.initState();
    _obtenerProveedores();
    _obtenerCategorias();
  }

  // Obtener proveedores
  Future<void> _obtenerProveedores() async {
    final response = await http.get(Uri.parse('http://localhost:8000/api/proveedor'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        proveedores = data
            .map((prov) => {'id': prov['id'].toString(), 'nombre': prov['nombre']})
            .toList();
      });
    } else {
      throw Exception('Error al cargar proveedores');
    }
  }

  // Obtener categorías
  Future<void> _obtenerCategorias() async {
    final response = await http.get(Uri.parse('http://localhost:8000/api/categoria'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        categorias = data
            .map((cat) => {'id': cat['id'].toString(), 'nombre': cat['nombre']})
            .toList();
      });
    } else {
      throw Exception('Error al cargar categorias');
    }
  }

  // Obtener insumos por categoría
  Future<void> _obtenerInsumos(String categoriaId) async {
    final response = await http.get(Uri.parse('http://localhost:8000/api/insumo/$categoriaId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      print(data); // Verifica los datos que estás recibiendo
      setState(() {
        insumos = data
            .map((insumo) => {
              'id': insumo['id'].toString(),
              'nombre': insumo['nombre'],
              'color': insumo['color'],
              'costo_unitario': insumo['costo_unitario']
            })
            .toList();
      });
    } else {
      throw Exception('Error al cargar insumos');
    }
  }

  // Validar y agregar producto
  void _agregarProducto() async {
    if (proveedorSeleccionado == null ||
        categoriaSeleccionada == null ||
        insumoSeleccionado == null ||
        cantidad <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor complete todos los campos")),
      );
      return; // Salir si no se completan todos los campos
    }

    // Calcular el costo total (sumando los subtotales de todos los productos)
    double costoTotal = 0.0;
    List<Map<String, dynamic>> detalles = [];

    for (var insumo in insumos) {
      if (insumo['id'] == insumoSeleccionado) {
        double costoUnitario = double.tryParse(insumo['costo_unitario'].toString()) ?? 0.0;
        double subtotal = costoUnitario * cantidad;
        costoTotal += subtotal;

        detalles.add({
          'id_categoria_insumo': categoriaSeleccionada,
          'id_insumo': insumo['id'],
          'cantidad': cantidad,
          'costo_unitario': costoUnitario,
          'subtotal': subtotal,
          'total': subtotal, // Aquí el total es igual al subtotal
        });
      }
    }

    // Crear el cuerpo de la solicitud
    Map<String, dynamic> compraData = {
      'id_proveedor': proveedorSeleccionado,
      'detalles': detalles,
      'costo_total': costoTotal,
      'estado': 'Activa', // Puedes poner un estado predeterminado o permitir que el usuario lo elija
    };
    final response = await http.post(
      Uri.parse('http://localhost:8000/api/comprar'),  // Asegúrate de que la URL sea correcta
      headers: {'Content-Type': 'application/json'},
      body: json.encode(compraData),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Compra realizada con éxito")),
    );
    // Redirigir a otra pantalla después de la compra exitosa
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Compra(title: 'Compras',)),  // Aquí puedes reemplazar "OtroPantalla" por la pantalla deseada
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agregar Compra"),
        backgroundColor: Color(0xFFB3C7D6),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Proveedor", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      proveedores.isEmpty
                          ? Text("Cargando proveedores...")  // Reemplazamos el CircularProgressIndicator
                          : DropdownButtonFormField<String>(
                              hint: Text("Seleccione un proveedor"),
                              value: proveedorSeleccionado,
                              items: proveedores
                                  .map((prov) => DropdownMenuItem<String>(
                                        value: prov['id'] as String,
                                        child: Text(prov['nombre']!),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  proveedorSeleccionado = value;
                                  categoriaSeleccionada = null;
                                  insumoSeleccionado = null;
                                });
                              },
                            ),
                      SizedBox(height: 16),
                      Text("Categoría", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      categorias.isEmpty
                          ? Text("Cargando categorías...")  // Reemplazamos el CircularProgressIndicator
                          : DropdownButtonFormField<String>(
                              hint: Text("Seleccione una categoría"),
                              value: categoriaSeleccionada,
                              items: categorias
                                  .map((cat) => DropdownMenuItem(
                                        value: cat['id'] as String,
                                        child: Text(cat['nombre']!),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  categoriaSeleccionada = value;
                                  insumoSeleccionado = null;
                                });
                                if (categoriaSeleccionada != null) {
                                  _obtenerInsumos(categoriaSeleccionada!);
                                }
                              },
                            ),
                      SizedBox(height: 16),
                      Text("Insumo", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      insumos.isEmpty
                          ? Text("Cargando insumos...")  // Reemplazamos el CircularProgressIndicator
                          : DropdownButtonFormField<String>(
                            hint: Text("Seleccione un insumo"),
                            value: insumoSeleccionado,
                            items: insumos.isEmpty
                                ? [DropdownMenuItem<String>(child: Text('No hay insumos disponibles'))]
                                : insumos
                                    .map((insumo) {
                                      // Concatenar el nombre del insumo con el color
                                      String nombreConColor = '${insumo['nombre']} - ${insumo['color']}';
                                      return DropdownMenuItem(
                                        value: insumo['id'] as String,
                                        child: Text(nombreConColor),
                                      );
                                    })
                                    .toList(),
                            onChanged: (value) {
                              setState(() {
                                insumoSeleccionado = value;
                              });
                            },
                          ),
                      SizedBox(height: 16),
                      Text("Cantidad", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Ingrese cantidad",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            cantidad = int.tryParse(value) ?? 0;
                          });
                        },
                      ),
                      SizedBox(height: 16),
                      if (insumoSeleccionado != null)
                        Text(
                          'Costo Unitario: ' +
                              insumos.firstWhere((insumo) => insumo['id'] == insumoSeleccionado)['costo_unitario'].toString(),
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0), backgroundColor: Color(0xFF5B95FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _agregarProducto,
                child: Text("Comprar", style: TextStyle(fontSize: 18, color: Colors.white,)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
