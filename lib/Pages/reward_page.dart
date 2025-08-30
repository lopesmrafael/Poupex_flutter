import 'package:flutter/material.dart';
import 'package:projeto_pity/Model/reward.dart';
import 'package:projeto_pity/Model/reward_itens.dart';
import 'package:projeto_pity/Widget/reward_card.dart';
import 'package:projeto_pity/Model/reward_iten.dart';


class RewardsPage extends StatelessWidget {
  const RewardsPage({super.key});

  final int userPoints = 7000;

  List<Reward> _getRewards() {
    return [
      RewardItem(
        titulo: "Vales para lojas online, serviços de streaming ou delivery",
        descricao: "Utilize pontos para cupons digitais.",
        pontos: 80000,
        imagem: "assets/meusPontos/vale.png",
      ),
      RewardItem(
        titulo:
            "Conteúdos sobre educação financeira, investimentos e planejamento",
        descricao: "Acesse materiais exclusivos.",
        pontos: 50000,
        imagem: "assets/meusPontos/conteudo.png",
      ),
      RewardItem(
        titulo: "Descontos em grandes redes de mercado",
        descricao: "Troque pontos por descontos reais.",
        pontos: 200000,
        imagem: "assets/meusPontos/tiket.png",
      ),
      RewardItem(
        titulo: "Assinatura Spotify, Netflix, Disney+",
        descricao: "Troque por serviços de streaming.",
        pontos: 150000,
        imagem: "assets/meusPontos/assinatura.png",
      ),
      RewardItem(
        titulo: "Plataformas como Udemy, Coursera e Alura",
        descricao: "Acesso a cursos online.",
        pontos: 200000,
        imagem: "assets/meusPontos/plataforma.png",
      ),
      RewardItem(
        titulo: "Atendimento com especialistas",
        descricao: "Consultoria especializada em finanças.",
        pontos: 200000,
        imagem: "assets/meusPontos/especialistas.png",
      ),
      RewardItem(
        titulo: "Eventos fechados sobre investimentos",
        descricao: "Workshops e palestras exclusivas.",
        pontos: 100000,
        imagem: "assets/meusPontos/eventos.png",
      ),
      RewardItem(
        titulo: "Entradas para eventos especiais",
        descricao: "Shows, teatros e muito mais.",
        pontos: 150000,
        imagem: "assets/meusPontos/valeEvento.png",
      ),
      RewardItem(
        titulo: "Descontos em fones, teclados e cadeiras ergonômicas",
        descricao: "Troque pontos por eletrônicos.",
        pontos: 180000,
        imagem: "assets/meusPontos/setup.png",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final rewards = _getRewards();

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
            Center(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 16,
                    ),
                    color: const Color(0xFF54A781),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Meus Pontos",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),

                        const Text(
                          "Aqui você encontra seus pontos, disponíveis para trocas!\n"
                          "Junte-se ao Meu-Finance para aproveitar o melhor com seus pontos",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                            height: 1.4,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Olá, Rafael!",  //aqui tem que implementar uma função para aparecer o nome do usuário da pagina do galdino
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${userPoints.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        fontSize: 42,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Text(
                                      "Pontos",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            Image.asset(
                              "assets/meusPontos/logoMeusPontos.png",
                              height: 90,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: rewards.length,
              itemBuilder: (context, index) {
                final reward = rewards[index];
                return RewardCard(reward: reward, userPoints: userPoints);
              },
            ),
          ],
        ),
      ),
    );
  }
}
