import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AchievementSystem {
  static const String _keyPontos = 'pontosAcumulados';
  static const String _keyConquistas = 'conquistasDesbloqueadas';
  static const String _keyContadores = 'contadoresAcoes';

  // Conquistas disponíveis
  static const Map<String, Map<String, dynamic>> conquistas = {
    'primeira_transacao': {
      'titulo': 'Primeira Transação',
      'descricao': 'Registre sua primeira movimentação',
      'pontos': 100,
      'icone': 'assets/meusPontos/vale.png',
    },
    'cinco_transacoes': {
      'titulo': '5 Transações',
      'descricao': 'Registre 5 movimentações',
      'pontos': 200,
      'icone': 'assets/meusPontos/valeEvento.png',
    },
    'primeira_meta': {
      'titulo': 'Primeira Meta',
      'descricao': 'Crie sua primeira meta financeira',
      'pontos': 150,
      'icone': 'assets/meusPontos/setup.png',
    },
    'orcamento_criado': {
      'titulo': 'Orçamento Criado',
      'descricao': 'Configure seu primeiro orçamento',
      'pontos': 120,
      'icone': 'assets/meusPontos/tiket.png',
    },
    'dez_transacoes': {
      'titulo': '10 Transações',
      'descricao': 'Registre 10 movimentações',
      'pontos': 300,
      'icone': 'assets/meusPontos/vale.png',
    },
  };

  Future<int> getPontos() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyPontos) ?? 0;
  }

  Future<void> _adicionarPontos(int pontos) async {
    final prefs = await SharedPreferences.getInstance();
    final atual = prefs.getInt(_keyPontos) ?? 0;
    await prefs.setInt(_keyPontos, atual + pontos);
  }

  Future<List<String>> getConquistasDesbloqueadas() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyConquistas) ?? [];
  }

  Future<void> _salvarConquista(String conquistaId) async {
    final prefs = await SharedPreferences.getInstance();
    final conquistasAtuais = prefs.getStringList(_keyConquistas) ?? [];
    if (!conquistasAtuais.contains(conquistaId)) {
      conquistasAtuais.add(conquistaId);
      await prefs.setStringList(_keyConquistas, conquistasAtuais);
    }
  }

  Future<Map<String, int>> _getContadores() async {
    final prefs = await SharedPreferences.getInstance();
    final contadoresJson = prefs.getString(_keyContadores);
    if (contadoresJson != null) {
      return Map<String, int>.from(json.decode(contadoresJson));
    }
    return {};
  }

  Future<void> _salvarContadores(Map<String, int> contadores) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyContadores, json.encode(contadores));
  }

  Future<List<String>> verificarTransacao() async {
    final contadores = await _getContadores();
    final conquistasDesbloqueadas = await getConquistasDesbloqueadas();
    final novasConquistas = <String>[];

    // Incrementar contador de transações
    contadores['transacoes'] = (contadores['transacoes'] ?? 0) + 1;
    await _salvarContadores(contadores);

    // Verificar conquistas
    if (contadores['transacoes'] == 1 && !conquistasDesbloqueadas.contains('primeira_transacao')) {
      await _desbloquearConquista('primeira_transacao');
      novasConquistas.add('primeira_transacao');
    }

    if (contadores['transacoes'] == 5 && !conquistasDesbloqueadas.contains('cinco_transacoes')) {
      await _desbloquearConquista('cinco_transacoes');
      novasConquistas.add('cinco_transacoes');
    }

    if (contadores['transacoes'] == 10 && !conquistasDesbloqueadas.contains('dez_transacoes')) {
      await _desbloquearConquista('dez_transacoes');
      novasConquistas.add('dez_transacoes');
    }

    return novasConquistas;
  }

  Future<List<String>> verificarMeta() async {
    final contadores = await _getContadores();
    final conquistasDesbloqueadas = await getConquistasDesbloqueadas();
    final novasConquistas = <String>[];

    contadores['metas'] = (contadores['metas'] ?? 0) + 1;
    await _salvarContadores(contadores);

    if (contadores['metas'] == 1 && !conquistasDesbloqueadas.contains('primeira_meta')) {
      await _desbloquearConquista('primeira_meta');
      novasConquistas.add('primeira_meta');
    }

    return novasConquistas;
  }

  Future<List<String>> verificarOrcamento() async {
    final contadores = await _getContadores();
    final conquistasDesbloqueadas = await getConquistasDesbloqueadas();
    final novasConquistas = <String>[];

    contadores['orcamentos'] = (contadores['orcamentos'] ?? 0) + 1;
    await _salvarContadores(contadores);

    if (contadores['orcamentos'] == 1 && !conquistasDesbloqueadas.contains('orcamento_criado')) {
      await _desbloquearConquista('orcamento_criado');
      novasConquistas.add('orcamento_criado');
    }

    return novasConquistas;
  }

  Future<void> _desbloquearConquista(String conquistaId) async {
    final conquista = conquistas[conquistaId];
    if (conquista != null) {
      await _salvarConquista(conquistaId);
      await _adicionarPontos(conquista['pontos']);
    }
  }

  Future<void> resetarPontos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyPontos);
    await prefs.remove(_keyConquistas);
    await prefs.remove(_keyContadores);
  }
}