import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RewardRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId => _auth.currentUser?.uid ?? '';

  Future<void> adicionarPontos(int pontos, String motivo) async {
    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('pontos')
          .add({
        'pontos': pontos,
        'motivo': motivo,
        'data': FieldValue.serverTimestamp(),
      });

      // Atualizar total de pontos do usuário
      DocumentReference userRef = _firestore.collection('users').doc(_userId);
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot userDoc = await transaction.get(userRef);
        int pontosAtuais = userDoc.data() != null 
            ? (userDoc.data() as Map<String, dynamic>)['totalPontos'] ?? 0 
            : 0;
        transaction.update(userRef, {'totalPontos': pontosAtuais + pontos});
      });
    } catch (e) {
      throw Exception('Erro ao adicionar pontos: $e');
    }
  }

  Future<int> getTotalPontos() async {
    try {
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(_userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        return data['totalPontos'] ?? 0;
      }
      return 0;
    } catch (e) {
      throw Exception('Erro ao buscar pontos: $e');
    }
  }

  Stream<QuerySnapshot> getHistoricoPontos() {
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('pontos')
        .orderBy('data', descending: true)
        .snapshots();
  }

  Future<void> resgatarRecompensa(String recompensaId, int pontosNecessarios) async {
    try {
      await _firestore.runTransaction((transaction) async {
        DocumentReference userRef = _firestore.collection('users').doc(_userId);
        DocumentSnapshot userDoc = await transaction.get(userRef);
        
        if (userDoc.exists) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
          int pontosAtuais = data['totalPontos'] ?? 0;
          
          if (pontosAtuais >= pontosNecessarios) {
            transaction.update(userRef, {
              'totalPontos': pontosAtuais - pontosNecessarios
            });
            
            // Registrar resgate
            transaction.set(
              _firestore
                  .collection('users')
                  .doc(_userId)
                  .collection('resgates')
                  .doc(),
              {
                'recompensaId': recompensaId,
                'pontosGastos': pontosNecessarios,
                'data': FieldValue.serverTimestamp(),
              }
            );
          } else {
            throw Exception('Pontos insuficientes');
          }
        }
      });
    } catch (e) {
      throw Exception('Erro ao resgatar recompensa: $e');
    }
  }

  Stream<QuerySnapshot> getResgates() {
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('resgates')
        .orderBy('data', descending: true)
        .snapshots();
  }
}