import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import '../repository/auth_repository.dart';
import '../Widget/terms_dialog.dart';
import 'HomePage.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final AuthRepository _authRepository = AuthRepository();

  bool _isLoading = false;

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    return regex.hasMatch(email);
  }

  void _showInvalidEmailDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF327355),
        title: const Text('Email Inválido', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Por favor, insira um email válido (exemplo: nome@dominio.com).',
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

  Future<void> _inscrever() async {
    if (_isLoading) return;

    final nome = _nomeController.text.trim();
    final email = _emailController.text.trim();
    final telefone = _telefoneController.text.trim();
    final senha = _senhaController.text.trim();

    // Verificações básicas
    if (nome.isEmpty || email.isEmpty || telefone.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_isValidEmail(email)) {
      _showInvalidEmailDialog();
      return;
    }

    if (senha.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A senha deve ter pelo menos 6 caracteres.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 🔹 Cria conta + salva no Firestore
      final user = await _authRepository.signUp(email, senha, nome, telefone);

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cadastro realizado com sucesso!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );

        // Aguarda um pouco e vai direto para HomePage
        await Future.delayed(const Duration(seconds: 1));
        
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const TermsDialog()),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF4C8C64),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "CRIE UMA CONTA",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Inscreva-se para começar",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 40),

              // Nome
              TextField(
                controller: _nomeController,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                decoration: _inputDecoration("Nome", Icons.person),
              ),
              const SizedBox(height: 16),

              // Email
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration("Email", Icons.email),
              ),
              const SizedBox(height: 16),

              // Telefone
              TextField(
                controller: _telefoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [MaskedInputFormatter('(##) #####-####')],
                decoration: _inputDecoration("Telefone", Icons.phone),
              ),
              const SizedBox(height: 16),

              // Senha
              TextField(
                controller: _senhaController,
                obscureText: true,
                decoration: _inputDecoration("Senha", Icons.lock),
              ),
              const SizedBox(height: 24),

              // Botão de cadastro
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _inscrever,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3A6F3A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "INSCREVER-SE",
                          style: TextStyle(
                            letterSpacing: 1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),

              // Link "Entrar"
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Já tem uma conta? ",
                    style: TextStyle(color: Colors.white70),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      "Entrar",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.black),
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
    );
  }
}
