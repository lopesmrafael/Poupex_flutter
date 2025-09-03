enum EventType {
  pagamento,
  gasto,
}


class FinancialEvent {
  final String id;
  final String description;
  final DateTime date;
  final EventType type;
  final double? amount;
  final DateTime createdAt;
  final DateTime updatedAt;


  FinancialEvent({
    required this.id,
    required this.description,
    required this.date,
    required this.type,
    this.amount,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();


  // Construtor para criar uma cópia com modificações
  FinancialEvent copyWith({
    String? id,
    String? description,
    DateTime? date,
    EventType? type,
    double? amount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FinancialEvent(
      id: id ?? this.id,
      description: description ?? this.description,
      date: date ?? this.date,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }


  // Converter para Map (para salvar no SharedPreferences ou banco de dados)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'date': date.millisecondsSinceEpoch,
      'type': type.toString().split('.').last,
      'amount': amount,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }


  // Criar objeto a partir de Map
  static FinancialEvent fromMap(Map<String, dynamic> map) {
    return FinancialEvent(
      id: map['id'] ?? '',
      description: map['description'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      type: EventType.values.firstWhere(
        (e) => e.toString().split('.').last == map['type'],
        orElse: () => EventType.gasto,
      ),
      amount: map['amount']?.toDouble(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }


  // Converter para JSON
  Map<String, dynamic> toJson() => toMap();


  // Criar objeto a partir de JSON
  static FinancialEvent fromJson(Map<String, dynamic> json) => fromMap(json);


  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FinancialEvent && other.id == id;
  }


  @override
  int get hashCode => id.hashCode;


  @override
  String toString() {
    return 'FinancialEvent(id: $id, description: $description, date: $date, type: $type, amount: $amount)';
  }


  // Métodos auxiliares
  bool get isPagamento => type == EventType.pagamento;
  bool get isGasto => type == EventType.gasto;
 
  bool isSameDate(DateTime other) {
    return date.year == other.year &&
           date.month == other.month &&
           date.day == other.day;
  }
}
