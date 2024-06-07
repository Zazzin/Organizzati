import 'package:flutter/material.dart';

/// A class that provides event management functionality.
class EventProvider with ChangeNotifier {
  Map<DateTime, List<Map<String, dynamic>>> _events = {};

  /// Gets the map of events, where the key is the date and the value is a list of events on that date.
  Map<DateTime, List<Map<String, dynamic>>> get events => _events;

  /// Adds an event to the specified date.
  ///
  /// If an event already exists on the specified date, the new event will be added to the existing list of events.
  /// If no event exists on the specified date, a new list will be created with the event.
  /// After adding the event, the listeners will be notified.
  void addEvent(DateTime date, Map<String, dynamic> event) {
    if (_events[date] != null) {
      _events[date]!.add(event);
    } else {
      _events[date] = [event];
    }
    notifyListeners();
  }

  /// Removes an event from the specified date.
  ///
  /// If an event exists on the specified date, it will be removed from the list of events.
  /// If the list of events becomes empty after removing the event, the date will be removed from the map.
  /// After removing the event, the listeners will be notified.
  void removeEvent(DateTime date, Map<String, dynamic> event) {
    if (_events[date] != null) {
      _events[date]!.remove(event);
      if (_events[date]!.isEmpty) {
        _events.remove(date);
      }
      notifyListeners();
    }
  }
}
