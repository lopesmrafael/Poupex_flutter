import 'package:flutter/material.dart';
import '../Model/dicas_item.dart';
import '../repository/dicas_repository.dart';
import '../repository/theme_manager.dart';
import 'ConfiguracoesPage.dart';
import 'PerfilPage.dart';

class DicasFinancasPage extends StatefulWidget {
  const DicasFinancasPage({super.key});

  @override
  State<DicasFinancasPage> createState() => _DicasFinancasPageState();
}

class _DicasFinancasPageState extends State<DicasFinancasPage> {
  final DicasRepository _repository = DicasRepository();
  List<Map<String, dynamic>> dicas = [];

  @override
  void initState() {
    super.initState();
    _carregarDicas();
  }

  void _carregarDicas() async {
    try {
      final dicasData = await _repository.getDicas();
      setState(() {
        dicas = dicasData;
      });
    } catch (e) {
      setState(() {
        dicas = _getDicasPadrao();
      });
    }
  }

  List<Map<String, dynamic>> _getDicasPadrao() {
    return [
      {
        'titulo': 'Investimentos',
        'descricao': 'Invista de forma inteligente e coloque seu capital, potencializando seus retornos.',
        'icone': 'assets/iconsDicas/investimento.png',
      },
      {
        'titulo': 'Organização Financeira',
        'descricao': 'Elabore um orçamento mensal, registrando todas as suas receitas e despesas.',
        'icone': 'assets/iconsDicas/organizacao.png',
      },
      {
        'titulo': 'Reserva de Emergência',
        'descricao': 'Guarde pelo menos de 3 a 6 meses do seu custo de vida em uma aplicação de fácil acesso.',
        'icone': 'assets/iconsDicas/reserva_emergencia.png',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeManager.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.keyboard_backspace),
          onPressed: () => Navigator.pop(context),
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
      body: dicas.isEmpty
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: dicas.length,
              itemBuilder: (context, index) {
                final dica = dicas[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  color: ThemeManager.cardColor,
                  child: ListTile(
                    leading: Image.asset(
                      dica['icone'] ?? 'assets/iconsDicas/investimento.png',
                      width: 50,
                      height: 50,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.monetization_on, size: 50, color: Colors.white);
                      },
                    ),
                    title: Text(
                      dica['titulo'] ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      dica['descricao'] ?? '',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                );
              },
            ),
    );
  }
}