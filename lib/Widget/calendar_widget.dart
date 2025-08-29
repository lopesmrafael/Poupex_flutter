import 'package:flutter/material.dart';

class TaskListWidget extends StatelessWidget {
  final DateTime selectedDate;
  final Map<DateTime, List<String>> events;
  final Map<DateTime, String> dayTypes;

  TaskListWidget({
    required this.selectedDate,
    required this.events,
    required this.dayTypes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Color(0xFF7FCDCD),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.event_note, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Tarefas Atercadas',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: _buildEventsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList() {
    // Buscar todos os eventos futuros
    final now = DateTime.now();
    final futureEvents = <MapEntry<DateTime, List<String>>>[];
    
    events.forEach((date, eventList) {
      if (date.isAfter(now) || 
          (date.day == now.day && date.month == now.month && date.year == now.year)) {
        futureEvents.add(MapEntry(date, eventList));
      }
    });

    if (futureEvents.isEmpty) {
      return Center(
        child: Text(
          'Nenhum evento agendado',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
          ),
        ),
      );
    }

    // Ordenar por data
    futureEvents.sort((a, b) => a.key.compareTo(b.key));

    return ListView.builder(
      itemCount: futureEvents.length,
      itemBuilder: (context, index) {
        final entry = futureEvents[index];
        final date = entry.key;
        final eventList = entry.value;
        final dayType = dayTypes[date];
        
        return Card(
          margin: EdgeInsets.only(bottom: 12),
          elevation: 2,
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: dayType == 'pagamento' ? Colors.green : Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${date.day} de ${_getMonthName(date.month)} de ${date.year}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                ...eventList.map((event) => Padding(
                  padding: EdgeInsets.only(left: 20, bottom: 4),
                  child: Text(
                    event,
                    style: TextStyle(fontSize: 14),
                  ),
                )).toList(),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: dayType == 'pagamento' ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        dayType == 'pagamento' ? 'PAGAMENTO' : 'GASTO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];
    return months[month - 1];
  }
}