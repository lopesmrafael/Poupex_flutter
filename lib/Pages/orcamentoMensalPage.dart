import 'package:flutter/material.dart';
import '../repository/orcamento_repository_simple.dart';
import '../repository/theme_manager.dart';

class OrcamentoMensal extends StatefulWidget {
  const OrcamentoMensal({super.key});

  @override
  State<OrcamentoMensal> createState() => _OrcamentoMensalState();
}

class _OrcamentoMensalState extends State<OrcamentoMensal> {
  final OrcamentoRepositorySimple _repository = OrcamentoRepositorySimple();
  
  // Controllers para renda
  final TextEditingController rendaDescController = TextEditingController();
  final TextEditingController rendaValorController = TextEditingController();

  // Controllers para gastos fixos
  final TextEditingController fixoDescController = TextEditingController();
  final TextEditingController fixoValorController = TextEditingController();

  // Controllers para gastos variáveis
  final TextEditingController variavelDescController = TextEditingController();
  final TextEditingController variavelValorController = TextEditingController();

  // Listas para armazenar os dados
  List<Map<String, dynamic>> rendas = [];
  List<Map<String, dynamic>> gastosFixos = [];
  List<Map<String, dynamic>> gastosVariaveis = [];

  @override
  void initState() {
    super.initState();
    _carregarOrcamento();
  }

  void _carregarOrcamento() async {
    try {
      final orcamento = await _repository.getOrcamentoAtual();
      if (orcamento != null) {
        setState(() {
          rendas = List<Map<String, dynamic>>.from(orcamento['rendas'] ?? []);
          gastosFixos = List<Map<String, dynamic>>.from(orcamento['gastosFixos'] ?? []);
          gastosVariaveis = List<Map<String, dynamic>>.from(orcamento['gastosVariaveis'] ?? []);
        });
      }
    } catch (e) {
      // Ignora erro se não conseguir carregar
    }
  }

  void adicionarOrcamento() async {
    // Adicionar novos itens às listas
    if (rendaDescController.text.isNotEmpty && rendaValorController.text.isNotEmpty) {
      rendas.add({
        'descricao': rendaDescController.text,
        'valor': double.tryParse(rendaValorController.text) ?? 0.0,
      });
    }
    if (fixoDescController.text.isNotEmpty && fixoValorController.text.isNotEmpty) {
      gastosFixos.add({
        'descricao': fixoDescController.text,
        'valor': double.tryParse(fixoValorController.text) ?? 0.0,
      });
    }
    if (variavelDescController.text.isNotEmpty && variavelValorController.text.isNotEmpty) {
      gastosVariaveis.add({
        'descricao': variavelDescController.text,
        'valor': double.tryParse(variavelValorController.text) ?? 0.0,
      });
    }

    try {
      await _repository.salvarOrcamento(
        rendas: rendas,
        gastosFixos: gastosFixos,
        gastosVariaveis: gastosVariaveis,
      );
      
      setState(() {
        // Limpar campos
        rendaDescController.clear();
        rendaValorController.clear();
        fixoDescController.clear();
        fixoValorController.clear();
        variavelDescController.clear();
        variavelValorController.clear();
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Orçamento salvo com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeManager.backgroundColor,
      appBar: AppBar(
        title: Image.asset(
          "assets/titulo.jpg",
          height: 40,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
        backgroundColor: ThemeManager.appBarColor,
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
          const SizedBox(width: 12),
          IconButton(icon: const Icon(Icons.person), onPressed: () {}),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Orçamento Mensal",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Criando meu orçamento",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 12),
            const Text("Renda Mensal", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            TextField(controller: rendaDescController, decoration: const InputDecoration(hintText: "Descrição", filled: true, fillColor: Colors.white)),
            const SizedBox(height: 8),
            TextField(controller: rendaValorController, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: "Valor", filled: true, fillColor: Colors.white)),
            const SizedBox(height: 16),
            const Text("Gastos Fixos", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            TextField(controller: fixoDescController, decoration: const InputDecoration(hintText: "Descrição", filled: true, fillColor: Colors.white)),
            const SizedBox(height: 8),
            TextField(controller: fixoValorController, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: "Valor", filled: true, fillColor: Colors.white)),
            const SizedBox(height: 16),
            const Text("Gastos Variáveis", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            TextField(controller: variavelDescController, decoration: const InputDecoration(hintText: "Descrição", filled: true, fillColor: Colors.white)),
            const SizedBox(height: 8),
            TextField(controller: variavelValorController, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: "Valor", filled: true, fillColor: Colors.white)),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: adicionarOrcamento,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeManager.appBarColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(120, 40),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Confirmar"),
              ),
            ),
            const SizedBox(height: 20),
            if (rendas.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: ThemeManager.cardColor, borderRadius: BorderRadius.circular(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("RENDA MENSAL:", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ...rendas.map((item) => Text(
                      "${item['descricao']}: R\$ ${item['valor'].toStringAsFixed(2)}",
                      style: const TextStyle(color: Colors.white),
                    )),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            if (gastosFixos.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: ThemeManager.cardColor, borderRadius: BorderRadius.circular(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("GASTOS FIXOS:", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ...gastosFixos.map((item) => Text(
                      "${item['descricao']}: R\$ ${item['valor'].toStringAsFixed(2)}",
                      style: const TextStyle(color: Colors.white),
                    )),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            if (gastosVariaveis.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: ThemeManager.cardColor, borderRadius: BorderRadius.circular(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("GASTOS VARIÁVEIS:", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ...gastosVariaveis.map((item) => Text(
                      "${item['descricao']}: R\$ ${item['valor'].toStringAsFixed(2)}",
                      style: const TextStyle(color: Colors.white),
                    )),
                  ],
                ),
              ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
