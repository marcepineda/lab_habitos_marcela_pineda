
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _coleccion =>
      _db.collection('habitos_diarios');

  Future<void> guardarDia({
    required String fecha,
    required List<bool> cumplidos,
    required int meta,
    required bool enfoque,
    required String nota,
  }) async {
    await _coleccion.doc(fecha).set({
      'fecha': fecha,
      'cumplidos': cumplidos,
      'meta': meta,
      'enfoque': enfoque,
      'nota': nota,
      'actualizado': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> cargarDia(String fecha) async {
    final documento = await _coleccion.doc(fecha).get();

    if (!documento.exists) {
      return null;
    }

    return documento.data();
  }

  Future<List<Map<String, dynamic>>> obtenerHistorial() async {
    final resultado = await _coleccion
        .orderBy('fecha', descending: true)
        .get();

    return resultado.docs.map((doc) => doc.data()).toList();
  }
}
