class ConfigRepository {
  static Map<String, dynamic> _configs = {
    'notificacoes': true,
    'modoEscuro': false,
    'biometria': false,
    'moeda': 'BRL',
  };

  Future<bool> getNotificacoes() async {
    await Future.delayed(Duration(milliseconds: 100));
    return _configs['notificacoes'] ?? true;
  }

  Future<void> setNotificacoes(bool value) async {
    await Future.delayed(Duration(milliseconds: 100));
    _configs['notificacoes'] = value;
  }

  Future<bool> getModoEscuro() async {
    await Future.delayed(Duration(milliseconds: 100));
    return _configs['modoEscuro'] ?? false;
  }

  Future<void> setModoEscuro(bool value) async {
    await Future.delayed(Duration(milliseconds: 100));
    _configs['modoEscuro'] = value;
  }

  Future<bool> getBiometria() async {
    await Future.delayed(Duration(milliseconds: 100));
    return _configs['biometria'] ?? false;
  }

  Future<void> setBiometria(bool value) async {
    await Future.delayed(Duration(milliseconds: 100));
    _configs['biometria'] = value;
  }

  Future<String> getMoeda() async {
    await Future.delayed(Duration(milliseconds: 100));
    return _configs['moeda'] ?? 'BRL';
  }

  Future<void> setMoeda(String value) async {
    await Future.delayed(Duration(milliseconds: 100));
    _configs['moeda'] = value;
  }

  Future<Map<String, dynamic>> getAllConfigs() async {
    await Future.delayed(Duration(milliseconds: 100));
    return Map.from(_configs);
  }
}