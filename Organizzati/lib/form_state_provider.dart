import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A provider class that manages the state of a form.
class FormStateProvider with ChangeNotifier {
  bool _showForm = false;

  bool get showForm => _showForm;

  /// Constructs a new instance of [FormStateProvider].
  ///
  /// It loads the form state from shared preferences.
  FormStateProvider() {
    _loadFormState();
  }

  /// Toggles the visibility of the form.
  ///
  /// It updates the [_showForm] flag, saves the form state to shared preferences,
  /// and notifies listeners of the state change.
  void toggleForm() {
    _showForm = !_showForm;
    _saveFormState();
    notifyListeners();
  }

  /// Sets the visibility of the form.
  ///
  /// It updates the [_showForm] flag, saves the form state to shared preferences,
  /// and notifies listeners of the state change.
  ///
  /// - [show]: A boolean value indicating whether to show or hide the form.
  void showFormState(bool show) {
    _showForm = show;
    _saveFormState();
    notifyListeners();
  }

  /// Saves the form state to shared preferences.
  Future<void> _saveFormState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('showForm', _showForm);
  }

  /// Loads the form state from shared preferences.
  Future<void> _loadFormState() async {
    final prefs = await SharedPreferences.getInstance();
    _showForm = prefs.getBool('showForm') ?? false;
    notifyListeners();
  }
}
