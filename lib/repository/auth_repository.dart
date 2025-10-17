class AuthRepository {
  static String? _currentUserId;
  static Map<String, dynamic>? _currentUser;
  static Map<String, Map<String, dynamic>> _users = {};

  Future<Map<String, dynamic>?> signIn(String email, String password) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email e senha são obrigatórios');
      }

      if (!email.contains('@')) {
        throw Exception('Email inválido');
      }

      // Verifica se usuário existe
      String userId = 'user_${email.hashCode}';
      if (_users.containsKey(userId)) {
        Map<String, dynamic> userData = _users[userId]!;
        if (userData['password'] == password) {
          _currentUserId = userId;
          _currentUser = Map.from(userData)..remove('password');
          return _currentUser;
        } else {
          throw Exception('Senha incorreta');
        }
      }
      
      // Login genérico para desenvolvimento
      _currentUserId = userId;
      _currentUser = {
        'uid': userId,
        'email': email,
        'displayName': email.split('@')[0],
        'loginAt': DateTime.now().toIso8601String(),
      };
      return _currentUser;
    } catch (e) {
      throw Exception('Erro ao fazer login: ${e.toString().replaceAll('Exception: ', '')}');
    }
  }

  Future<Map<String, dynamic>?> signUp(String email, String password, String nome, String telefone) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      
      if (email.isEmpty || password.isEmpty || nome.isEmpty) {
        throw Exception('Todos os campos são obrigatórios');
      }

      if (!email.contains('@')) {
        throw Exception('Email inválido');
      }

      if (password.length < 6) {
        throw Exception('Senha deve ter pelo menos 6 caracteres');
      }

      String userId = 'user_${email.hashCode}';
      
      // Verifica se usuário já existe
      if (_users.containsKey(userId)) {
        throw Exception('Usuário já cadastrado');
      }

      // Cria novo usuário
      Map<String, dynamic> userData = {
        'uid': userId,
        'email': email,
        'displayName': nome,
        'telefone': telefone,
        'password': password,
        'createdAt': DateTime.now().toIso8601String(),
      };

      _users[userId] = userData;
      _currentUserId = userId;
      _currentUser = Map.from(userData)..remove('password');
      
      return _currentUser;
    } catch (e) {
      throw Exception('Erro ao criar conta: ${e.toString().replaceAll('Exception: ', '')}');
    }
  }

  Future<void> signOut() async {
    await Future.delayed(Duration(milliseconds: 200));
    _currentUserId = null;
    _currentUser = null;
  }

  Future<void> resetPassword(String email) async {
    await Future.delayed(Duration(milliseconds: 500));
    if (email.isEmpty || !email.contains('@')) {
      throw Exception('Email inválido');
    }
    // Simula envio de email
  }

  Map<String, dynamic>? getCurrentUser() {
    return _currentUser;
  }

  String? getCurrentUserId() {
    return _currentUserId;
  }

  bool isLoggedIn() {
    return _currentUserId != null && _currentUser != null;
  }

  Future<void> updateProfile({String? nome, String? telefone}) async {
    if (!isLoggedIn()) throw Exception('Usuário não logado');
    
    await Future.delayed(Duration(milliseconds: 300));
    
    if (nome != null) {
      _currentUser!['displayName'] = nome;
      _users[_currentUserId!]!['displayName'] = nome;
    }
    
    if (telefone != null) {
      _currentUser!['telefone'] = telefone;
      _users[_currentUserId!]!['telefone'] = telefone;
    }
  }

  // Dados para desenvolvimento
  static void _initDemoData() {
    if (_users.isEmpty) {
      _users['demo_user'] = {
        'uid': 'demo_user',
        'email': 'demo@poupex.com',
        'displayName': 'Usuário Demo',
        'telefone': '(11) 99999-9999',
        'password': '123456',
        'createdAt': DateTime.now().subtract(Duration(days: 30)).toIso8601String(),
      };
    }
  }
}