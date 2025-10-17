import 'data_manager.dart';

class MetaFinanceiraRepositorySimple {
  final DataManager _dataManager = DataManager();

  Future<void> criarMeta({
    required String titulo,
    required double valor,
    required String status,
  }) async {
    await _dataManager.addMeta({
      'titulo': titulo,
      'valor': valor,
      'status': status,
      'progresso': 0.0,
    });
  }

  Future<List<Map<String, dynamic>>> listarMetas() async {
    return await _dataManager.getMetas();
  }

  Future<void> deletarMeta(String id) async {
    await _dataManager.deleteMeta(id);
  }

  Future<void> atualizarProgresso(String id, double progresso) async {
    final metas = await _dataManager.getMetas();
    final metaIndex = metas.indexWhere((meta) => meta['id'] == id);
    
    if (metaIndex != -1) {
      metas[metaIndex]['progresso'] = progresso;
      metas[metaIndex]['updatedAt'] = DateTime.now().toIso8601String();
    }
  }
}