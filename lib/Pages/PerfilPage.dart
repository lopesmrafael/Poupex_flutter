import 'package:flutter/material.dart';
import '../repository/auth_repository.dart';
import '../repository/theme_manager.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final AuthRepository _authRepository = AuthRepository();
  Map<String, dynamic>? _usuario;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  void _carregarDados() {
    _usuario = _authRepository.getCurrentUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeManager.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace, color: ThemeManager.textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Meu Perfil',
          style: TextStyle(color: ThemeManager.textColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: ThemeManager.appBarColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildPerfilHeader(),
            const SizedBox(height: 20),
            _buildInformacoesUsuario(),
          ],
        ),
      ),
    );
  }

  Widget _buildPerfilHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ThemeManager.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Text(
              _getIniciais(),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF327355),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _usuario?['displayName'] ?? 'Usuário',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _usuario?['email'] ?? 'email@exemplo.com',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _editarPerfil,
            icon: const Icon(Icons.edit, size: 18),
            label: const Text('Editar Perfil'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF327355),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInformacoesUsuario() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeManager.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informações da Conta',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Email', _usuario?['email'] ?? 'Não informado'),
          _buildInfoRow('Telefone', _usuario?['telefone'] ?? 'Não informado'),
          _buildInfoRow('Membro desde', 'Janeiro 2024'),
          _buildInfoRow('Último acesso', 'Hoje'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  String _getIniciais() {
    String nome = _usuario?['displayName'] ?? 'U';
    if (nome.isEmpty) return 'U';
    List<String> palavras = nome.split(' ');
    if (palavras.length >= 2) {
      return '${palavras[0][0]}${palavras[1][0]}'.toUpperCase();
    }
    return nome[0].toUpperCase();
  }

  void _editarPerfil() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidade de edição em desenvolvimento'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}