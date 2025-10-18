import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 🔹 Repositório local de pontos e desafios concluídos
class PontosRepository {
  static const String _keyPontos = 'pontosAcumulados';
  static const String _keyDesafios = 'desafiosConcluidos';

  Future<int> getPontos() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyPontos) ?? 0;
  }

  Future<void> adicionarPontos(int pontos) async {
    final prefs = await SharedPreferences.getInstance();
    final atual = prefs.getInt(_keyPontos) ?? 0;
    await prefs.setInt(_keyPontos, atual + pontos);
  }

  Future<void> resetarPontos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyPontos);
    await prefs.remove(_keyDesafios);
  }

  Future<void> salvarDesafiosConcluidos(List<String> titulosConcluidos) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyDesafios, titulosConcluidos);
  }

  Future<List<String>> getDesafiosConcluidos() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyDesafios) ?? [];
  }
}

// 🔹 Modelo de desafio
class Desafio {
  final String titulo;
  final String descricao;
  final int pontos;
  final String imagem;
  bool concluido;

  Desafio({
    required this.titulo,
    required this.descricao,
    required this.pontos,
    required this.imagem,
    this.concluido = false,
  });
}

// 🔹 Card visual de cada desafio
class DesafioCard extends StatelessWidget {
  final Desafio desafio;
  final int userPoints;
  final VoidCallback onConcluir;

  const DesafioCard({
    super.key,
    required this.desafio,
    required this.userPoints,
    required this.onConcluir,
  });

  @override
  Widget build(BuildContext context) {
    final bool podeConcluir = !desafio.concluido;

    return Card(
      color: const Color(0xFF4A9073),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                desafio.imagem,
                width: 48,
                height: 48,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    desafio.titulo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desafio.descricao,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: podeConcluir ? onConcluir : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: podeConcluir ? Colors.white : Colors.grey[400],
                foregroundColor: const Color(0xFF327355),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(podeConcluir ? "Concluir" : "Feito"),
            ),
          ],
        ),
      ),
    );
  }
}

// 🔹 Página principal dos desafios
class DesafiosPage extends StatefulWidget {
  const DesafiosPage({super.key});

  @override
  State<DesafiosPage> createState() => _DesafiosPageState();
}

class _DesafiosPageState extends State<DesafiosPage> {
  int userPoints = 0;
  final PontosRepository _pontosRepo = PontosRepository();

  final List<Desafio> desafios = [
    Desafio(
      titulo: "Registrar primeira transação",
      descricao: "Adicione sua primeira entrada ou saída no app.",
      pontos: 100,
      imagem: "assets/meusPontos/vale.png",
    ),
    Desafio(
      titulo: "Definir meta financeira",
      descricao: "Crie uma meta de economia para o mês. 200 pontos",
      pontos: 200,
      imagem: "assets/meusPontos/setup.png",
    ),
    Desafio(
      titulo: "Registrar 5 movimentações",
      descricao: "Mantenha seu controle financeiro atualizado. 300 pontos",
      pontos: 300,
      imagem: "assets/meusPontos/valeEvento.png",
    ),
    Desafio(
      titulo: "Acessar relatório financeiro",
      descricao: "Visualize o resumo das suas finanças. 150 pontos",
      pontos: 150,
      imagem: "assets/meusPontos/tiket.png",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _carregarPontosEDesafios();
  }

  void _carregarPontosEDesafios() async {
    userPoints = await _pontosRepo.getPontos();
    List<String> concluidos = await _pontosRepo.getDesafiosConcluidos();

    for (var desafio in desafios) {
      if (concluidos.contains(desafio.titulo)) {
        desafio.concluido = true;
      }
    }

    setState(() {});
  }

  void concluirDesafio(Desafio desafio) async {
    setState(() {
      desafio.concluido = true;
      userPoints += desafio.pontos;
    });

    await _pontosRepo.adicionarPontos(desafio.pontos);

    // Salvar desafio concluído
    List<String> concluidos = await _pontosRepo.getDesafiosConcluidos();
    if (!concluidos.contains(desafio.titulo)) {
      concluidos.add(desafio.titulo);
      await _pontosRepo.salvarDesafiosConcluidos(concluidos);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Desafio '${desafio.titulo}' concluído! +${desafio.pontos} pontos."),
        backgroundColor: const Color(0xFF327355),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF54A781),
      appBar: AppBar(
        title: const Text(
          "Desafios do App",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF327355),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Cabeçalho de pontos acumulados
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF327355),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: Column(
                children: [
                  const Text(
                    "🏅 Meus Pontos",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "$userPoints pontos",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Lista de desafios
            Expanded(
              child: ListView.builder(
                itemCount: desafios.length,
                itemBuilder: (context, index) {
                  final desafio = desafios[index];
                  return DesafioCard(
                    desafio: desafio,
                    userPoints: userPoints,
                    onConcluir: () => concluirDesafio(desafio),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
