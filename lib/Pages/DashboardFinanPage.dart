import 'package:flutter/material.dart';


class DashboardFinanPage extends StatelessWidget {
  const DashboardFinanPage({super.key});


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
              "Olá, Usuario!\nAqui está seus dados financeiros\nde forma clara e organizada.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              "\$999,999",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Text(
              "+1.000",
              style: TextStyle(
                fontSize: 18,
                color: Colors.lightGreenAccent,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF327355),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  "Gráfico",
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                cardInfo("Renda", "\$500,000", "+60.10", Colors.green),
                cardInfo("Despesa", "\$500,000", "-60.10", Colors.red),
              ],
            ),
            const SizedBox(height: 20),
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
                    projetoItem("Abril", "70,000", "Em andamento", Colors.orange),
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

Widget cardInfo(String titulo, String valor, String variacao, Color cor) {
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
        Text(
          variacao,
          style: TextStyle(color: cor, fontSize: 14),
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
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
