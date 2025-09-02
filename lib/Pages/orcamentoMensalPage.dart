import 'package:flutter/material.dart';

class OrcamentoMensal extends StatefulWidget {
  const OrcamentoMensal({super.key});

  @override
  State<OrcamentoMensal> createState() => _OrcamentoMensalState();
}

class _OrcamentoMensalState extends State<OrcamentoMensal> {
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
  List<String> renda = [];
  List<String> gastosFixos = [];
  List<String> gastosVariaveis = [];

  void adicionarOrcamento() {
    setState(() {
      if (rendaDescController.text.isNotEmpty && rendaValorController.text.isNotEmpty) {
        renda.add("${rendaDescController.text}: ${rendaValorController.text}");
      }
      if (fixoDescController.text.isNotEmpty && fixoValorController.text.isNotEmpty) {
        gastosFixos.add("${fixoDescController.text}: ${fixoValorController.text}");
      }
      if (variavelDescController.text.isNotEmpty && variavelValorController.text.isNotEmpty) {
        gastosVariaveis.add("${variavelDescController.text}: ${variavelValorController.text}");
      }

      // Limpar campos
      rendaDescController.clear();
      rendaValorController.clear();
      fixoDescController.clear();
      fixoValorController.clear();
      variavelDescController.clear();
      variavelValorController.clear();
    });
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
                  backgroundColor: const Color(0xFF327355),
                  minimumSize: const Size(120, 40),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Confirmar"),
              ),
            ),
            const SizedBox(height: 20),
            if (renda.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFF327355), borderRadius: BorderRadius.circular(8)),
                child: Text("RENDA MENSAL:\n${renda.join('\n')}", style: const TextStyle(color: Colors.white)),
              ),
            const SizedBox(height: 12),
            if (gastosFixos.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFF327355), borderRadius: BorderRadius.circular(8)),
                child: Text("GASTOS FIXOS:\n${gastosFixos.join('\n')}", style: const TextStyle(color: Colors.white)),
              ),
            const SizedBox(height: 12),
            if (gastosVariaveis.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFF327355), borderRadius: BorderRadius.circular(8)),
                child: Text("GASTOS VARIÁVEIS:\n${gastosVariaveis.join('\n')}", style: const TextStyle(color: Colors.white)),
              ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
