import 'data_manager.dart';

class MovimentacaoRepository {
  final DataManager _dataManager = DataManager();

  Future<void> addMovimentacao({
    required String descricao,
    required double valor,
    required String tipo,
    required DateTime data,
    String? categoria,
  }) async {
    await _dataManager.addMovimentacao({
      'descricao': descricao,
      'valor': valor,
      'tipo': tipo,
      'data': data.toIso8601String(),
      'categoria': categoria ?? 'Geral',
    });
  }

  Future<List<Map<String, dynamic>>> getMovimentacoes() async {
    return await _dataManager.getMovimentacoes();
  }

  Future<void> deleteMovimentacao(String id) async {
    await _dataManager.deleteMovimentacao(id);
  }

  Future<Map<String, double>> getResumoFinanceiro() async {
    final stats = await _dataManager.getEstatisticas();
    return {
      'receitas': stats['totalReceitas']?.toDouble() ?? 0.0,
      'despesas': stats['totalDespesas']?.toDouble() ?? 0.0,
      'saldo': stats['saldo']?.toDouble() ?? 0.0,
    };
  }
}