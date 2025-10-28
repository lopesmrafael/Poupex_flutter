import 'auth_repository.dart';

class DataManager {
  static final DataManager _instance = DataManager._internal();
  factory DataManager() => _instance;
  DataManager._internal();

  final AuthRepository _auth = AuthRepository();
  
  // Storage centralizado
  static Map<String, List<Map<String, dynamic>>> _movimentacoes = {};
  static Map<String, List<Map<String, dynamic>>> _metas = {};
  static Map<String, Map<String, dynamic>> _orcamentos = {};
  static Map<String, List<Map<String, dynamic>>> _eventos = {};
  static Map<String, int> _pontos = {};

  String get _userId => _auth.getCurrentUserId()?.toString() ?? '';

  // Movimentações
  Future<void> addMovimentacao(Map<String, dynamic> movimentacao) async {
    if (!_auth.isLoggedIn()) throw Exception('Usuário não logado');
    
    await Future.delayed(Duration(milliseconds: 200));
    
    movimentacao['id'] = DateTime.now().millisecondsSinceEpoch.toString();
    movimentacao['userId'] = _userId;
    movimentacao['createdAt'] = DateTime.now().toIso8601String();
    
    _movimentacoes[_userId] ??= [];
    _movimentacoes[_userId]!.add(movimentacao);
  }

  Future<List<Map<String, dynamic>>> getMovimentacoes() async {
    if (!_auth.isLoggedIn()) return [];
    
    await Future.delayed(Duration(milliseconds: 100));
    
    return List.from(_movimentacoes[_userId] ?? [])
      ..sort((a, b) => DateTime.parse(b['createdAt']).compareTo(DateTime.parse(a['createdAt'])));
  }

  Future<void> deleteMovimentacao(String id) async {
    await Future.delayed(Duration(milliseconds: 100));
    _movimentacoes[_userId]?.removeWhere((mov) => mov['id'] == id);
  }

  // Metas
  Future<void> addMeta(Map<String, dynamic> meta) async {
    if (!_auth.isLoggedIn()) throw Exception('Usuário não logado');
    
    await Future.delayed(Duration(milliseconds: 200));
    
    meta['id'] = DateTime.now().millisecondsSinceEpoch.toString();
    meta['userId'] = _userId;
    meta['createdAt'] = DateTime.now().toIso8601String();
    
    _metas[_userId] ??= [];
    _metas[_userId]!.add(meta);
  }

  Future<List<Map<String, dynamic>>> getMetas() async {
    if (!_auth.isLoggedIn()) return [];
    
    await Future.delayed(Duration(milliseconds: 100));
    
    return List.from(_metas[_userId] ?? [])
      ..sort((a, b) => DateTime.parse(b['createdAt']).compareTo(DateTime.parse(a['createdAt'])));
  }

  Future<void> deleteMeta(String id) async {
    await Future.delayed(Duration(milliseconds: 100));
    _metas[_userId]?.removeWhere((meta) => meta['id'] == id);
  }

  // Orçamento
  Future<void> salvarOrcamento(Map<String, dynamic> orcamento) async {
    if (!_auth.isLoggedIn()) throw Exception('Usuário não logado');
    
    await Future.delayed(Duration(milliseconds: 200));
    
    String key = '${_userId}_${DateTime.now().month}_${DateTime.now().year}';
    orcamento['userId'] = _userId;
    orcamento['updatedAt'] = DateTime.now().toIso8601String();
    
    _orcamentos[key] = orcamento;
  }

  Future<Map<String, dynamic>?> getOrcamentoAtual() async {
    if (!_auth.isLoggedIn()) return null;
    
    await Future.delayed(Duration(milliseconds: 100));
    
    String key = '${_userId}_${DateTime.now().month}_${DateTime.now().year}';
    return _orcamentos[key];
  }

  // Eventos do calendário
  Future<void> addEvento(Map<String, dynamic> evento) async {
    if (!_auth.isLoggedIn()) throw Exception('Usuário não logado');
    
    await Future.delayed(Duration(milliseconds: 200));
    
    evento['id'] = DateTime.now().millisecondsSinceEpoch.toString();
    evento['userId'] = _userId;
    
    _eventos[_userId] ??= [];
    _eventos[_userId]!.add(evento);
  }

  Future<List<Map<String, dynamic>>> getEventos() async {
    if (!_auth.isLoggedIn()) return [];
    
    await Future.delayed(Duration(milliseconds: 100));
    
    return List.from(_eventos[_userId] ?? []);
  }

  // Sistema de pontos
  Future<void> adicionarPontos(int pontos) async {
    if (!_auth.isLoggedIn()) return;
    
    await Future.delayed(Duration(milliseconds: 100));
    
    _pontos[_userId] = (_pontos[_userId] ?? 0) + pontos;
  }

  Future<int> getTotalPontos() async {
    if (!_auth.isLoggedIn()) return 0;
    
    await Future.delayed(Duration(milliseconds: 100));
    
    return _pontos[_userId] ?? 0;
  }

  // Estatísticas
  Future<Map<String, dynamic>> getEstatisticas() async {
    if (!_auth.isLoggedIn()) return {};
    
    await Future.delayed(Duration(milliseconds: 100));
    
    List<Map<String, dynamic>> movs = await getMovimentacoes();
    List<Map<String, dynamic>> metas = await getMetas();
    
    double receitas = 0;
    double despesas = 0;
    
    for (var mov in movs) {
      double valor = mov['valor']?.toDouble() ?? 0;
      if (mov['tipo'] == 'receita') {
        receitas += valor;
      } else if (mov['tipo'] == 'despesa') {
        despesas += valor;
      }
    }
    
    return {
      'totalMovimentacoes': movs.length,
      'totalMetas': metas.length,
      'totalReceitas': receitas,
      'totalDespesas': despesas,
      'saldo': receitas - despesas,
      'totalPontos': await getTotalPontos(),
    };
  }

  // Limpar dados do usuário
  Future<void> limparDadosUsuario() async {
    if (!_auth.isLoggedIn()) return;
    
    await Future.delayed(Duration(milliseconds: 100));
    
    _movimentacoes.remove(_userId);
    _metas.remove(_userId);
    _eventos.remove(_userId);
    _pontos.remove(_userId);
    
    // Remove orçamentos do usuário
    _orcamentos.removeWhere((key, value) => key.startsWith(_userId));
  }
}