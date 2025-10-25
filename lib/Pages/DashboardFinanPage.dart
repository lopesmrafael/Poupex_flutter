import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../repository/movimentacao_repository.dart';
import '../repository/auth_repository.dart';
import 'ConfiguracoesPage.dart';
import 'PerfilPage.dart';
import 'package:intl/intl.dart';

class DashboardFinanPage extends StatefulWidget {
  const DashboardFinanPage({super.key});

  @override
  State<DashboardFinanPage> createState() => _DashboardFinanPageState();
}

class _DashboardFinanPageState extends State<DashboardFinanPage> {
  final MovimentacaoRepository _movimentacaoRepository = MovimentacaoRepository();
  final AuthRepository _authRepository = AuthRepository();

  Map<String, double> _resumoFinanceiro = {
    'receitas': 0.0,
    'despesas': 0.0,
    'saldo': 0.0,
  };
  String _nomeUsuario = 'Usuário';
  Map<int, double> _saldosMensais = {};

  @override
  void initState() {
    super.initState();
    _carregarResumoFinanceiro();
    _carregarNomeUsuario();
    _carregarSaldosMensais();
  }

  Future<void> _carregarResumoFinanceiro() async {
    try {
      Map<String, double> resumo = await _movimentacaoRepository.getResumoFinanceiro();
      setState(() {
        _resumoFinanceiro = resumo;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados: $e')),
      );
    }
  }

  void _carregarNomeUsuario() {
    final user = _authRepository.getCurrentUser();
    if (user != null && user['displayName'] != null) {
      setState(() {
        _nomeUsuario = user['displayName'];
      });
    }
  }

  Future<void> _carregarSaldosMensais() async {
    try {
      final resultado = await _movimentacaoRepository.getSaldoMensal(); // deve retornar Map<int, double>
      if (resultado is Map<int, double>) {
        setState(() {
          _saldosMensais = resultado;
        });
      }
    } catch (e) {
      print("Erro ao carregar saldos mensais: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final mesAtual = DateTime.now().month;
    final meses = [
      "Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho",
      "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF54A781),
      appBar: AppBar(
        title: const Text(
          "Poupe✖",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF327355),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ConfiguracoesPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PerfilPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Dashboard Financeiro - $_nomeUsuario",
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Aqui estão seus dados financeiros\nde forma clara e organizada.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              "R\$ ${_resumoFinanceiro['saldo']!.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              _resumoFinanceiro['saldo']! >= 0
                  ? "+ ${_resumoFinanceiro['saldo']!.toStringAsFixed(2)}"
                  : _resumoFinanceiro['saldo']!.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 18,
                color: _resumoFinanceiro['saldo']! >= 0
                    ? Colors.lightGreenAccent
                    : Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // === Gráfico Dinâmico ===
            Container(
              height: 180,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF327355),
                borderRadius: BorderRadius.circular(12),
              ),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (index >= 0 && index < meses.length) {
                            return Text(
                              meses[index].substring(0, 3).toUpperCase(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 10),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _saldosMensais.entries
                          .map((e) => FlSpot(
                              e.key.toDouble() - 1, e.value.toDouble()))
                          .toList(),
                      isCurved: true,
                      color: Colors.lightGreenAccent,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // === Cards de Renda e Despesa ===
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                cardInfo(
                  "Renda",
                  "R\$ ${_resumoFinanceiro['receitas']!.toStringAsFixed(2)}",
                  "+${_resumoFinanceiro['receitas']!.toStringAsFixed(2)}",
                  Colors.green,
                  true,
                ),
                cardInfo(
                  "Despesa",
                  "R\$ ${_resumoFinanceiro['despesas']!.toStringAsFixed(2)}",
                  "-${_resumoFinanceiro['despesas']!.toStringAsFixed(2)}",
                  Colors.red,
                  false,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // === Lista Mensal Dinâmica ===
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF327355),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.builder(
                  itemCount: mesAtual,
                  itemBuilder: (context, index) {
                    final mes = meses[index];
                    final valor =
                        _saldosMensais[index + 1]?.toStringAsFixed(2) ?? "0.00";
                    final status = (index + 1) < mesAtual
                        ? "Completo"
                        : (index + 1) == mesAtual
                            ? "Em andamento"
                            : "Pendente";
                    final cor = status == "Em andamento"
                        ? Colors.orange
                        : status == "Pendente"
                            ? Colors.grey
                            : Colors.green;

                    return projetoItem(mes, valor, status, cor);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget cardInfo(
    String titulo, String valor, String variacao, Color cor, bool positivo) {
  return Container(
    width: 150,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFF327355),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      children: [
        Text(
          titulo,
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
        const SizedBox(height: 5),
        Text(
          valor,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              positivo ? Icons.arrow_upward : Icons.arrow_downward,
              color: cor,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              variacao,
              style: TextStyle(color: cor, fontSize: 14),
            ),
          ],
        ),
      ],
    ),
  );
}

class projetoItem extends StatelessWidget {
  final String mes;
  final String valor;
  final String status;
  final Color cor;

  const projetoItem(this.mes, this.valor, this.status, this.cor, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white10,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(
          mes,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "R\$ $valor",
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: Text(
          status,
          style: TextStyle(color: cor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
