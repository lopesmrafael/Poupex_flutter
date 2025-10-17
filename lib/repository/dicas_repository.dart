class DicasRepository {
  static List<Map<String, dynamic>> _dicas = [
    {
      'titulo': 'Investimentos Inteligentes',
      'descricao': 'Diversifique seus investimentos entre renda fixa e variável. Comece com pequenos valores e aumente gradualmente.',
      'categoria': 'investimento',
      'icone': 'assets/iconsDicas/investimento.png',
    },
    {
      'titulo': 'Organização Financeira',
      'descricao': 'Elabore um orçamento mensal detalhado. Registre todas as receitas e despesas para ter controle total.',
      'categoria': 'planejamento',
      'icone': 'assets/iconsDicas/organizacao.png',
    },
    {
      'titulo': 'Reserva de Emergência',
      'descricao': 'Mantenha de 3 a 6 meses de gastos em uma aplicação de fácil acesso. É sua segurança financeira.',
      'categoria': 'emergencia',
      'icone': 'assets/iconsDicas/reserva_emergencia.png',
    },
    {
      'titulo': 'Controle de Gastos',
      'descricao': 'Antes de comprar, pergunte-se: "Eu realmente preciso disso?". Evite compras por impulso.',
      'categoria': 'economia',
      'icone': 'assets/iconsDicas/controle_gastos.png',
    },
    {
      'titulo': 'Educação Financeira',
      'descricao': 'Invista em conhecimento. Leia livros, faça cursos e acompanhe especialistas em finanças.',
      'categoria': 'educacao',
      'icone': 'assets/iconsDicas/educacao.png',
    },
    {
      'titulo': 'Renda Extra',
      'descricao': 'Busque formas de aumentar sua renda: freelances, vendas online ou monetize seus hobbies.',
      'categoria': 'renda',
      'icone': 'assets/iconsDicas/renda_extra.png',
    },
    {
      'titulo': 'Cartão de Crédito',
      'descricao': 'Use com responsabilidade. Pague sempre o valor total da fatura para evitar juros altos.',
      'categoria': 'credito',
      'icone': 'assets/iconsDicas/cartao_credito.png',
    },
    {
      'titulo': 'Metas Financeiras',
      'descricao': 'Defina objetivos claros e prazos realistas. Metas específicas motivam mais que desejos vagos.',
      'categoria': 'metas',
      'icone': 'assets/iconsDicas/metas.png',
    },
    {
      'titulo': 'Aposentadoria',
      'descricao': 'Comece a se planejar cedo. Quanto antes começar, menor será o valor mensal necessário.',
      'categoria': 'aposentadoria',
      'icone': 'assets/iconsDicas/aposentadoria.png',
    },
    {
      'titulo': 'Negociação de Dívidas',
      'descricao': 'Se estiver endividado, negocie. Muitas empresas oferecem descontos para pagamento à vista.',
      'categoria': 'dividas',
      'icone': 'assets/iconsDicas/negociacao.png',
    },
  ];

  Future<List<Map<String, dynamic>>> getDicas() async {
    await Future.delayed(Duration(milliseconds: 300));
    return List.from(_dicas);
  }

  Future<List<Map<String, dynamic>>> getDicasPorCategoria(String categoria) async {
    await Future.delayed(Duration(milliseconds: 200));
    return _dicas.where((dica) => dica['categoria'] == categoria).toList();
  }

  Future<void> marcarDicaComoLida(int index) async {
    await Future.delayed(Duration(milliseconds: 100));
    if (index >= 0 && index < _dicas.length) {
      _dicas[index]['lida'] = true;
    }
  }

  Future<void> adicionarDica(Map<String, dynamic> dica) async {
    await Future.delayed(Duration(milliseconds: 200));
    dica['id'] = DateTime.now().millisecondsSinceEpoch.toString();
    _dicas.add(dica);
  }
}