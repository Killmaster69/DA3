// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyC0jUUwkIA1lBaJJ5UcO8fUmtlj4RuM7SM",
      authDomain: "fir-practice-dce1f.firebaseapp.com",
      projectId: "fir-practice-dce1f",
      storageBucket: "fir-practice-dce1f.appspot.com",
      messagingSenderId: "905286888335",
      appId: "1:905286888335:web:fa69ec0ff8ed54f222b9fa",
      measurementId: "G-45VMJRLPJZ",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro de Usuarios',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RegistroUsuario(),
    );
  }
}

class RegistroUsuario extends StatefulWidget {
  @override
  _RegistroUsuarioState createState() => _RegistroUsuarioState();
}

class _RegistroUsuarioState extends State<RegistroUsuario> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _preferenciasController = TextEditingController();
  final TextEditingController _filtroNombreController = TextEditingController();
  final TextEditingController _filtroEmailController = TextEditingController();
  final TextEditingController _filtroPreferenciasController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();

  void _enviarDatos() async {
    if (_formKey.currentState!.validate()) {
      await _firebaseService.agregarUsuario(
        _nombreController.text,
        _emailController.text,
        _preferenciasController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario agregado exitosamente')),
      );
      _nombreController.clear();
      _emailController.clear();
      _preferenciasController.clear();
    }
  }

  void _filtrarDatos() async {
    List<Map<String, dynamic>> usuarios = await _firebaseService.obtenerUsuarios(
      nombre: _filtroNombreController.text,
      email: _filtroEmailController.text,
      preferencias: _filtroPreferenciasController.text,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Resultados de la Búsqueda'),
          content: SingleChildScrollView(
            child: ListBody(
              children: usuarios.isNotEmpty
                  ? usuarios.map((usuario) {
                return Text(
                    'Nombre: ${usuario['nombre']}, Email: ${usuario['email']}, Preferencias: ${usuario['preferencias']}, Timestamp: ${usuario['timestamp']}');
              }).toList()
                  : [Text('No se encontraron usuarios con esos filtros.')],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Usuarios'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa un nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Correo Electrónico'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa un correo electrónico';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Por favor, ingresa un correo electrónico válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _preferenciasController,
                decoration: InputDecoration(labelText: 'Preferencias'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa tus preferencias';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _enviarDatos,
                child: Text('Registrar'),
              ),
              Divider(),
              TextField(
                controller: _filtroNombreController,
                decoration: InputDecoration(labelText: 'Filtrar por Nombre'),
              ),
              TextField(
                controller: _filtroEmailController,
                decoration: InputDecoration(labelText: 'Filtrar por Email'),
              ),
              TextField(
                controller: _filtroPreferenciasController,
                decoration: InputDecoration(labelText: 'Filtrar por Preferencias'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _filtrarDatos,
                child: Text('Filtrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
