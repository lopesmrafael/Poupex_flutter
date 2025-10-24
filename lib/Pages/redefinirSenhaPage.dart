import 'package:flutter/material.dart';
import '../repository/auth_repository.dart';

class RedefinirSenhaPage extends StatefulWidget {
  const RedefinirSenhaPage({super.key});

  @override
  State<RedefinirSenhaPage> createState() => _RedefinirSenhaPageState();
}

class _RedefinirSenhaPageState extends State<RedefinirSenhaPage> {
  final TextEditingController _emailController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4B9460),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                "assets/LogoPoupex.png", // mesma logo da tela de login
                height: 120,
              ),
              const SizedBox(height: 20),
              const Text(
                "POUPEX",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),

              // Título
              const Text(
                "Redefinir Senha",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Informe seu e-mail e enviaremos\num link para redefinir sua senha.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 30),

              // Campo Email
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "Digite seu e-mail",
                  prefixIcon: const Icon(Icons.email, color: Colors.black87),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Botão enviar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF255C3C),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () async {
                    final email = _emailController.text.trim();
                    
                    if (email.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Por favor, digite seu e-mail"),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    if (!_isValidEmail(email)) {
                      _showInvalidEmailDialog();
                      return;
                    }
                    
                    try {
                      await _authRepository.resetPassword(email);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("E-mail de redefinição enviado!"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Erro: ${e.toString().replaceAll('Exception: ', '')}"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "ENVIAR",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Voltar para login
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Voltar para Login",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
