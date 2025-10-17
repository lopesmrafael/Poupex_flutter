import 'data_manager.dart';

class OrcamentoRepositorySimple {
  final DataManager _dataManager = DataManager();

  Future<void> salvarOrcamento({
    required List<Map<String, dynamic>> rendas,
    required List<Map<String, dynamic>> gastosFixos,
    required List<Map<String, dynamic>> gastosVariaveis,
  }) async {
    await _dataManager.salvarOrcamento({
      'rendas': rendas,
      'gastosFixos': gastosFixos,
      'gastosVariaveis': gastosVariaveis,
      'mes': DateTime.now().month,
      'ano': DateTime.now().year,
    });
  }

  Future<Map<String, dynamic>?> getOrcamentoAtual() async {
    return await _dataManager.getOrcamentoAtual();
  }

  Future<double> getTotalRendas() async {
    final orcamento = await getOrcamentoAtual();
    if (orcamento == null) return 0.0;
    
    List<Map<String, dynamic>> rendas = List<Map<String, dynamic>>.from(orcamento['rendas'] ?? []);
    return rendas.fold<double>(0.0, (sum, item) => sum + (item['valor']?.toDouble() ?? 0.0));
  }

  Future<double> getTotalGastos() async {
    final orcamento = await getOrcamentoAtual();
    if (orcamento == null) return 0.0;
    
    List<Map<String, dynamic>> fixos = List<Map<String, dynamic>>.from(orcamento['gastosFixos'] ?? []);
    List<Map<String, dynamic>> variaveis = List<Map<String, dynamic>>.from(orcamento['gastosVariaveis'] ?? []);
    
    double totalFixos = fixos.fold<double>(0.0, (sum, item) => sum + (item['valor']?.toDouble() ?? 0.0));
    double totalVariaveis = variaveis.fold<double>(0.0, (sum, item) => sum + (item['valor']?.toDouble() ?? 0.0));
    
    return totalFixos + totalVariaveis;
  }
}