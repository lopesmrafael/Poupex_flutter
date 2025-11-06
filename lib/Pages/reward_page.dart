import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repository/theme_manager.dart';
import '../repository/achievement_system.dart';



// 🔹 Página principal dos desafios
class DesafiosPage extends StatefulWidget {
  const DesafiosPage({super.key});

  @override
  State<DesafiosPage> createState() => _DesafiosPageState();
}

class _DesafiosPageState extends State<DesafiosPage> {
  int userPoints = 0;
  final AchievementSystem _achievementSystem = AchievementSystem();
  List<String> conquistasDesbloqueadas = [];

  final List<Map<String, dynamic>> conquistas = [
    {
      'id': 'primeira_transacao',
      'titulo': 'Primeira Transação',
      'descricao': 'Registre sua primeira movimentação',
      'pontos': 100,
      'imagem': 'assets/meusPontos/vale.png',
    },
    {
      'id': 'cinco_transacoes',
      'titulo': '5 Transações',
      'descricao': 'Registre 5 movimentações',
      'pontos': 200,
      'imagem': 'assets/meusPontos/valeEvento.png',
    },
    {
      'id': 'primeira_meta',
      'titulo': 'Primeira Meta',
      'descricao': 'Crie sua primeira meta financeira',
      'pontos': 150,
      'imagem': 'assets/meusPontos/setup.png',
    },
    {
      'id': 'orcamento_criado',
      'titulo': 'Orçamento Criado',
      'descricao': 'Configure seu primeiro orçamento',
      'pontos': 120,
      'imagem': 'assets/meusPontos/tiket.png',
    },
    {
      'id': 'dez_transacoes',
      'titulo': '10 Transações',
      'descricao': 'Registre 10 movimentações',
      'pontos': 300,
      'imagem': 'assets/meusPontos/vale.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    _carregarPontosEDesafios();
  }

  void _carregarPontosEDesafios() async {
    userPoints = await _achievementSystem.getPontos();
    conquistasDesbloqueadas = await _achievementSystem.getConquistasDesbloqueadas();
    setState(() {});
  }

  // Conquistas são desbloqueadas automaticamente

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeManager.backgroundColor,
      appBar: AppBar(
        title: Text(
          "Desafios do App",
          style: TextStyle(
            color: ThemeManager.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: ThemeManager.appBarColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Cabeçalho de pontos acumulados
            Container(
              decoration: BoxDecoration(
                color: ThemeManager.cardColor,
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
            // Lista de conquistas
            Expanded(
              child: ListView.builder(
                itemCount: conquistas.length,
                itemBuilder: (context, index) {
                  final conquista = conquistas[index];
                  final isDesbloqueada = conquistasDesbloqueadas.contains(conquista['id']);
                  
                  return Card(
                    color: ThemeManager.cardColor,
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
                              conquista['imagem'],
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
                                  conquista['titulo'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  conquista['descricao'],
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  '${conquista['pontos']} pontos',
                                  style: const TextStyle(
                                    color: Colors.amber,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isDesbloqueada ? Colors.green : Colors.grey,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              isDesbloqueada ? '✓ Concluída' : 'Bloqueada',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
