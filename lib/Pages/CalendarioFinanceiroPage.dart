import 'package:flutter/material.dart';
import 'package:projeto_pity/Widget/calendar_widget.dart';
import 'package:projeto_pity/Widget/task_list_widget.dart';
import '../repository/theme_manager.dart';

class CalendarioScreen extends StatefulWidget {
  @override
  _CalendarioScreenState createState() => _CalendarioScreenState();
}

class _CalendarioScreenState extends State<CalendarioScreen> {
  DateTime selectedDate = DateTime.now();
  Map<DateTime, List<String>> events = {};
  Map<DateTime, String> dayTypes = {}; // 'pagamento' ou 'gasto'

  void _onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  void _addEvent(DateTime date, String event, String type) {
    setState(() {
      if (events[date] != null) {
        events[date]!.add(event);
      } else {
        events[date] = [event];
      }
      dayTypes[date] = type;
    });
  }

  void _showAddEventDialog() {
    String eventText = '';
    String eventType = 'pagamento';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Adicionar Evento'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) {
                      eventText = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Descrição do evento',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: eventType,
                    decoration: InputDecoration(
                      labelText: 'Tipo',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'pagamento',
                        child: Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              color: Colors.green,
                              margin: EdgeInsets.only(right: 8),
                            ),
                            Text('Pagamento'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'gasto',
                        child: Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              color: Colors.red,
                              margin: EdgeInsets.only(right: 8),
                            ),
                            Text('Gasto'),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setDialogState(() {
                        eventType = value!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (eventText.isNotEmpty) {
                      _addEvent(selectedDate, eventText, eventType);
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Adicionar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeManager.backgroundColor,
      appBar: AppBar(
        title: Text(
          "Poupe✖",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: ThemeManager.textColor,
          ),
        ),
        backgroundColor: ThemeManager.appBarColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: ThemeManager.textColor),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.notifications, color: ThemeManager.textColor),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.account_circle, color: ThemeManager.textColor),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              'Diário de Finanças\nCalendário',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ThemeManager.textColor,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CalendarWidget(
                    selectedDate: selectedDate,
                    events: events,
                    dayTypes: dayTypes,
                    onDateSelected: _onDateSelected,
                  ),
                  Expanded(
                    child: TaskListWidget(
                      selectedDate: selectedDate,
                      events: events,
                      dayTypes: dayTypes,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEventDialog,
        backgroundColor: ThemeManager.appBarColor,
        child: Icon(Icons.add, color: ThemeManager.textColor),
      ),
    );
  }
}