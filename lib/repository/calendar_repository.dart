class CalendarRepository {
  Map<DateTime, List<String>> _events = {};
  Map<DateTime, String> _dayTypes = {};


  // Obter todos os eventos
  Map<DateTime, List<String>> getAllEvents() {
    return Map.unmodifiable(_events);
  }


  // Obter todos os tipos de dia
  Map<DateTime, String> getAllDayTypes() {
    return Map.unmodifiable(_dayTypes);
  }


  // Adicionar evento
  void addEvent(DateTime date, String event, String type) {
    final dateKey = DateTime(date.year, date.month, date.day);
   
    if (_events[dateKey] != null) {
      _events[dateKey]!.add(event);
    } else {
      _events[dateKey] = [event];
    }
   
    _dayTypes[dateKey] = type;
  }


  // Obter eventos de uma data específica
  List<String> getEventsForDate(DateTime date) {
    final dateKey = DateTime(date.year, date.month, date.day);
    return _events[dateKey] ?? [];
  }


  // Obter tipo do dia
  String? getDayType(DateTime date) {
    final dateKey = DateTime(date.year, date.month, date.day);
    return _dayTypes[dateKey];
  }


  // Verificar se uma data tem eventos
  bool hasEventsOnDate(DateTime date) {
    final dateKey = DateTime(date.year, date.month, date.day);
    return _events[dateKey] != null && _events[dateKey]!.isNotEmpty;
  }


  // Remover evento específico
  void removeEvent(DateTime date, String event) {
    final dateKey = DateTime(date.year, date.month, date.day);
   
    if (_events[dateKey] != null) {
      _events[dateKey]!.remove(event);
     
      // Se não há mais eventos nessa data, remove a entrada
      if (_events[dateKey]!.isEmpty) {
        _events.remove(dateKey);
        _dayTypes.remove(dateKey);
      }
    }
  }


  // Remover todos os eventos de uma data
  void removeAllEventsFromDate(DateTime date) {
    final dateKey = DateTime(date.year, date.month, date.day);
    _events.remove(dateKey);
    _dayTypes.remove(dateKey);
  }


  // Limpar todos os dados
  void clearAllData() {
    _events.clear();
    _dayTypes.clear();
  }


  // Obter eventos futuros (incluindo hoje)
  Map<DateTime, List<String>> getFutureEvents() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
   
    return Map.fromEntries(
      _events.entries.where((entry) =>
        entry.key.isAfter(today) || entry.key.isAtSameMomentAs(today)
      )
    );
  }


  // Obter eventos de um mês específico
  Map<DateTime, List<String>> getEventsForMonth(int year, int month) {
    return Map.fromEntries(
      _events.entries.where((entry) =>
        entry.key.year == year && entry.key.month == month
      )
    );
  }


  // Obter total de eventos
  int getTotalEventsCount() {
    return _events.values.fold(0, (sum, eventList) => sum + eventList.length);
  }


  // Buscar eventos por texto
  Map<DateTime, List<String>> searchEvents(String query) {
    if (query.isEmpty) return {};
   
    final lowercaseQuery = query.toLowerCase();
    Map<DateTime, List<String>> results = {};
   
    _events.forEach((date, eventList) {
      final matchingEvents = eventList.where(
        (event) => event.toLowerCase().contains(lowercaseQuery)
      ).toList();
     
      if (matchingEvents.isNotEmpty) {
        results[date] = matchingEvents;
      }
    });
   
    return results;
  }
}
