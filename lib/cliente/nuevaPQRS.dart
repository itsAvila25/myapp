import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'layout.dart';
import 'misPQRS.dart';

class nuevaPQRS extends StatefulWidget {
  const nuevaPQRS({Key? key}) : super(key: key);

  @override
  _nuevaPQRSState createState() => _nuevaPQRSState();
}

class _nuevaPQRSState extends State<nuevaPQRS> {
  final TextEditingController _descripcionController = TextEditingController();
  String _tipoValue = 'Seleccione el tipo';
  String? _motivoValue;

  final Map<String, List<String>> motivosPorTipo = {
    'Petición': ['Solicitud de información', 'Solicitud de servicio', 'Otras'],
    'Queja': ['Mala atención', 'Falta de calidad', 'Otras'],
    'Reclamo': ['Producto defectuoso', 'Falta de reembolso', 'Otras'],
    'Sugerencia': ['Mejora de servicio', 'Innovación', 'Otras'],
  };

  void _enviarPQRS(BuildContext context) async {
    String? motivo = _motivoValue;
    String descripcion = _descripcionController.text;

    if (_tipoValue != 'Seleccione el tipo' &&
        motivo != null &&
        descripcion.isNotEmpty) {
      // Guardar la PQRS en Firestore
      DocumentReference documentReference =
          await FirebaseFirestore.instance.collection('pqrs').add({
        'tipo': _tipoValue,
        'motivo': motivo,
        'descripcion': descripcion,
        'estado': 'Enviado', // Estado inicial
        'fecha_envio': DateTime.now(), // Fecha de envío actual
      });

      // Obtener el ID generado por Firestore
      String pqrsId = documentReference.id;

      // Actualizar el documento para incluir el ID
      await documentReference.update({'id': pqrsId});

      // Enviar correo electrónico
      String username = 'avilasamuel0109@gmail.com'; // Cambiar por tu correo
      String password = 'rgyr lvcg vbzu mozz'; // Cambiar por tu contraseña

      final smtpServer = gmail(username, password);

      final message = Message()
        ..from = Address(username, 'Tu Nombre')
        ..recipients
            .add('avilasamuel0109@gmail.com') // Cambiar por el destinatario
        ..subject = 'Nueva PQRS: $pqrsId'
        ..text = 'Se ha enviado una nueva PQRS:\n\n'
            'Tipo: $_tipoValue\n'
            'Motivo: $motivo\n'
            'Descripción: $descripcion\n'
            'Fecha de Envío: ${_formatTimestamp(DateTime.now())}';

      try {
        final sendReport = await send(message, smtpServer);
        print('Message sent: ' + sendReport.toString());

        // Mostrar un diálogo de confirmación
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("PQRS enviada"),
              content: Text(
                  "Tu PQRS ha sido enviada correctamente y se ha notificado por correo electrónico."),
              actions: <Widget>[
                TextButton(
                  child: const Text('Aceptar'),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MisPQRS(
                                title: 'mis PQRS',
                              )),
                    );
                  },
                ),
              ],
            );
          },
        );
      } catch (e) {
        print('Message not sent: $e');
        // Manejar errores al enviar el correo
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content:
                  Text("Hubo un problema al enviar el correo electrónico: $e"),
              actions: <Widget>[
                TextButton(
                  child: const Text('Aceptar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      // Mostrar un mensaje de error si no se completan todos los campos
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("Por favor completa todos los campos."),
            actions: <Widget>[
              TextButton(
                child: const Text('Aceptar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute}:${timestamp.second}';
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: 'Nueva PQRS',
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 40, left: 30, right: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.network(
                  'https://floristerialatata.com/wp-content/uploads/2020/02/cropped-latata2-5-337x138.png'),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: const Text(
                  'PQRS',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text('¡Hola!, escribe aquí tu PQRS'),
              ),
              Form(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          hintText: 'Tipo',
                          hintStyle: TextStyle(fontWeight: FontWeight.w600),
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                        ),
                        value: _tipoValue,
                        items: <String>[
                          'Seleccione el tipo',
                          'Petición',
                          'Queja',
                          'Reclamo',
                          'Sugerencia'
                        ].map<DropdownMenuItem<String>>(
                          (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          },
                        ).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _tipoValue = newValue!;
                            _motivoValue = null; // Reset motivo value
                          });
                        },
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value == 'Seleccione el tipo') {
                            return 'Por favor seleccione el tipo';
                          }
                          return null;
                        },
                      ),
                    ),
                    if (_tipoValue != 'Seleccione el tipo')
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            hintText: 'Motivo',
                            hintStyle: TextStyle(fontWeight: FontWeight.w600),
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                          ),
                          value: _motivoValue,
                          items: motivosPorTipo[_tipoValue]!
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _motivoValue = newValue!;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor seleccione el motivo';
                            }
                            return null;
                          },
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: TextFormField(
                        controller: _descripcionController,
                        decoration: const InputDecoration(
                          hintText: 'Descripción',
                          hintStyle: TextStyle(fontWeight: FontWeight.w600),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese la descripción';
                          }
                          return null;
                        },
                        maxLines: 5,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: ElevatedButton(
                        onPressed: () {
                          _enviarPQRS(context);
                        },
                        child: const Text('Enviar PQRS'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
