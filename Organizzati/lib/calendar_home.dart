
/// This file contains the implementation of the calendar home page in the app.
/// It includes the main app widget, the calendar home page widget, and the add event dialog widget.
/// The calendar home page displays a table calendar with events and allows users to add and view event details.
/// The add event dialog allows users to add new events to the calendar.
import 'package:app/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'inventary.dart';
import 'providers_people.dart';
import 'models_person.dart';

void main() {
  runApp(const MyApp());
}

/// The main app widget.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PeopleProvider()),
        ChangeNotifierProvider(create: (context) => InventoryProvider()), // Aggiungiamo il provider dell'inventario
      ],
      child: MaterialApp(
        title: 'Flutter Calendar',
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
        ),
        home: const CalendarHomePage(),
      ),
    );
  }
}

class CalendarHomePage extends StatefulWidget {
  const CalendarHomePage({Key? key}) : super(key: key);

  @override
  _CalendarHomePageState createState() => _CalendarHomePageState();
}

class _CalendarHomePageState extends State<CalendarHomePage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Calendar',
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: () => _showAddEventDialog(context),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(8),
                textStyle: const TextStyle(fontSize: 24),
              ),
              child: const Icon(Icons.add, color: Color.fromARGB(255, 35, 158, 219),),
            ),
          ],
        ),
      ),
      body: Consumer<EventProvider>(
        builder: (context, eventProvider, child) {
          final _events = eventProvider.events;

          return SingleChildScrollView(
            child: Column(
              children: [
                TableCalendar(
                  calendarStyle: CalendarStyle(
                    // Cambia il colore del giorno selezionato
                    selectedDecoration: BoxDecoration(
                      color: const Color.fromARGB(71, 35, 219, 133),
                      shape: BoxShape.circle,
                    ),
                    // Cambia il colore del giorno corrente
                    todayDecoration: BoxDecoration(
                      color: const Color.fromARGB(72, 47, 139, 185),
                      shape: BoxShape.circle,
                    ),
                    // Cambia il colore dei giorni della settimana
                  ),
                  firstDay: DateTime(2000),
                  lastDay: DateTime(3000),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  eventLoader: (day) {
                    return _events[day] ?? [];
                  },
                ),
                const Divider(color: Colors.grey, height: 1.0),
                Column(
                  children: [
                    ...(_events[_selectedDay] ?? []).map((event) {
                      return GestureDetector(
                        onTap: () {
                          _showEventDetailsDialog(context, event);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(0.5),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey)),
                            //color: Color.fromARGB(72, 47, 139, 185),
                            //border: Border.all(color: Colors.black, width: 0.2),
                            //borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    event['event'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                      '${event['person']} - ${event['inventoryItem']} \n'
                                      'Start: ${event['startTime'].format(context)} \nEnd: ${event['endTime'].format(context)}'),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    eventProvider.removeEvent(_selectedDay, event);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddEventDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer2<PeopleProvider, InventoryProvider>(
          builder: (context, peopleProvider, inventoryProvider, child) {
            return AddEventDialog(
              peopleProvider: peopleProvider,
              inventoryProvider: inventoryProvider,
              onAddEvent: (String event, String person, String inventoryItem, TimeOfDay startTime, TimeOfDay endTime) {
                setState(() {
                  final eventProvider = Provider.of<EventProvider>(context, listen: false);
                  eventProvider.addEvent(_selectedDay, {
                    'event': event,
                    'person': person,
                    'inventoryItem': inventoryItem,
                    'startTime': startTime,
                    'endTime': endTime,
                  });
                });
              },
            );
          },
        );
      },
    );
  }

  void _showEventDetailsDialog(BuildContext context, Map<String, dynamic> event) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(event['event']),
          content: Text(
              'Person: ${event['person']}\n'
              'Inventory Item: ${event['inventoryItem']}\n'
              'Start: ${event['startTime'].format(context)}\n'
              'End: ${event['endTime'].format(context)}'),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class AddEventDialog extends StatefulWidget {
  final PeopleProvider peopleProvider;
  final InventoryProvider inventoryProvider;
  final Function(String event, String person, String inventoryItem, TimeOfDay startTime, TimeOfDay endTime) onAddEvent;

  AddEventDialog({
    required this.peopleProvider,
    required this.inventoryProvider,
    required this.onAddEvent,
  });

  @override
  _AddEventDialogState createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  TextEditingController _eventController = TextEditingController();
  String? _selectedPerson;
  String? _selectedInventoryItem;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Event'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _eventController,
              decoration: const InputDecoration(labelText: 'Event'),
            ),
            DropdownButton<String>(
              value: _selectedPerson,
              hint: const Text('Select Person'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPerson = newValue;
                });
              },
              items: widget.peopleProvider.people
                  .map((Person person) {
                return DropdownMenuItem<String>(
                  value: person.name,
                  child: Text(person.name),
                );
              }).toList(),
            ),
            DropdownButton<String>(
              value: _selectedInventoryItem,
              hint: const Text('Select Inventory Item'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedInventoryItem = newValue;
                });
              },
              items: widget.inventoryProvider.rectangles
                  .map((RectangleData item) {
                return DropdownMenuItem<String>(
                  value: item.name,
                  child: Text(item.name),
                );
              }).toList(),
            ),
            ListTile(
              title: Text('Start Time: ${_startTime?.format(context) ?? 'Select'}'),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (picked != null) {
                  setState(() {
                    _startTime = picked;
                  });
                }
              },
            ),
            ListTile(
              title: Text('End Time: ${_endTime?.format(context) ?? 'Select'}'),
trailing: const Icon(Icons.access_time),
onTap: () async {
TimeOfDay? picked = await showTimePicker(
context: context,
initialTime: TimeOfDay.now(),
);
if (picked != null) {
setState(() {
_endTime = picked;
});
}
},
),
],
),
),
actions: [
TextButton(
child: const Text('Cancel'),
onPressed: () {
Navigator.of(context).pop();
},
),
TextButton(
child: const Text('Add'),
onPressed: () {
if (_eventController.text.isEmpty || _selectedPerson == null || _selectedInventoryItem == null || _startTime == null || _endTime == null) {
return;
}
widget.onAddEvent(_eventController.text, _selectedPerson!, _selectedInventoryItem!, _startTime!, _endTime!);
Navigator.of(context).pop();
},
),
],
);
}
}