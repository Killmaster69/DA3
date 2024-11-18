// lib/firebase_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final CollectionReference usuarios =
  FirebaseFirestore.instance.collection('Usuarios');

  Future<void> agregarUsuario(
      String nombre, String email, String preferencias) async {
    final startTime = DateTime.now(); // Tiempo de inicio
    try {
      await usuarios.add({
        'nombre': nombre,
        'email': email,
        'preferencias': preferencias,
        'timestamp': FieldValue.serverTimestamp(),
      });
      final endTime = DateTime.now(); // Tiempo de fin
      print('Tiempo de respuesta (agregar usuario): ${endTime.difference(startTime).inMilliseconds} ms');
    } catch (e) {
      print('Error al agregar usuario: $e');
    }
  }

  Future<List<Map<String, dynamic>>> obtenerUsuarios({
    String? nombre,
    String? email,
    String? preferencias,
  }) async {
    final startTime = DateTime.now(); // Tiempo de inicio
    Query query = usuarios;

    if (nombre != null && nombre.isNotEmpty) {
      query = query.where('nombre', isEqualTo: nombre);
    }
    if (email != null && email.isNotEmpty) {
      query = query.where('email', isEqualTo: email);
    }
    if (preferencias != null && preferencias.isNotEmpty) {
      query = query.where('preferencias', isEqualTo: preferencias);
    }

    try {
      QuerySnapshot snapshot = await query.get();
      final endTime = DateTime.now(); // Tiempo de fin
      print('Tiempo de respuesta (obtener usuarios): ${endTime.difference(startTime).inMilliseconds} ms');
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    } catch (e) {
      print('Error al obtener usuarios: $e');
      return [];
    }
  }
}
