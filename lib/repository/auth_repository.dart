import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Fallback local para quando Firebase não estiver disponível
  static Map<String, Map<String, dynamic>> _localUsers = {
    // Usuário padrão para testes
    'user_-1829053464': {
      'uid': 'user_-1829053464',
      'email': 'teste@gmail.com',
      'displayName': 'Usuário Teste',
      'telefone': '(11) 99999-9999',
      'password': '123456',
      'createdAt': '2024-01-01T00:00:00.000Z',
    }
  };
  static Map<String, dynamic>? _currentUser;
  
  User? get currentUser => _auth.currentUser;

  Future<Map<String, dynamic>?> signIn(String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email e senha são obrigatórios');
      }

      if (!email.contains('@')) {
        throw Exception('Email inválido');
      }

      // Tentar Firebase primeiro
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (userCredential.user != null) {
          DocumentSnapshot userDoc = await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .get();

          if (userDoc.exists) {
            _currentUser = {
              'uid': userCredential.user!.uid,
              'email': userCredential.user!.email,
              'displayName': userDoc.get('displayName') ?? '',
              'telefone': userDoc.get('telefone') ?? '',
            };
            return _currentUser;
          }
        }
      } catch (firebaseError) {
        // Se Firebase falhar, usar sistema local
        String userId = 'user_${email.hashCode}';
        if (_localUsers.containsKey(userId)) {
          Map<String, dynamic> userData = _localUsers[userId]!;
          if (userData['password'] == password) {
            _currentUser = Map.from(userData)..remove('password');
            return _currentUser;
          } else {
            throw Exception('Senha incorreta');
          }
        } else {
          throw Exception('Usuário não encontrado. Use: teste@gmail.com / 123456 ou cadastre-se');
        }
      }
      return null;
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<Map<String, dynamic>?> signUp(String email, String password, String nome, String telefone) async {
    try {
      if (email.isEmpty || password.isEmpty || nome.isEmpty) {
        throw Exception('Todos os campos são obrigatórios');
      }

      if (!email.contains('@')) {
        throw Exception('Email inválido');
      }

      if (password.length < 6) {
        throw Exception('Senha deve ter pelo menos 6 caracteres');
      }

      // Tentar Firebase primeiro
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (userCredential.user != null) {
          await _firestore.collection('users').doc(userCredential.user!.uid).set({
            'email': email,
            'displayName': nome,
            'telefone': telefone,
            'createdAt': FieldValue.serverTimestamp(),
          });

          _currentUser = {
            'uid': userCredential.user!.uid,
            'email': email,
            'displayName': nome,
            'telefone': telefone,
          };
          return _currentUser;
        }
      } catch (firebaseError) {
        // Se Firebase falhar, usar sistema local
        String userId = 'user_${email.hashCode}';
        
        if (_localUsers.containsKey(userId)) {
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

        _localUsers[userId] = userData;
        _currentUser = Map.from(userData)..remove('password');
        return _currentUser;
      }
      return null;
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      // Se Firebase falhar, limpar dados locais
    }
    _currentUser = null;
  }

  Future<void> resetPassword(String email) async {
    try {
      if (email.isEmpty || !email.contains('@')) {
        throw Exception('Email inválido');
      }
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw Exception('Usuário não encontrado');
        case 'invalid-email':
          throw Exception('Email inválido');
        default:
          throw Exception('Erro ao enviar email: ${e.message}');
      }
    }
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    // Tentar Firebase primeiro
    if (_auth.currentUser != null) {
      try {
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .get();
        
        if (userDoc.exists) {
          return {
            'uid': _auth.currentUser!.uid,
            'email': _auth.currentUser!.email,
            'displayName': userDoc.get('displayName') ?? '',
            'telefone': userDoc.get('telefone') ?? '',
          };
        }
      } catch (e) {
        // Se Firebase falhar, usar dados locais
      }
    }
    
    // Fallback para dados locais
    return _currentUser;
  }

  String? getCurrentUserId() {
    return _auth.currentUser?.uid ?? _currentUser?['uid'];
  }

  bool isLoggedIn() {
    return _auth.currentUser != null || _currentUser != null;
  }

  Future<void> updateProfile({String? nome, String? telefone}) async {
    if (!isLoggedIn()) throw Exception('Usuário não logado');
    
    Map<String, dynamic> updates = {};
    
    if (nome != null) {
      updates['displayName'] = nome;
    }
    
    if (telefone != null) {
      updates['telefone'] = telefone;
    }
    
    if (updates.isNotEmpty) {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update(updates);
    }
  }

  Future<void> loadCurrentUser() async {
    // Firebase Auth mantém o estado automaticamente
  }
}