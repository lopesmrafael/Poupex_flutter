import 'package:flutter/material.dart';
import '../Model/dicas_item.dart';

class DicasFinancasPage extends StatelessWidget {
  const DicasFinancasPage({super.key});

  List<DicaFinancas> _getDicas() {
    return [
      DicaFinancas(
        titulo: "Investimentos",
        descricao:
            "Invista de forma inteligente e coloque seu capital, potencializando seus retornos e fazendo seu dinheiro trabalhar para você.",
        imagem: "assets/iconsDicas/investimento.png",
      ),
      DicaFinancas(
        titulo: "Organização Financeira",
        descricao:
            "Elabore um orçamento mensal, registrando todas as suas receitas e despesas, definindo metas financeiras claras, como economizar ou investir para o futuro.",
        imagem: "assets/iconsDicas/investimento.png",
      ),
      DicaFinancas(
        titulo: "Educação Financeira",
        descricao:
            "Dedique-se a aprender mais sobre investimentos, planejamento financeiro e hábitos saudáveis de gestão de dinheiro.",
        imagem: "assets/iconsDicas/investimento.png",
      ),
      DicaFinancas(
        titulo: "Golpes Financeiros",
        descricao:
            "Nunca compartilhe informações financeiras pessoais ou realize transações financeiras em sites não seguros.",
        imagem: "assets/iconsDicas/investimento.png",
      ),
      DicaFinancas(
        titulo: "Reserva de Emergência",
        descricao:
            "Guarde pelo menos de 3 a 6 meses do seu custo de vida em uma aplicação de fácil acesso. Isso garante que você tenha segurança em caso de imprevistos.",
        imagem: "assets/iconsDicas/investimento.png",
      ),
      DicaFinancas(
        titulo: "Compras Impulsivas",
        descricao:
            "Antes de gastar, pergunte-se 'Eu realmente preciso disso?' Este gasto está alinhado com meus objetivos financeiros?",
        imagem: "assets/iconsDicas/investimento.png",
      ),
      DicaFinancas(
        titulo: "Aproveite Cashback",
        descricao:
            "Utilize programas de cashback e aproveite o retorno em compras do dia a dia. Mas cuidado para não gastar mais do que pode economizar.",
        imagem: "assets/iconsDicas/investimento.png",
      ),
      DicaFinancas(
        titulo: "Aumente sua Renda",
        descricao:
            "Busque formas de ganhar dinheiro extra, como freelances, trabalhos online e investimentos que ofereçam retorno seguro.",
        imagem: "assets/iconsDicas/investimento.png",
      ),
      DicaFinancas(
        titulo: "Eduque-se Financeiramente",
        descricao:
            "O aprendizado nunca acaba! Leia livros, acompanhe especialistas, faça cursos e participe de grupos de estudo sobre finanças.",
        imagem: "assets/iconsDicas/investimento.png",
      ),
      DicaFinancas(
        titulo: "Evite Pegar Juros Desnecessários",
        descricao:
            "Sempre que possível, pague a valor total da fatura do cartão de crédito e evite parcelamentos com juros altos.",
        imagem: "assets/iconsDicas/investimento.png",
      ),
      DicaFinancas(
        titulo: "Pratique o Consumo Consciente",
        descricao:
            "Antes de comprar algo, pergunte-se se realmente precisa. Avalie a qualidade, a necessidade e o impacto da compra no seu orçamento antes de tomar uma decisão.",
        imagem: "assets/iconsDicas/investimento.png",
      ),
      DicaFinancas(
        titulo: "Invista em sua Capacitação Profissional",
        descricao:
            "Quanto mais qualificado você for, maiores serão suas oportunidades e rendas. Veja cursos como um investimento no seu futuro.",
        imagem: "assets/iconsDicas/investimento.png",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final dicas = _getDicas();

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
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: dicas.length,
        itemBuilder: (context, index) {
          final dica = dicas[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            color: const Color(0xFF4F9977),
            child: ListTile(
              leading: Image.asset(dica.imagem, width: 80, height: 80),
              title: Text(
                dica.titulo,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(dica.descricao),
            ),
          );
        },
      ),
    );
  }
}
