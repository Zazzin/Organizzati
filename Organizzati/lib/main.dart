import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_controller.dart';
import 'navbar.dart';
import 'providers_people.dart'; // Import the provider
import 'form_state_provider.dart'; // Import the new provider
import 'inventary.dart';
import 'event_provider.dart'; // Import the event provider

/// The main entry point of the application.
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsController()),
        ChangeNotifierProvider(create: (_) => PeopleProvider()), // Add the provider
        ChangeNotifierProvider(create: (_) => FormStateProvider()),
        ChangeNotifierProvider(create: (_) => InventoryProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),  // Add the new provider
      ],
      child: MyApp(),
    ),
  );
}

/// The root widget of the application.
class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = Provider.of<SettingsController>(context);
    return AnimatedBuilder(
      animation: settingsController,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: settingsController.themeMode,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          home: NavBar(settingsController: settingsController),
        );
      },
    );
  }
}
