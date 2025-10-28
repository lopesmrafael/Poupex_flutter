import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../repository/movimentacao_repository.dart';
import '../repository/auth_repository.dart';
import '../repository/theme_manager.dart';
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
  List<Map<String, dynamic>> _movimentacoes = [];
  Map<int, double> _saldosMensais = {};
  List<FlSpot> _dadosGrafico = [];

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    await _carregarMovimentacoes();
    await _carregarResumoFinanceiro();
    _carregarNomeUsuario();
    _gerarDadosGrafico();
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

  Future<void> _carregarMovimentacoes() async {
    try {
      final movimentacoes = await _movimentacaoRepository.getMovimentacoes();
      setState(() {
        _movimentacoes = movimentacoes;
      });
    } catch (e) {
      print("Erro ao carregar movimentações: $e");
    }
  }

  void _gerarDadosGrafico() {
    Map<int, double> saldoPorMes = {};
    
    // Calcular saldo por mês
    for (var mov in _movimentacoes) {
      try {
        DateTime data;
        if (mov['data'] is String) {
          data = DateTime.parse(mov['data']);
        } else {
          data = DateTime.now();
        }
        
        int mes = data.month;
        double valor = (mov['valor'] is num) ? mov['valor'].toDouble() : 0.0;
        
        if (mov['tipo'] == 'receita') {
          saldoPorMes[mes] = (saldoPorMes[mes] ?? 0.0) + valor;
        } else if (mov['tipo'] == 'despesa') {
          saldoPorMes[mes] = (saldoPorMes[mes] ?? 0.0) - valor;
        }
      } catch (e) {
        print('Erro ao processar movimentação: $e');
      }
    }
    
    // Gerar pontos do gráfico
    List<FlSpot> spots = [];
    
    if (saldoPorMes.isEmpty) {
      // Gráfico vazio
      for (int mes = 0; mes < 6; mes++) {
        spots.add(FlSpot(mes.toDouble(), 0));
      }
    } else {
      double saldoAcumulado = 0;
      for (int mes = 1; mes <= 12; mes++) {
        saldoAcumulado += saldoPorMes[mes] ?? 0.0;
        spots.add(FlSpot(mes.toDouble() - 1, saldoAcumulado));
      }
    }
    
    setState(() {
      _dadosGrafico = spots;
      _saldosMensais = saldoPorMes;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mesAtual = DateTime.now().month;
    final meses = [
      "Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho",
      "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"
    ];

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
            icon: Icon(Icons.refresh, color: ThemeManager.textColor),
            onPressed: () {
              _carregarDados();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Dados atualizados!'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.settings, color: ThemeManager.textColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ConfiguracoesPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.person, color: ThemeManager.textColor),
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
              style: TextStyle(
                fontSize: 20,
                color: ThemeManager.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Aqui estão seus dados financeiros\nde forma clara e organizada.",
              textAlign: TextAlign.center,
              style: TextStyle(color: ThemeManager.subtitleColor, fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              "R\$ ${_resumoFinanceiro['saldo']!.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: ThemeManager.textColor,
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
                color: ThemeManager.cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    drawHorizontalLine: true,
                    horizontalInterval: (_resumoFinanceiro['saldo']!.abs() > 0 ? _resumoFinanceiro['saldo']!.abs() / 4 : 1000),
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.white.withOpacity(0.2),
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Colors.white.withOpacity(0.2),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            'R\$${value.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          );
                        },
                      ),
                    ),
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
                          if (index >= 0 && index < 12) {
                            final mesesAbrev = ['JAN', 'FEV', 'MAR', 'ABR', 'MAI', 'JUN', 
                                               'JUL', 'AGO', 'SET', 'OUT', 'NOV', 'DEZ'];
                            return Text(
                              mesesAbrev[index],
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
                      spots: _dadosGrafico,
                      isCurved: true,
                      color: _resumoFinanceiro['saldo']! >= 0 
                          ? Colors.lightGreenAccent 
                          : Colors.redAccent,
                      barWidth: 3,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Colors.white,
                            strokeWidth: 2,
                            strokeColor: barData.color ?? Colors.blue,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: (_resumoFinanceiro['saldo']! >= 0 
                            ? Colors.lightGreenAccent 
                            : Colors.redAccent).withOpacity(0.1),
                      ),
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

            // === Resumo de Movimentações Recentes ===
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ThemeManager.cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Movimentações Recentes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: _movimentacoes.isEmpty
                          ? const Center(
                              child: Text(
                                'Nenhuma movimentação encontrada\nCadastre suas primeiras transações!',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white70),
                              ),
                            )
                          : ListView.builder(
                              itemCount: _movimentacoes.length > 5 ? 5 : _movimentacoes.length,
                              itemBuilder: (context, index) {
                                final mov = _movimentacoes[index];
                                final isReceita = mov['tipo'] == 'receita';
                                final valor = mov['valor']?.toDouble() ?? 0.0;
                                
                                return Card(
                                  color: Colors.white10,
                                  margin: const EdgeInsets.symmetric(vertical: 4),
                                  child: ListTile(
                                    leading: Icon(
                                      isReceita ? Icons.arrow_upward : Icons.arrow_downward,
                                      color: isReceita ? Colors.green : Colors.red,
                                    ),
                                    title: Text(
                                      mov['descricao'] ?? 'Sem descrição',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    subtitle: Text(
                                      mov['categoria'] ?? 'Geral',
                                      style: const TextStyle(color: Colors.white70),
                                    ),
                                    trailing: Text(
                                      '${isReceita ? '+' : '-'}R\$ ${valor.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: isReceita ? Colors.green : Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
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
      color: ThemeManager.cardColor,
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
