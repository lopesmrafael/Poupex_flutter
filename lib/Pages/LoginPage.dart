import 'package:flutter/material.dart';
import 'package:projeto_pity/Pages/CadastroPage.dart';
import 'HomePage.dart';
import '../Pages/redefinirSenhaPage.dart';
import '../repository/auth_repository.dart';
import '../repository/theme_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final AuthRepository _authRepository = AuthRepository();

  bool _isValidEmail(String email) {
    final validDomains = ['@gmail.com', '@hotmail.com', '@yahoo.com', '@outlook.com'];
    return validDomains.any((domain) => email.toLowerCase().endsWith(domain));
  }

  void _showInvalidEmailDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF327355),
        title: const Text('Email Inválido', style: TextStyle(color: Colors.white)),
        content: const Text(
          'O email deve conter um domínio válido:\n• @gmail.com\n• @hotmail.com\n• @yahoo.com\n• @outlook.com',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _entrar() async {
    final login = _loginController.text.trim();
    final senha = _senhaController.text.trim();

    if (login.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (!_isValidEmail(login)) {
      _showInvalidEmailDialog();
      return;
    }

    try {
      final user = await _authRepository.signIn(login, senha);
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login realizado com sucesso!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeManager.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/LogoPoupex.png',
                      height: 120,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "POUPEX",
                      style: TextStyle(
                        fontSize: 20,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w500,
                        color: ThemeManager.textColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),

              // Campo Login
              TextField(
                controller: _loginController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person, color: Colors.black),
                  hintText: 'Login',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Campo Senha
              TextField(
                controller: _senhaController,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock, color: Colors.black),
                  hintText: 'Senha',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Botão Entrar
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: _entrar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7031),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text("Entrar"),
                ),
              ),
              const SizedBox(height: 20),

              // Redefinir senha
GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RedefinirSenhaPage (), // <- sua tela de redefinição
      ),
    );
  },
  child: Text(
    "Redefinir senha",
    style: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.underline, // deixa estilo "link"
    ),
  ),
),

              // Botão Google
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Image.asset('assets/google.png', height: 20),
                  label: const Text("Entrar com Google"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3EA860),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Botão Facebook
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Image.asset('assets/facebook.png', height: 20),
                  label: const Text("Entrar com Facebook"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3EA860),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Criar conta
              GestureDetector(
                onTap: () {
                    Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CadastroPage(),
                    ),
                  );
                },
                child: const Text(
                  "CRIAR CONTA",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


