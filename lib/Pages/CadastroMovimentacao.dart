import 'package:flutter/material.dart';
import '../repository/movimentacao_repository.dart';
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

  List<Map<String, dynamic>> transacoes = [];

  @override
  void initState() {
    super.initState();
    _carregarTransacoes();
  }

  void _carregarTransacoes() async {
    try {
      final movimentacoes = await _repository.getMovimentacoes();
      setState(() {
        transacoes = movimentacoes;
      });
    } catch (e) {
      // Ignora erro se não conseguir carregar
    }
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
    final data = dataController.text.trim();

    if (descricao.isEmpty || valorText.isEmpty || data.isEmpty) {
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

    final tipo = valor > 0 ? "receita" : "despesa";

    try {
      await _repository.addMovimentacao(
        descricao: descricao,
        valor: valor.abs(),
        tipo: tipo,
        data: DateTime.now(),
        categoria: 'Geral',
      );
      
      descricaoController.clear();
      valorController.clear();
      dataController.clear();
      
      _carregarTransacoes();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Movimentação cadastrada!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF54A781),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.keyboard_backspace),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Histórico de Atividades",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: const Color(0xFF6BB592),
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
                      decoration: InputDecoration(
                        labelText: "Data",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF327355),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size(double.infinity, 40),
                      ),
                      onPressed: cadastrarMovimentacao,
                      child: const Text("CADASTRAR"),
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
                color: const Color(0xFF3D8B6A),
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
                            t["data"],
                            style: const TextStyle(color: Colors.white70),
                          )
                        : null,
                    trailing: Text(
                      "${isReceita ? "+" : "-"}\$${t["valor"].toStringAsFixed(2)} ${isReceita ? "▲" : "▼"}",
                      style: TextStyle(
                        color: isReceita ? Colors.greenAccent : Colors.redAccent,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Transações de Receitas e Despesas",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF3D8B6A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    "↑ +\$${totalReceitas.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "↓ -\$${totalDespesas.toStringAsFixed(2)}",
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
