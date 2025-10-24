import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthRepository {
  static String? _currentUserId;
  static Map<String, dynamic>? _currentUser;
  static Map<String, Map<String, dynamic>> _users = {};
  static const String _usersKey = 'poupex_users';
  static const String _currentUserKey = 'poupex_current_user';

  Future<Map<String, dynamic>?> signIn(String email, String password) async {
    try {
      await _loadUsers();
      await Future.delayed(Duration(milliseconds: 500));
      
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email e senha são obrigatórios');
      }

      if (!email.contains('@')) {
        throw Exception('Email inválido');
      }

      String userId = 'user_${email.hashCode}';
      if (_users.containsKey(userId)) {
        Map<String, dynamic> userData = _users[userId]!;
        if (userData['password'] == password) {
          _currentUserId = userId;
          _currentUser = Map.from(userData)..remove('password');
          await _saveCurrentUser();
          return _currentUser;
        } else {
          throw Exception('Senha incorreta');
        }
      } else {
        throw Exception('Usuário não encontrado');
      }
    } catch (e) {
      throw Exception('Erro ao fazer login: ${e.toString().replaceAll('Exception: ', '')}');
    }
  }

  Future<Map<String, dynamic>?> signUp(String email, String password, String nome, String telefone) async {
    try {
      await _loadUsers();
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
      
      if (_users.containsKey(userId)) {
        throw Exception('Usuário já cadastrado');
      }

      Map<String, dynamic> userData = {
        'uid': userId,
        'email': email,
        'displayName': nome,
        'telefone': telefone,
        'password': password,
        'createdAt': DateTime.now().toIso8601String(),
      };

      _users[userId] = userData;
      await _saveUsers();
      
      _currentUserId = userId;
      _currentUser = Map.from(userData)..remove('password');
      await _saveCurrentUser();
      
      return _currentUser;
    } catch (e) {
      throw Exception('Erro ao criar conta: ${e.toString().replaceAll('Exception: ', '')}');
    }
  }

  Future<void> signOut() async {
    await Future.delayed(Duration(milliseconds: 200));
    _currentUserId = null;
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
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

  Future<void> _loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    if (usersJson != null) {
      final Map<String, dynamic> decoded = json.decode(usersJson);
      _users = decoded.map((key, value) => MapEntry(key, Map<String, dynamic>.from(value)));
    }
  }

  Future<void> _saveUsers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usersKey, json.encode(_users));
  }

  Future<void> _saveCurrentUser() async {
    if (_currentUser != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_currentUserKey, json.encode(_currentUser));
    }
  }

  Future<void> loadCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_currentUserKey);
    if (userJson != null) {
      _currentUser = Map<String, dynamic>.from(json.decode(userJson));
      _currentUserId = _currentUser!['uid'];
    }
  }
}