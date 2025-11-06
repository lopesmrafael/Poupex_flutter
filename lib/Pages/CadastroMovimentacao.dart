import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../repository/movimentacao_repository.dart';
import '../repository/theme_manager.dart';
import '../repository/achievement_system.dart';
import 'ConfiguracoesPage.dart';
import 'PerfilPage.dart';

class CadastroMovimentacao extends StatefulWidget {
  const CadastroMovimentacao({super.key});

  @override
  State<CadastroMovimentacao> createState() => _CadastroMovimentacaoState();
}

class _CadastroMovimentacaoState extends State<CadastroMovimentacao> {
  final descricaoController = TextEditingController();
  final valorController = TextEditingController();
  final dataController = TextEditingController();
  final MovimentacaoRepository _repository = MovimentacaoRepository();
  final AchievementSystem _achievementSystem = AchievementSystem();

  String? tipoSelecionado;
  DateTime dataSelecionada = DateTime.now();
  TimeOfDay? horaSelecionada;
  List<Map<String, dynamic>> transacoes = [];

  @override
  void initState() {
    super.initState();
    _carregarTransacoes();
    _atualizarDataHoraTexto();
  }

  void _carregarTransacoes() async {
    try {
      final movimentacoes = await _repository.getMovimentacoes();
      setState(() {
        transacoes = movimentacoes;
      });
    } catch (e) {}
  }

  void _atualizarDataHoraTexto() {
    final agora = DateTime.now();
    final formatada = DateFormat('dd/MM/yyyy HH:mm').format(agora);
    dataController.text = formatada;
  }

  double get totalReceitas => transacoes
      .where((t) => t["tipo"] == "receita")
      .fold(0.0, (s, t) => s + t["valor"]);

  double get totalDespesas => transacoes
      .where((t) => t["tipo"] == "despesa")
      .fold(0.0, (s, t) => s + t["valor"]);

  void cadastrarMovimentacao() async {
    final descricao = descricaoController.text.trim();
    final valorText = valorController.text.trim();

    if (descricao.isEmpty || valorText.isEmpty || tipoSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos!")),
      );
      return;
    }

    final valor = double.tryParse(valorText);
    if (valor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Valor inválido!")),
      );
      return;
    }

    // Usa a data atual + hora selecionada (ou atual)
    DateTime dataFinal = DateTime.now();
    if (horaSelecionada != null) {
      dataFinal = DateTime(
        dataFinal.year,
        dataFinal.month,
        dataFinal.day,
        horaSelecionada!.hour,
        horaSelecionada!.minute,
      );
    }

    try {
      await _repository.addMovimentacao(
        descricao: descricao,
        valor: valor.abs(),
        tipo: tipoSelecionado == "Entrada" ? "receita" : "despesa",
        data: dataFinal,
        categoria: 'Geral',
      );

      descricaoController.clear();
      valorController.clear();
      tipoSelecionado = null;
      horaSelecionada = null;
      _atualizarDataHoraTexto();
      _carregarTransacoes();

      // Verificar conquistas
      final novasConquistas = await _achievementSystem.verificarTransacao();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Movimentação cadastrada!")),
      );
      
      // Mostrar conquistas desbloqueadas
      for (String conquistaId in novasConquistas) {
        final conquista = AchievementSystem.conquistas[conquistaId];
        if (conquista != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('🏆 Conquista desbloqueada: ${conquista['titulo']}! +${conquista['pontos']} pontos'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $e")),
      );
    }
  }

  Future<void> _selecionarHora(BuildContext context) async {
    final TimeOfDay? selecionada = await showTimePicker(
      context: context,
      initialTime: horaSelecionada ?? TimeOfDay.now(),
    );

    if (selecionada != null) {
      setState(() {
        horaSelecionada = selecionada;
        final agora = DateTime.now();
        final dataFinal = DateTime(
          agora.year,
          agora.month,
          agora.day,
          selecionada.hour,
          selecionada.minute,
        );
        dataController.text = DateFormat('dd/MM/yyyy HH:mm').format(dataFinal);
      });
    }
  }

  String _formatarData(dynamic data) {
    try {
      if (data is String) {
        final parsed = DateTime.tryParse(data);
        if (parsed != null) {
          return DateFormat('dd/MM/yyyy HH:mm').format(parsed);
        }
      } else if (data is DateTime) {
        return DateFormat('dd/MM/yyyy HH:mm').format(data);
      }
    } catch (_) {}
    return data.toString();
  }

  void _abrirDepositoPersonalizado() {
    final descricaoCtrl = TextEditingController();
    final valorCtrl = TextEditingController();
    DateTime dataEscolhida = DateTime.now();
    TimeOfDay horaEscolhida = TimeOfDay.now();
    String tipoEscolhido = 'Entrada';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: const Color(0xFF327355),
              title: const Text('Depósito Personalizado', style: TextStyle(color: Colors.white)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: descricaoCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
                        labelStyle: TextStyle(color: Colors.white70),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      ),
                    ),
                    TextField(
                      controller: valorCtrl,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Valor',
                        labelStyle: TextStyle(color: Colors.white70),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: Text('Data: ${DateFormat('dd/MM/yyyy').format(dataEscolhida)}', style: const TextStyle(color: Colors.white)),
                      trailing: const Icon(Icons.calendar_today, color: Colors.white),
                      onTap: () async {
                        final data = await showDatePicker(
                          context: context,
                          initialDate: dataEscolhida,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (data != null) {
                          setStateDialog(() => dataEscolhida = data);
                        }
                      },
                    ),
                    ListTile(
                      title: Text('Hora: ${horaEscolhida.format(context)}', style: const TextStyle(color: Colors.white)),
                      trailing: const Icon(Icons.access_time, color: Colors.white),
                      onTap: () async {
                        final hora = await showTimePicker(
                          context: context,
                          initialTime: horaEscolhida,
                        );
                        if (hora != null) {
                          setStateDialog(() => horaEscolhida = hora);
                        }
                      },
                    ),
                    DropdownButtonFormField<String>(
                      value: tipoEscolhido,
                      dropdownColor: const Color(0xFF327355),
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Tipo',
                        labelStyle: TextStyle(color: Colors.white70),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Entrada', child: Text('Entrada (Receita)')),
                        DropdownMenuItem(value: 'Saída', child: Text('Saída (Despesa)')),
                      ],
                      onChanged: (valor) => setStateDialog(() => tipoEscolhido = valor!),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (descricaoCtrl.text.isNotEmpty && valorCtrl.text.isNotEmpty) {
                      final valor = double.tryParse(valorCtrl.text);
                      if (valor != null) {
                        final dataFinal = DateTime(
                          dataEscolhida.year,
                          dataEscolhida.month,
                          dataEscolhida.day,
                          horaEscolhida.hour,
                          horaEscolhida.minute,
                        );
                        
                        await _repository.addMovimentacao(
                          descricao: descricaoCtrl.text,
                          valor: valor.abs(),
                          tipo: tipoEscolhido == 'Entrada' ? 'receita' : 'despesa',
                          data: dataFinal,
                          categoria: 'Personalizado',
                        );
                        
                        _carregarTransacoes();
                        
                        // Verificar conquistas
                        final novasConquistas = await _achievementSystem.verificarTransacao();
                        
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Depósito personalizado cadastrado!')),
                        );
                        
                        // Mostrar conquistas desbloqueadas
                        for (String conquistaId in novasConquistas) {
                          final conquista = AchievementSystem.conquistas[conquistaId];
                          if (conquista != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('🏆 Conquista: ${conquista['titulo']}! +${conquista['pontos']} pontos'),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        }
                      }
                    }
                  },
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeManager.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.keyboard_backspace),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Histórico de Atividades",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ThemeManager.textColor,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: ThemeManager.cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Cadastrar Movimentação",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descricaoController,
                      decoration: InputDecoration(
                        labelText: "Descrição",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: valorController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Valor",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: dataController,
                      readOnly: true,
                      onTap: () => _selecionarHora(context),
                      decoration: InputDecoration(
                        labelText: "Hora",
                        suffixIcon: const Icon(Icons.access_time),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: tipoSelecionado,
                      decoration: InputDecoration(
                        labelText: "Tipo de Movimentação",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "Entrada",
                          child: Text("Entrada (Receita)"),
                        ),
                        DropdownMenuItem(
                          value: "Saída",
                          child: Text("Saída (Despesa)"),
                        ),
                      ],
                      onChanged: (valor) {
                        setState(() {
                          tipoSelecionado = valor;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF327355),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: cadastrarMovimentacao,
                            child: const Text("CADASTRAR"),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E5A3E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: _abrirDepositoPersonalizado,
                          child: const Icon(Icons.schedule, size: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Transações",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: ThemeManager.cardColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: transacoes.map((t) {
                  final isReceita = t["tipo"] == "receita";
                  return ListTile(
                    title: Text(
                      t["descricao"],
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: t["data"] != null
                        ? Text(
                            _formatarData(t["data"]),
                            style: const TextStyle(color: Colors.white70),
                          )
                        : null,
                    trailing: Text(
                      "${isReceita ? "+" : "-"}R\$${t["valor"].toStringAsFixed(2)} ${isReceita ? "▲" : "▼"}",
                      style: TextStyle(
                        color: isReceita ? Colors.greenAccent : Colors.redAccent,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Transações de Receitas e Despesas",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ThemeManager.textColor,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ThemeManager.cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    "↑ +R\$${totalReceitas.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "↓ -R\$${totalDespesas.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
