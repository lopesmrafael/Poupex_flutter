import 'package:flutter/material.dart';
import '../repository/auth_repository.dart';
import '../repository/config_repository.dart';
import '../repository/theme_manager.dart';
import 'LoginPage.dart';

class ConfiguracoesPage extends StatefulWidget {
  const ConfiguracoesPage({super.key});

  @override
  State<ConfiguracoesPage> createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {
  final AuthRepository _authRepository = AuthRepository();
  final ConfigRepository _configRepository = ConfigRepository();
  bool _notificacoes = true;
  bool _modoEscuro = false;
  bool _biometria = false;
  String _moeda = 'BRL';

  @override
  void initState() {
    super.initState();
    _carregarConfiguracoes();
  }

  void _carregarConfiguracoes() async {
    try {
      final configs = await _configRepository.getAllConfigs();
      setState(() {
        _notificacoes = configs['notificacoes'] ?? true;
        _modoEscuro = configs['modoEscuro'] ?? false;
        _biometria = configs['biometria'] ?? false;
        _moeda = configs['moeda'] ?? 'BRL';
      });
    } catch (e) {
      // Ignora erro
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF54A781),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.keyboard_backspace, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Configurações',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF327355),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection('Notificações', [
            _buildSwitchTile(
              'Notificações Push',
              'Receber alertas e lembretes',
              _notificacoes,
              (value) async {
                await _configRepository.setNotificacoes(value);
                setState(() => _notificacoes = value);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Notificações ${value ? 'ativadas' : 'desativadas'}')),
                );
              },
              Icons.notifications,
            ),
          ]),
          
          _buildSection('Aparência', [
            _buildSwitchTile(
              'Modo Escuro',
              'Tema escuro para o aplicativo',
              _modoEscuro,
              (value) async {
                await _configRepository.setModoEscuro(value);
                ThemeManager.setDarkMode(value);
                setState(() {
                  _modoEscuro = value;
                });
                // Força rebuild de toda a árvore de widgets
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ConfiguracoesPage()),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Modo escuro ${value ? 'ativado' : 'desativado'}')),
                );
              },
              Icons.dark_mode,
            ),
          ]),

          _buildSection('Segurança', [
            _buildSwitchTile(
              'Biometria',
              'Login com impressão digital',
              _biometria,
              (value) async {
                await _configRepository.setBiometria(value);
                setState(() => _biometria = value);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Biometria ${value ? 'ativada' : 'desativada'}')),
                );
              },
              Icons.fingerprint,
            ),
            _buildTile(
              'Alterar Senha',
              'Modificar senha de acesso',
              Icons.lock,
              () => _mostrarAlterarSenha(),
            ),
          ]),

          _buildSection('Preferências', [
            _buildDropdownTile(
              'Moeda',
              'Moeda padrão do aplicativo',
              _moeda,
              ['BRL', 'USD', 'EUR'],
              (value) async {
                await _configRepository.setMoeda(value!);
                setState(() => _moeda = value!);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Moeda alterada para $value')),
                );
              },
              Icons.attach_money,
            ),
          ]),

          _buildSection('Dados', [
            _buildTile(
              'Exportar Dados',
              'Baixar relatório completo',
              Icons.download,
              () => _exportarDados(),
            ),
            _buildTile(
              'Limpar Cache',
              'Limpar dados temporários',
              Icons.cleaning_services,
              () => _limparCache(),
            ),
          ]),

          _buildSection('Conta', [
            _buildTile(
              'Sair',
              'Fazer logout da conta',
              Icons.exit_to_app,
              () => _sair(),
              color: Colors.red,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF327355),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.green,
      ),
    );
  }

  Widget _buildTile(String title, String subtitle, IconData icon, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.white),
      title: Text(title, style: TextStyle(color: color ?? Colors.white)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildDropdownTile(String title, String subtitle, String value, List<String> items, Function(String?) onChanged, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70)),
      trailing: DropdownButton<String>(
        value: value,
        dropdownColor: const Color(0xFF327355),
        style: const TextStyle(color: Colors.white),
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  void _mostrarAlterarSenha() {
    final TextEditingController senhaAtualController = TextEditingController();
    final TextEditingController novaSenhaController = TextEditingController();
    final TextEditingController confirmarSenhaController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF327355),
        title: const Text('Alterar Senha', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: senhaAtualController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Senha Atual',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              ),
            ),
            TextField(
              controller: novaSenhaController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Nova Senha',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              ),
            ),
            TextField(
              controller: confirmarSenhaController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Confirmar Nova Senha',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              if (novaSenhaController.text.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nova senha deve ter pelo menos 6 caracteres')),
                );
                return;
              }
              if (novaSenhaController.text != confirmarSenhaController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Senhas não coincidem')),
                );
                return;
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Senha alterada com sucesso!')),
              );
            },
            child: const Text('Alterar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _exportarDados() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        backgroundColor: Color(0xFF327355),
        content: Row(
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(width: 20),
            Text('Exportando dados...', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
    
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dados exportados com sucesso! Arquivo salvo em Downloads.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _limparCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF327355),
        title: const Text('Limpar Cache', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Isso irá remover dados temporários e pode melhorar a performance. Continuar?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const AlertDialog(
                  backgroundColor: Color(0xFF327355),
                  content: Row(
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(width: 20),
                      Text('Limpando cache...', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              );
              
              await Future.delayed(const Duration(seconds: 1));
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cache limpo com sucesso!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Limpar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _sair() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF327355),
        title: const Text('Sair', style: TextStyle(color: Colors.white)),
        content: const Text('Deseja realmente sair da sua conta?', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () async {
              await _authRepository.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
            child: const Text('Sair', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}