import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrcamentoRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId => _auth.currentUser?.uid ?? '';

  Future<void> salvarOrcamento({
    required double renda,
    required Map<String, double> categorias,
    required int mes,
    required int ano,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('orcamentos')
          .doc('$ano-$mes')
          .set({
        'renda': renda,
        'categorias': categorias,
        'mes': mes,
        'ano': ano,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Erro ao salvar orçamento: $e');
    }
  }

  Future<Map<String, dynamic>?> getOrcamento(int mes, int ano) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('orcamentos')
          .doc('$ano-$mes')
          .get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao buscar orçamento: $e');
    }
  }

  Stream<DocumentSnapshot> getOrcamentoStream(int mes, int ano) {
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('orcamentos')
        .doc('$ano-$mes')
        .snapshots();
  }

  Future<List<Map<String, dynamic>>> getHistoricoOrcamentos() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('orcamentos')
          .orderBy('ano', descending: true)
          .orderBy('mes', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Erro ao buscar histórico: $e');
    }
  }
}