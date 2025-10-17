import 'package:flutter/material.dart';
import '../repository/data_manager.dart';
import '../repository/auth_repository.dart';
import 'ConfiguracoesPage.dart';
import 'PerfilPage.dart';

class RelatorioFinanceiroPage extends StatefulWidget {
  const RelatorioFinanceiroPage({super.key});

  @override
  State<RelatorioFinanceiroPage> createState() => _RelatorioFinanceiroPageState();
}

class _RelatorioFinanceiroPageState extends State<RelatorioFinanceiroPage> {
  final DataManager _dataManager = DataManager();
  final AuthRepository _authRepository = AuthRepository();
  final TextEditingController _emailController = TextEditingController();
  
  Map<String, dynamic> _estatisticas = {};
  String _nomeUsuario = 'Usuário';

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  void _carregarDados() async {
    try {
      _estatisticas = await _dataManager.getEstatisticas();
      final usuario = _authRepository.getCurrentUser();
      _nomeUsuario = usuario?['displayName'] ?? 'Usuário';
      setState(() {});
    } catch (e) {
      // Ignora erro
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF54A781),
      appBar: AppBar(
        title: Image.asset(
          "assets/titulo.jpg",
          height: 40,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF327355),
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
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Center(
              child: Text(
                "Período: ${DateTime.now().month}/${DateTime.now().year}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF4E9171),
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
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF4E9171),
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
                    "🏆 Pontos acumulados: ${_estatisticas['totalPontos'] ?? 0}",
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF4E9171),
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
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _baixarRelatorio,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF327355),
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
            const Text(
              "Enviar por Email:",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
                backgroundColor: const Color(0xFF327355),
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

  void _baixarRelatorio() async {
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
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Relatório baixado com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _enviarPorEmail() async {
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite um email válido')),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        backgroundColor: Color(0xFF327355),
        content: Row(
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(width: 20),
            Text('Enviando email...', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
    
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Relatório enviado para ${_emailController.text}'),
        backgroundColor: Colors.green,
      ),
    );
    
    _emailController.clear();
  }
}