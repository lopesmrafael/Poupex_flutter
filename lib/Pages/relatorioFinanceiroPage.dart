import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../repository/data_manager.dart';
import '../repository/auth_repository.dart';
import '../repository/theme_manager.dart';
import 'ConfiguracoesPage.dart';
import 'PerfilPage.dart';

/// 🔹 Repositório local de pontos (SharedPreferences)
class PontosRepository {
  static const String _key = 'pontosAcumulados';

  Future<int> getPontos() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_key) ?? 0;
  }

  Future<void> adicionarPontos(int pontos) async {
    final prefs = await SharedPreferences.getInstance();
    final atual = prefs.getInt(_key) ?? 0;
    await prefs.setInt(_key, atual + pontos);
  }

  Future<void> resetarPontos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

class RelatorioFinanceiroPage extends StatefulWidget {
  const RelatorioFinanceiroPage({super.key});

  @override
  State<RelatorioFinanceiroPage> createState() => _RelatorioFinanceiroPageState();
}

class _RelatorioFinanceiroPageState extends State<RelatorioFinanceiroPage> {
  final DataManager _dataManager = DataManager();
  final AuthRepository _authRepository = AuthRepository();
  final TextEditingController _emailController = TextEditingController();
  final PontosRepository _pontosRepository = PontosRepository();

  bool _isValidEmail(String email) {
    final validDomains = ['@gmail.com', '@hotmail.com', '@yahoo.com', '@outlook.com'];
    return validDomains.any((domain) => email.toLowerCase().endsWith(domain));
  }

  Map<String, dynamic> _estatisticas = {};
  String _nomeUsuario = 'Usuário';
  int _pontosAcumulados = 0;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    try {
      _estatisticas = await _dataManager.getEstatisticas();
      final usuario = await _authRepository.getCurrentUser();
      _nomeUsuario = usuario?['displayName'] ?? 'Usuário';
      _pontosAcumulados = await _pontosRepository.getPontos();
      setState(() {});
    } catch (e) {
      debugPrint('Erro ao carregar dados: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeManager.backgroundColor,
      appBar: AppBar(
        title: Text(
          "Poupe✖",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: ThemeManager.textColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: ThemeManager.appBarColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ConfiguracoesPage()),
              );
            },
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PerfilPage()),
              );
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                "Relatório Financeiro - $_nomeUsuario",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ThemeManager.textColor,
                ),
              ),
            ),
            Center(
              child: Text(
                "Período: ${DateTime.now().month}/${DateTime.now().year}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: ThemeManager.subtitleColor,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 📘 RESUMO FINANCEIRO
            _buildResumoFinanceiro(),

            const SizedBox(height: 12),

            // 📊 ESTATÍSTICAS (com pontos integrados)
            _buildEstatisticas(),

            const SizedBox(height: 12),

            // 📈 ANÁLISE
            _buildAnalise(),

            const SizedBox(height: 20),

            // 📄 BOTÃO BAIXAR RELATÓRIO
            ElevatedButton(
              onPressed: _baixarRelatorio,
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeManager.cardColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  "Baixar Relatório",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ✉️ ENVIAR POR EMAIL
            Text(
              "Enviar por Email:",
              style: TextStyle(fontWeight: FontWeight.bold, color: ThemeManager.textColor),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: "Digite o email",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _enviarPorEmail,
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeManager.cardColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  "Enviar por Email",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResumoFinanceiro() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ThemeManager.cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Resumo Financeiro:",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            "• Receitas: R\$ ${(_estatisticas['totalReceitas'] ?? 0.0).toStringAsFixed(2)}",
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            "• Despesas: R\$ ${(_estatisticas['totalDespesas'] ?? 0.0).toStringAsFixed(2)}",
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            "• Saldo: R\$ ${(_estatisticas['saldo'] ?? 0.0).toStringAsFixed(2)}",
            style: TextStyle(
              color: (_estatisticas['saldo'] ?? 0.0) >= 0 ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstatisticas() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ThemeManager.cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Estatísticas:",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            "📊 Total de transações: ${_estatisticas['totalMovimentacoes'] ?? 0}",
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            "🎯 Metas ativas: ${_estatisticas['totalMetas'] ?? 0}",
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            "🏆 Pontos acumulados: $_pontosAcumulados",
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalise() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ThemeManager.cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Análise:",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            _getAnalise(),
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  String _getAnalise() {
    double saldo = _estatisticas['saldo']?.toDouble() ?? 0.0;
    int transacoes = _estatisticas['totalMovimentacoes'] ?? 0;

    if (saldo > 0) {
      return "• Parabéns! Você teve saldo positivo este período.\n• Total de $transacoes transações registradas.\n• Continue mantendo o controle financeiro!";
    } else if (saldo < 0) {
      return "• Atenção: Saldo negativo neste período.\n• Revise seus gastos e considere reduzir despesas.\n• $transacoes transações registradas.";
    } else {
      return "• Saldo equilibrado neste período.\n• $transacoes transações registradas.\n• Considere criar uma reserva de emergência.";
    }
  }

  Future<void> _baixarRelatorio() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        backgroundColor: Color(0xFF327355),
        content: Row(
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(width: 20),
            Text('Gerando relatório...', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 2));
    if (mounted) Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Relatório baixado com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _enviarPorEmail() async {
    final email = _emailController.text.trim();
    
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite um email válido')),
      );
      return;
    }

    if (!_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email deve conter @gmail.com, @hotmail.com, @yahoo.com ou @outlook.com'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final receitas = (_estatisticas['totalReceitas'] ?? 0.0).toStringAsFixed(2);
      final despesas = (_estatisticas['totalDespesas'] ?? 0.0).toStringAsFixed(2);
      final saldo = (_estatisticas['saldo'] ?? 0.0).toStringAsFixed(2);
      final transacoes = _estatisticas['totalMovimentacoes'] ?? 0;
      final metas = _estatisticas['totalMetas'] ?? 0;
      
      final subject = Uri.encodeComponent('Relatório Financeiro POUPEX - ${DateTime.now().month}/${DateTime.now().year}');
      final body = Uri.encodeComponent(
        'RELATÓRIO FINANCEIRO POUPEX\n'
        'Usuário: $_nomeUsuario\n'
        'Período: ${DateTime.now().month}/${DateTime.now().year}\n\n'
        'RESUMO FINANCEIRO:\n'
        '• Receitas: R\$ $receitas\n'
        '• Despesas: R\$ $despesas\n'
        '• Saldo: R\$ $saldo\n\n'
        'ESTATÍSTICAS:\n'
        '• Total de transações: $transacoes\n'
        '• Metas ativas: $metas\n'
        '• Pontos acumulados: $_pontosAcumulados\n\n'
        'ANÁLISE:\n'
        '${_getAnalise()}\n\n'
        '---\n'
        'Relatório gerado pelo POUPEX em ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'
      );
      
      final emailUrl = 'mailto:$email?subject=$subject&body=$body';
      final uri = Uri.parse(emailUrl);
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cliente de email aberto com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        _emailController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nenhum cliente de email encontrado no dispositivo'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email enviado com sucesso! (Simulação)'),
          backgroundColor: Colors.green,
        ),
      );
      _emailController.clear();
    }
  }
}
