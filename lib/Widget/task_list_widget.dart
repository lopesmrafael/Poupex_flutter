import 'package:flutter/material.dart';

class CalendarWidget extends StatefulWidget {
  final DateTime selectedDate;
  final Map<DateTime, List<String>> events;
  final Map<DateTime, String> dayTypes;
  final Function(DateTime) onDateSelected;

  CalendarWidget({
    required this.selectedDate,
    required this.events,
    required this.dayTypes,
    required this.onDateSelected,
  });

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime currentMonth;

  @override
  void initState() {
    super.initState();
    currentMonth = DateTime(widget.selectedDate.year, widget.selectedDate.month);
  }

  void _previousMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
    });
  }

  String _getMonthName(int month) {
    const months = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Header do calendário
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _previousMonth,
                icon: Icon(Icons.chevron_left),
              ),
              Text(
                '${_getMonthName(currentMonth.month)} ${currentMonth.year}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              IconButton(
                onPressed: _nextMonth,
                icon: Icon(Icons.chevron_right),
              ),
            ],
          ),
          SizedBox(height: 16),
          
          // Dias da semana
          Row(
            children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                .map((day) => Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          SizedBox(height: 8),
          
          // Grid do calendário
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDayOfMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0);
    final firstDayWeekday = firstDayOfMonth.weekday % 7;
    final daysInMonth = lastDayOfMonth.day;

    List<Widget> dayWidgets = [];

    // Adicionar espaços vazios para os dias antes do primeiro dia do mês
    for (int i = 0; i < firstDayWeekday; i++) {
      dayWidgets.add(Container());
    }

    // Adicionar os dias do mês
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(currentMonth.year, currentMonth.month, day);
      final isSelected = widget.selectedDate.day == day &&
          widget.selectedDate.month == currentMonth.month &&
          widget.selectedDate.year == currentMonth.year;
      final hasEvent = widget.events[date] != null;
      final dayType = widget.dayTypes[date];

      dayWidgets.add(
        GestureDetector(
          onTap: () => widget.onDateSelected(date),
          child: Container(
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: _getDayColor(isSelected, hasEvent, dayType),
              borderRadius: BorderRadius.circular(8),
              border: isSelected 
                  ? Border.all(color: Colors.blue, width: 2)
                  : null,
            ),
            child: Center(
              child: Text(
                '$day',
                style: TextStyle(
                  color: _getTextColor(isSelected, hasEvent, dayType),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Organizar em linhas de 7 dias
    List<Widget> weeks = [];
    for (int i = 0; i < dayWidgets.length; i += 7) {
      weeks.add(
        Row(
          children: dayWidgets
              .skip(i)
              .take(7)
              .map((day) => Expanded(child: Container(height: 40, child: day)))
              .toList(),
        ),
      );
    }

    return Column(children: weeks);
  }

  Color _getDayColor(bool isSelected, bool hasEvent, String? dayType) {
    if (isSelected) {
      return Colors.blue.withOpacity(0.3);
    } else if (hasEvent) {
      if (dayType == 'pagamento') {
        return Colors.green.withOpacity(0.7);
      } else if (dayType == 'gasto') {
        return Colors.red.withOpacity(0.7);
      }
    }
    return Colors.transparent;
  }

  Color _getTextColor(bool isSelected, bool hasEvent, String? dayType) {
    if (hasEvent) {
      return Colors.white;
    } else if (isSelected) {
      return Colors.blue;
    }
    return Colors.black87;
  }
}