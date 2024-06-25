import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'misPQRS.dart';
import 'layout.dart'; // Asegúrate de importar el archivo de layout.dart

class NuevaPQRS extends StatelessWidget {
  const NuevaPQRS({Key? key}) : super(key: key);

  // Función para formatear el timestamp a un string legible
  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute}:${timestamp.second}';
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _motivoController = TextEditingController();
    final TextEditingController _descripcionController = TextEditingController();
    String _tipoValue = 'Seleccione el tipo'; // Valor inicial del Dropdown

    void _enviarPQRS(BuildContext context) async {
      String motivo = _motivoController.text;
      String descripcion = _descripcionController.text;

      if (_tipoValue != 'Seleccione el tipo' && motivo.isNotEmpty && descripcion.isNotEmpty) {
        // Guardar la PQRS en Firestore
        DocumentReference documentReference = await FirebaseFirestore.instance.collection('pqrs').add({
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
        String username = 'pradodeymar@gmail.com'; // Cambiar por tu correo
        String password = 'nmxw jurm pgwr wsxb'; // Cambiar por tu contraseña

        final smtpServer = gmail(username, password);

        final message = Message()
          ..from = Address(username, 'Tu Nombre')
          ..recipients.add('pradodeymar@gmail.com') // Cambiar por el destinatario
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
                content: Text("Tu PQRS ha sido enviada correctamente y se ha notificado por correo electrónico."),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Aceptar'),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MisPQRS(title: 'Mis PQRS')), // Ajusta el título según corresponda
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
                content: const Text("Hubo un problema al enviar el correo electrónico."),
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
                title: const Text("PQRS enviada"),
                content: Text("Tu PQRS ha sido enviada correctamente y se ha notificado por correo electrónico."),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Aceptar'),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MisPQRS(title: "Mis Pqrs",)),
                      );
                    },
                  ),
                ],
              );
          },
        );
      }
    }

    return Layout(
      title: 'Nueva PQRS',
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 40, left: 30, right: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.network('https://floristerialatata.com/wp-content/uploads/2020/02/cropped-latata2-5-337x138.png'),
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
                          if (newValue != null) {
                            _tipoValue = newValue;
                          }
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
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: TextFormField(
                        controller: _motivoController,
                        decoration: const InputDecoration(
                          hintText: 'Motivo',
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
                            return 'Por favor ingrese el motivo';
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
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () => _enviarPQRS(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('ENVIAR PQRS'),
                        ),
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
