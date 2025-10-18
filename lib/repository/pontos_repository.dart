import 'package:shared_preferences/shared_preferences.dart';

class PontosRepository {
  static const String _key = 'pontosAcumulados';

  // Pegar pontos atuais
  Future<int> getPontos() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_key) ?? 0;
  }

  // Adicionar pontos
  Future<void> adicionarPontos(int pontos) async {
    final prefs = await SharedPreferences.getInstance();
    final atual = prefs.getInt(_key) ?? 0;
    await prefs.setInt(_key, atual + pontos);
  }

  // Zerar pontos (opcional)
  Future<void> resetarPontos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}