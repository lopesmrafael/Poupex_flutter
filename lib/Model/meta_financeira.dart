class MetaFinanceira {
  final String id;
  final String titulo;
  final String? descricao;
  final double valorAlvo;
  final double valorAtual;
  final DateTime dataInicio;
  final DateTime dataLimite;
  final StatusMeta status;
  final CategoriaMeta categoria;
  final DateTime? dataAtualizacao;
  final DateTime dataCriacao;


  const MetaFinanceira({
    required this.id,
    required this.titulo,
    this.descricao,
    required this.valorAlvo,
    required this.valorAtual,
    required this.dataInicio,
    required this.dataLimite,
    required this.status,
    required this.categoria,
    this.dataAtualizacao,
    required this.dataCriacao,
  });


  // Calcula o progresso da meta (0.0 a 1.0)
  double get progresso {
    if (valorAlvo <= 0) return 0.0;
    return (valorAtual / valorAlvo).clamp(0.0, 1.0);
  }


  // Calcula o valor restante para atingir a meta
  double get valorRestante {
    return (valorAlvo - valorAtual).clamp(0.0, double.infinity);
  }


  // Verifica se a meta foi concluída
  bool get isConcluida => valorAtual >= valorAlvo;


  // Verifica se a meta está vencida
  bool get isVencida => DateTime.now().isAfter(dataLimite) && !isConcluida;


  // Calcula dias restantes
  int get diasRestantes {
    final diferenca = dataLimite.difference(DateTime.now()).inDays;
    return diferenca > 0 ? diferenca : 0;
  }


  // Factory para criar do JSON
  factory MetaFinanceira.fromJson(Map<String, dynamic> json) {
    return MetaFinanceira(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      descricao: json['descricao'] as String?,
      valorAlvo: (json['valorAlvo'] as num).toDouble(),
      valorAtual: (json['valorAtual'] as num).toDouble(),
      dataInicio: DateTime.parse(json['dataInicio'] as String),
      dataLimite: DateTime.parse(json['dataLimite'] as String),
      status: StatusMeta.fromString(json['status'] as String),
      categoria: CategoriaMeta.fromString(json['categoria'] as String),
      dataAtualizacao: json['dataAtualizacao'] != null
          ? DateTime.parse(json['dataAtualizacao'] as String)
          : null,
      dataCriacao: DateTime.parse(json['dataCriacao'] as String),
    );
  }


  // Converter para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'valorAlvo': valorAlvo,
      'valorAtual': valorAtual,
      'dataInicio': dataInicio.toIso8601String(),
      'dataLimite': dataLimite.toIso8601String(),
      'status': status.value,
      'categoria': categoria.value,
      'dataAtualizacao': dataAtualizacao?.toIso8601String(),
      'dataCriacao': dataCriacao.toIso8601String(),
    };
  }


  // Método copyWith para imutabilidade
  MetaFinanceira copyWith({
    String? id,
    String? titulo,
    String? descricao,
    double? valorAlvo,
    double? valorAtual,
    DateTime? dataInicio,
    DateTime? dataLimite,
    StatusMeta? status,
    CategoriaMeta? categoria,
    DateTime? dataAtualizacao,
    DateTime? dataCriacao,
  }) {
    return MetaFinanceira(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      valorAlvo: valorAlvo ?? this.valorAlvo,
      valorAtual: valorAtual ?? this.valorAtual,
      dataInicio: dataInicio ?? this.dataInicio,
      dataLimite: dataLimite ?? this.dataLimite,
      status: status ?? this.status,
      categoria: categoria ?? this.categoria,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
      dataCriacao: dataCriacao ?? this.dataCriacao,
    );
  }


  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MetaFinanceira && other.id == id;
  }


  @override
  int get hashCode => id.hashCode;


  @override
  String toString() {
    return 'MetaFinanceira{id: $id, titulo: $titulo, progresso: ${(progresso * 100).toStringAsFixed(1)}%}';
  }
}


// Enum para status da meta
enum StatusMeta {
  ativa('ativa'),
  pausada('pausada'),
  concluida('concluida'),
  cancelada('cancelada');


  const StatusMeta(this.value);
  final String value;


  static StatusMeta fromString(String value) {
    return StatusMeta.values.firstWhere(
      (status) => status.value == value,
      orElse: () => StatusMeta.ativa,
    );
  }


  String get displayName {
    switch (this) {
      case StatusMeta.ativa:
        return 'Ativa';
      case StatusMeta.pausada:
        return 'Pausada';
      case StatusMeta.concluida:
        return 'Concluída';
      case StatusMeta.cancelada:
        return 'Cancelada';
    }
  }
}


// Enum para categoria da meta
enum CategoriaMeta {
  economia('economia'),
  investimento('investimento'),
  aposentadoria('aposentadoria'),
  emergencia('emergencia'),
  compra('compra'),
  viagem('viagem'),
  educacao('educacao'),
  casa('casa'),
  saude('saude'),
  outros('outros');


  const CategoriaMeta(this.value);
  final String value;


  static CategoriaMeta fromString(String value) {
    return CategoriaMeta.values.firstWhere(
      (categoria) => categoria.value == value,
      orElse: () => CategoriaMeta.outros,
    );
  }


  String get displayName {
    switch (this) {
      case CategoriaMeta.economia:
        return 'Economia';
      case CategoriaMeta.investimento:
        return 'Investimento';
      case CategoriaMeta.aposentadoria:
        return 'Aposentadoria';
      case CategoriaMeta.emergencia:
        return 'Reserva de Emergência';
      case CategoriaMeta.compra:
        return 'Compra';
      case CategoriaMeta.viagem:
        return 'Viagem';
      case CategoriaMeta.educacao:
        return 'Educação';
      case CategoriaMeta.casa:
        return 'Casa';
      case CategoriaMeta.saude:
        return 'Saúde';
      case CategoriaMeta.outros:
        return 'Outros';
    }
  }


  String get icon {
    switch (this) {
      case CategoriaMeta.economia:
        return '💰';
      case CategoriaMeta.investimento:
        return '📈';
      case CategoriaMeta.aposentadoria:
        return '👴';
      case CategoriaMeta.emergencia:
        return '🆘';
      case CategoriaMeta.compra:
        return '🛒';
      case CategoriaMeta.viagem:
        return '✈️';
      case CategoriaMeta.educacao:
        return '📚';
      case CategoriaMeta.casa:
        return '🏠';
      case CategoriaMeta.saude:
        return '⚕️';
      case CategoriaMeta.outros:
        return '📋';
    }
  }
}


// DTO para criar uma nova meta
class CriarMetaFinanceiraDto {
  final String titulo;
  final String? descricao;
  final double valorAlvo;
  final double valorInicial;
  final DateTime dataInicio;
  final DateTime dataLimite;
  final CategoriaMeta categoria;


  const CriarMetaFinanceiraDto({
    required this.titulo,
    this.descricao,
    required this.valorAlvo,
    this.valorInicial = 0.0,
    required this.dataInicio,
    required this.dataLimite,
    required this.categoria,
  });


  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'descricao': descricao,
      'valorAlvo': valorAlvo,
      'valorInicial': valorInicial,
      'dataInicio': dataInicio.toIso8601String(),
      'dataLimite': dataLimite.toIso8601String(),
      'categoria': categoria.value,
    };
  }
}


// DTO para atualizar progresso da meta
class AtualizarProgressoDto {
  final String metaId;
  final double novoValor;
  final String? observacao;


  const AtualizarProgressoDto({
    required this.metaId,
    required this.novoValor,
    this.observacao,
  });


  Map<String, dynamic> toJson() {
    return {
      'metaId': metaId,
      'novoValor': novoValor,
      'observacao': observacao,
    };
  }
}
