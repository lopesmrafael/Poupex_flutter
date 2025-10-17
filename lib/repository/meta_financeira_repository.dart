import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Model/meta_financeira.dart';

class MetaFinanceiraRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId => _auth.currentUser?.uid ?? '';

  Future<String> criar(CriarMetaFinanceiraDto dto) async {
    try {
      DocumentReference docRef = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('metas_financeiras')
          .add({
        'titulo': dto.titulo,
        'descricao': dto.descricao,
        'valorAlvo': dto.valorAlvo,
        'valorAtual': dto.valorInicial,
        'categoria': dto.categoria.value,
        'dataInicio': Timestamp.fromDate(dto.dataInicio),
        'dataLimite': Timestamp.fromDate(dto.dataLimite),
        'status': StatusMeta.ativa.value,
        'dataCriacao': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      throw Exception('Erro ao criar meta: $e');
    }
  }

  Future<MetaFinanceira?> buscarPorId(String id) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('metas_financeiras')
          .doc(id)
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return _fromFirestore(data, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao buscar meta: $e');
    }
  }

  Stream<QuerySnapshot> listarTodasStream() {
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('metas_financeiras')
        .orderBy('dataCriacao', descending: true)
        .snapshots();
  }

  MetaFinanceira _fromFirestore(Map<String, dynamic> data, String id) {
    return MetaFinanceira(
      id: id,
      titulo: data['titulo'] ?? '',
      descricao: data['descricao'],
      valorAlvo: (data['valorAlvo'] ?? 0).toDouble(),
      valorAtual: (data['valorAtual'] ?? 0).toDouble(),
      dataInicio: (data['dataInicio'] as Timestamp).toDate(),
      dataLimite: (data['dataLimite'] as Timestamp).toDate(),
      status: StatusMeta.fromString(data['status'] ?? 'ativa'),
      categoria: CategoriaMeta.fromString(data['categoria'] ?? 'outros'),
      dataAtualizacao: data['dataAtualizacao'] != null 
          ? (data['dataAtualizacao'] as Timestamp).toDate() 
          : null,
      dataCriacao: (data['dataCriacao'] as Timestamp).toDate(),
    );
  }

  Future<void> atualizar(String id, Map<String, dynamic> dados) async {
    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('metas_financeiras')
          .doc(id)
          .update(dados);
    } catch (e) {
      throw Exception('Erro ao atualizar meta: $e');
    }
  }

  Future<void> deletar(String id) async {
    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('metas_financeiras')
          .doc(id)
          .delete();
    } catch (e) {
      throw Exception('Erro ao deletar meta: $e');
    }
  }

  Future<void> atualizarProgresso(String id, double novoValor) async {
    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('metas_financeiras')
          .doc(id)
          .update({
        'valorAtual': novoValor,
        'dataAtualizacao': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Erro ao atualizar progresso: $e');
    }
  }

  Stream<QuerySnapshot> buscarPorStatus(String status) {
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('metas_financeiras')
        .where('status', isEqualTo: status)
        .snapshots();
  }
}