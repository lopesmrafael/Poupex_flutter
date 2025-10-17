import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../repository/movimentacao_repository.dart';
import 'ConfiguracoesPage.dart';
import 'PerfilPage.dart';

class DashboardFinanPage extends StatefulWidget {
  const DashboardFinanPage({super.key});

  @override
  State<DashboardFinanPage> createState() => _DashboardFinanPageState();
}

class _DashboardFinanPageState extends State<DashboardFinanPage> {
  final MovimentacaoRepository _movimentacaoRepository = MovimentacaoRepository();
  Map<String, double> _resumoFinanceiro = {
    'receitas': 0.0,
    'despesas': 0.0,
    'saldo': 0.0,
  };

  @override
  void initState() {
    super.initState();
    _carregarResumoFinanceiro();
  }

  void _carregarResumoFinanceiro() async {
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

  @override
  Widget build(BuildContext context) {
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
            const Text(
              "Dashboard Financeiro",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Olá, Rafael!!\nAqui está seus dados financeiros\nde forma clara e organizada.",
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
              _resumoFinanceiro['saldo']! >= 0 ? "+ ${_resumoFinanceiro['saldo']!.toStringAsFixed(2)}" : "${_resumoFinanceiro['saldo']!.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 18,
                color: _resumoFinanceiro['saldo']! >= 0 ? Colors.lightGreenAccent : Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Gráfico
            Container(
              height: 160,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF327355),
                borderRadius: BorderRadius.circular(12),
              ),
              child: LineChart(
                LineChartData(
                  backgroundColor: const Color(0xFF327355),
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 20,
                        getTitlesWidget: (value, meta) {
                          final meses = [
                            "JAN",
                            "FEV",
                            "MAR",
                            "ABR",
                            "MAI",
                            "JUN",
                            "JUL",
                            "AGO",
                            "SET",
                            "OUT",
                            "NOV",
                            "DEZ"
                          ];
                          return Text(
                            meses[value.toInt() % 12],
                            style: const TextStyle(
                                color: Colors.white, fontSize: 10),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 2),
                        FlSpot(1, 1.5),
                        FlSpot(2, 3),
                        FlSpot(3, 2.2),
                        FlSpot(4, 2.8),
                        FlSpot(5, 3.5),
                        FlSpot(6, 2.5),
                        FlSpot(7, 3.8),
                        FlSpot(8, 4.2),
                        FlSpot(9, 4.8),
                        FlSpot(10, 5),
                        FlSpot(11, 6),
                      ],
                      isCurved: true,
                      color: Colors.lightGreenAccent,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Cards Renda / Despesa
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                cardInfo("Renda", "R\$ ${_resumoFinanceiro['receitas']!.toStringAsFixed(2)}", "+${_resumoFinanceiro['receitas']!.toStringAsFixed(2)}", Colors.green, true),
                cardInfo("Despesa", "R\$ ${_resumoFinanceiro['despesas']!.toStringAsFixed(2)}", "-${_resumoFinanceiro['despesas']!.toStringAsFixed(2)}", Colors.red, false),
              ],
            ),
            const SizedBox(height: 20),

            // Lista de Projetos
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF327355),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView(
                  children: const [
                    projetoItem("Janeiro", "50,000", "Completo", Colors.green),
                    projetoItem("Fevereiro", "30,000", "Completo", Colors.green),
                    projetoItem("Março", "5,000", "Completo", Colors.green),
                    projetoItem(
                        "Abril", "70,000", "Em andamento", Colors.orange),
                  ],
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
          "\$$valor",
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
