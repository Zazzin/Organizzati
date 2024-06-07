import 'package:flutter/material.dart';
import 'models_person.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class PeopleProvider with ChangeNotifier {
 final List<Person> _people = [];


 List<Person> get people => _people;


 PeopleProvider() {
   _loadPeople();
 }


 void addPerson(Person person) {
   _people.add(person);
   notifyListeners();
   _savePeople();
 }


 void removePerson(int index) {
   _people.removeAt(index);
   notifyListeners();
   _savePeople();
 }


 Future<void> _loadPeople() async {
   final prefs = await SharedPreferences.getInstance();
   final peopleString = prefs.getString('people') ?? '[]';
   final List<dynamic> peopleJson = jsonDecode(peopleString);


   _people.addAll(peopleJson.map((json) => Person.fromJson(json)).toList());
   notifyListeners();
 }


 Future<void> _savePeople() async {
   final prefs = await SharedPreferences.getInstance();
   final peopleJson = jsonEncode(_people.map((person) => person.toJson()).toList());
   prefs.setString('people', peopleJson);
 }
}
