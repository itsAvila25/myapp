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
  List<Map<String, dynamic>> carrito = []; // Carrito de compras

  String? proveedorSeleccionado;
  String? categoriaSeleccionada;
  String? insumoSeleccionado;
  int cantidad = 0;

  double costoTotal = 0.0;

  @override
  void initState() {
    super.initState();
    _obtenerProveedores();
    _obtenerCategorias();
  }

  Future<void> _obtenerProveedores() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/proveedor'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        proveedores = data
            .map((prov) => {'id': prov['id'].toString(), 'nombre': prov['nombre']})
            .toList();
      });
    }
  }

  Future<void> _obtenerCategorias() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/categoria'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        categorias = data
            .map((cat) => {'id': cat['id'].toString(), 'nombre': cat['nombre']})
            .toList();
      });
    }
  }

  Future<void> _obtenerInsumos(String categoriaId) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/insumo/$categoriaId'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
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
    }
  }

 void _agregarAlCarrito() {
  if (proveedorSeleccionado == null ||
      categoriaSeleccionada == null ||
      insumoSeleccionado == null ||
      cantidad <= 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Por favor complete todos los campos")),
    );
    return;
  }

  final insumo = insumos.firstWhere((ins) => ins['id'] == insumoSeleccionado);
  double costoUnitario = double.tryParse(insumo['costo_unitario'].toString()) ?? 0.0;
  double subtotal = costoUnitario * cantidad;
  double total = subtotal; // El total por ítem será igual al subtotal por ahora.

  setState(() {
    carrito.add({
      'id_categoria_insumo': categoriaSeleccionada,
      'id_insumo': insumo['id'],
      'nombre': insumo['nombre'],
      'cantidad': cantidad,
      'costo_unitario': costoUnitario,
      'subtotal': subtotal,
      'total': total,
    });
    costoTotal += subtotal;
    cantidad = 0;
    insumoSeleccionado = null;
  });
}


  void _eliminarDelCarrito(int index) {
    setState(() {
      costoTotal -= carrito[index]['subtotal'];
      carrito.removeAt(index);
    });
  }

  Future<void> _finalizarCompra() async {
  if (carrito.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("El carrito está vacío")),
    );
    return;
  }

  // Convertimos el carrito a un JSON string
  String carritoJson = json.encode(carrito);

  Map<String, dynamic> compraData = {
    'id_proveedor': proveedorSeleccionado,
    'carrito': carritoJson, // Enviamos el carrito como un string JSON
    'costo_total': costoTotal,
    'estado': 'Activa', // Estado predeterminado
  };

  print(compraData);  // Verificar los datos enviados

  final response = await http.post(
  Uri.parse('http://10.0.2.2:8000/api/compras'),
  headers: {'Content-Type': 'application/json'},
  body: json.encode(compraData),
);

print('Respuesta: ${response.statusCode}');
print('Cuerpo: ${response.body}');  // Imprime la respuesta completa

if (response.statusCode == 200) {
  var data = json.decode(response.body);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Compra realizada con éxito. ID: ${data['compra_id']}")),
  );
  setState(() {
    carrito.clear();
    costoTotal = 0.0;
  });
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => Compra(title: 'Compras')),
  );
} else {
  var errorData = json.decode(response.body);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Hubo un error: ${errorData['error']}")),
  );
}


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
              Text("Proveedor", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              proveedores.isEmpty
                  ? Text("Cargando proveedores...") 
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
                  ? Text("Cargando categorías...")
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
                  ? Text("Cargando insumos...")
                  : DropdownButtonFormField<String>(
                      hint: Text("Seleccione un insumo"),
                      value: insumoSeleccionado,
                      items: insumos.isEmpty
                          ? [DropdownMenuItem<String>(child: Text('No hay insumos disponibles'))]
                          : insumos
                              .map((insumo) {
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
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _agregarAlCarrito,
                child: Text("Agregar al Carrito"),
              ),
              SizedBox(height: 16),
              Text("Carrito de Compras", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ListView.builder(
                shrinkWrap: true,
                itemCount: carrito.length,
                itemBuilder: (context, index) {
                  final item = carrito[index];
                  return ListTile(
                    title: Text('${item['nombre']} - ${item['cantidad']} x ${item['costo_unitario']}'),
                    subtitle: Text('Subtotal: ${item['subtotal']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _eliminarDelCarrito(index),
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              Text('Costo Total: \$${costoTotal.toStringAsFixed(2)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _finalizarCompra,
                child: Text("Finalizar Compra"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
