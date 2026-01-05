import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PredictionService {
  static final PredictionService instance = PredictionService._();
  PredictionService._();

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Guardar una predicción
  Future<void> savePrediction({
    required String matchId,
    required int team1Score,
    required int team2Score,
  }) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('Usuario no autenticado');

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('predictions')
          .doc(matchId)
          .set({
        'matchId': matchId,
        'team1Score': team1Score,
        'team2Score': team2Score,
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      throw Exception('Error al guardar predicción: $e');
    }
  }

  // Obtener todas las predicciones del usuario
  Future<Map<String, Map<String, dynamic>>> getUserPredictions() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('Usuario no autenticado');

      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('predictions')
          .get();

      final predictions = <String, Map<String, dynamic>>{};
      for (var doc in snapshot.docs) {
        predictions[doc.id] = doc.data();
      }
      return predictions;
    } catch (e) {
      throw Exception('Error al cargar predicciones: $e');
    }
  }

  // Obtener predicciones en tiempo real (stream)
  Stream<Map<String, Map<String, dynamic>>> getUserPredictionsStream() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.value({});
    }

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('predictions')
        .snapshots()
        .map((snapshot) {
      final predictions = <String, Map<String, dynamic>>{};
      for (var doc in snapshot.docs) {
        predictions[doc.id] = doc.data();
      }
      return predictions;
    });
  }

  // Eliminar una predicción
  Future<void> deletePrediction(String matchId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('Usuario no autenticado');

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('predictions')
          .doc(matchId)
          .delete();
    } catch (e) {
      throw Exception('Error al eliminar predicción: $e');
    }
  }
}
