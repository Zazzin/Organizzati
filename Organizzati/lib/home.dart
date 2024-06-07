import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

/// The home screen of the application.
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, List<String>> _events = {};

  /// Opens the date picker dialog and updates the selected day.
  void _selectDay(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDay,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDay) {
      setState(() {
        _selectedDay = picked;
        _focusedDay = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Benvenuto!',
                    style: TextStyle(fontSize: 30),
                  ),
                  const Text(
                    'Calendario',
                    style: TextStyle(fontSize: 30),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDay(context),
                    child: Text(
                      DateFormat.yMMMMd('it').format(_selectedDay),
                    ),
                  ),
                ],
              ),
            ),
          ),
          TableCalendar(
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // update `_focusedDay` here as well
              });
            },
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            eventLoader: (day) {
              return _events[day] ?? [];
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return Positioned(
                    right: 1,
                    bottom: 1,
                    child: _buildEventsMarker(date, events),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: _buildEventList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEventDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Shows the dialog to add a new event.
  void _showAddEventDialog(BuildContext context) {
    final TextEditingController eventController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Aggiungi Impegno'),
          content: TextField(
            controller: eventController,
            decoration: const InputDecoration(hintText: "Scrivi il tuo impegno"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annulla'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Salva'),
              onPressed: () {
                if (eventController.text.isNotEmpty) {
                  setState(() {
                    if (_events[_selectedDay] != null) {
                      _events[_selectedDay]!.add(eventController.text);
                    } else {
                      _events[_selectedDay] = [eventController.text];
                    }
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// Builds the marker for events on a specific date.
  Widget _buildEventsMarker(DateTime date, List events) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: const TextStyle().copyWith(color: Colors.white, fontSize: 12.0),
        ),
      ),
    );
  }

  /// Builds the list of events for the selected day.
  Widget _buildEventList() {
    final events = _events[_selectedDay] ?? [];
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(events[index]),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              setState(() {
                events.removeAt(index);
                if (events.isEmpty) {
                  _events.remove(_selectedDay);
                } else {
                  _events[_selectedDay] = events;
                }
              });
            },
          ),
        );
      },
    );
  }
}
