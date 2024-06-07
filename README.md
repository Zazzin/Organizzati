# Organizzati
## Documentazione Software: 
Calendar_home.dart
Titolo: Documentazione del Codice della Home Page del Calendario
Questo documento spiega i principali elementi del codice che implementa la home page del calendario in un'app Flutter.
1. Importazioni:
   - `package:app/event_provider.dart`: Contiene il provider per la gestione degli eventi del calendario.
   - `package:flutter/material.dart`: Framework principale per lo sviluppo di interfacce utente in Flutter.
   - `package:table_calendar/table_calendar.dart`: Libreria per la visualizzazione e gestione di un calendario.
   - `package:provider/provider.dart`: Libreria per la gestione dello stato basata sul pattern Provider.
   - `inventary.dart`, `providers_people.dart`, `models_person.dart`: 
File locali che definiscono provider per inventario e persone, e modelli di dati.

2. Funzione principale:
   - `void main()`: Punto di ingresso dell'applicazione Flutter, che avvia l'esecuzione dell'app chiamando `runApp`.

3. Widget principale dell'app:
   - `class MyApp extends StatelessWidget`: Definisce il widget principale dell'app. Utilizza `MultiProvider` per fornire i provider necessari (PeopleProvider e InventoryProvider) a tutto il widget tree.

4. Home Page del Calendario:
   - `class CalendarHomePage extends StatefulWidget`: Definisce il widget della home page del calendario.
   - `_CalendarHomePageState`: Stato interno del widget che gestisce la logica del calendario.

5. AppBar:
   - Contiene il titolo "Calendar" e un pulsante per aggiungere nuovi eventi.

6. TableCalendar:
   - Mostra il calendario con formattazione personalizzata.
   - `selectedDecoration`: Cambia l'aspetto del giorno selezionato.
   - `todayDecoration`: Cambia l'aspetto del giorno corrente.
   - `onDaySelected`: Funzione chiamata quando un giorno viene selezionato, aggiorna `_selectedDay` e `_focusedDay`.
   - `eventLoader`: Carica gli eventi per un giorno specifico.

7. Eventi del Calendario:
   - Gli eventi sono visualizzati sotto il calendario come una lista di `ListTile`.
   - Gli eventi possono essere eliminati tramite un'icona di cancellazione.

8. Dialogo per Aggiungere Eventi:
   - `void _showAddEventDialog(BuildContext context)`: Mostra un dialogo per aggiungere nuovi eventi.
   - `class AddEventDialog extends StatefulWidget`: Dialogo che permette agli utenti di inserire i dettagli di un nuovo evento.

9. Dettagli Evento:
   - `void _showEventDetailsDialog(BuildContext context, Map<String, dynamic> event)`: Mostra i dettagli di un evento in un dialogo di avviso.

10. Gestione dello Stato:
    - `Consumer`: Utilizzato per accedere ai dati forniti dai provider.
    - `setState`: Aggiorna lo stato interno del widget quando vengono aggiunti, rimossi o modificati eventi.

11. Modello di Dati e Provider:
    - `PeopleProvider` e `InventoryProvider`: Provider per gestire i dati delle persone e dell'inventario.
    - `Person` e `RectangleData`: Modelli di dati per persone e articoli di inventario.
Inventary.dart
Importazioni

	•import 'package:flutter/material.dart';: Importa il framework Flutter per la costruzione di interfacce utente.

	•import 'package:provider/provider.dart';: Importa il pacchetto Provider per la gestione dello stato globale dell’app.

	•import 'package:shared_preferences/shared_preferences.dart';: Importa il pacchetto SharedPreferences per la memorizzazione dei dati locali.

	•import 'dart:convert';: Importa il pacchetto Dart per la codifica e decodifica JSON.


Classe RectangleData
	•RectangleData: Modello di dati per rappresentare un elemento dell’inventario.
	•Proprietà:
	•name: Nome dell’elemento.
	•itemCount: Numero di articoli utilizzati.
	•totalValue: Valore totale degli articoli.
	•isExpanded: Stato di espansione dell’elemento (vero/falso).
	•id: Identificatore univoco dell’elemento.
	•Metodi:
	•toMap(): Converte l’oggetto in una mappa per la serializzazione.
	•fromMap(Map<String, dynamic> map): Crea un oggetto RectangleData da una mappa.
Classe InventoryProvider
	•InventoryProvider: Gestore dello stato per gli elementi dell’inventario.
	•Proprietà:
	•_rectangles: Lista degli elementi dell’inventario.
	•_controllers: Mappa dei controller dei testi per la modifica dei nomi degli elementi.
	•_currentId: Identificatore corrente per nuovi elementi.
	•Metodi:
	•saveRectangles(): Salva gli elementi dell’inventario nelle preferenze condivise.
	•loadRectangles(): Carica gli elementi dell’inventario dalle preferenze condivise.
	•incrementItem(): Aggiunge un nuovo elemento all’inventario.
	•incrementCounter(int index): Incrementa il conteggio degli articoli utilizzati per un elemento.
	•decrementCounter(int index): Decrementa il conteggio degli articoli utilizzati per un elemento.
	•removeItem(int index): Rimuove un elemento dall’inventario.
	•incrementTotalValue(int index): Incrementa il valore totale degli articoli per un elemento.
	•decrementTotalValue(int index): Decrementa il valore totale degli articoli per un elemento.
	•toggleExpand(int index): Espande o riduce la visualizzazione dei dettagli di un elemento.
Classe InventoryScreen
	•InventoryScreen: Widget che rappresenta la schermata dell’inventario.
	•Costruttore: const InventoryScreen({Key? key}) : super(key: key);
	•Metodo build:
	•Consumer<InventoryProvider>: Utilizza il provider per ottenere l’accesso ai dati dell’inventario.
	•Scaffold: Struttura di base dell’interfaccia con una AppBar e un corpo principale.
	•AppBar: Barra dell’applicazione con un titolo e un pulsante per aggiungere nuovi elementi.
	•SingleChildScrollView: Consente lo scorrimento del contenuto.
	•Column: Disposizione verticale degli elementi dell’inventario.
	•GestureDetector: Rileva i tocchi sugli elementi per espandere/ridurre i dettagli.
	•AnimatedContainer: Contenitore animato per mostrare l’espansione/riduzione degli elementi.
	•TextFormField: Campo di testo per modificare il nome degli elementi.
	•IconButton: Pulsanti per incrementare/decrementare valori e rimuovere elementi

PeopleInventory.dart

Importazioni
- **`import 'package:flutter/material.dart';`**: Importa il framework Flutter per la costruzione di interfacce utente.
- **`import 'package:provider/provider.dart';`**: Importa il pacchetto Provider per la gestione dello stato globale dell'app.
- **`import 'providers_people.dart';`**: Importa il file locale che definisce il provider per la gestione delle persone.
- **`import 'models_person.dart';`**: Importa il file locale che definisce il modello dei dati per le persone.
- **`import 'form_state_provider.dart';`**: Importa il file locale che definisce il provider per lo stato del modulo (form).

Classe PeopleInventory
- **`class PeopleInventory extends StatefulWidget`**: Definisce un widget di stato (stateful) che rappresenta l'interfaccia per la gestione delle persone.
- **`_PeopleInventoryState`**: Stato interno del widget `PeopleInventory`.

Proprietà di `_PeopleInventoryState`
-`_nameController`, `_jobController`, `_locationController`: Controller per la gestione degli input di testo per il nome, il lavoro e la posizione delle persone.

Metodi di `_PeopleInventoryState`
- _addPerson(PeopleProvider provider, FormStateProvider formProvider)`:
  - Aggiunge una nuova persona alla lista del provider `PeopleProvider`.
  - Controlla che i campi del modulo non siano vuoti prima di aggiungere la persona.
  - Resetta i campi del modulo e chiude il modulo dopo l'aggiunta.
- **`_showPersonDetails(BuildContext context, Person person)`**:
  - Mostra i dettagli di una persona in un dialogo di avviso.

Metodo `build` di `_PeopleInventoryState`
- **`Scaffold`**: Struttura di base dell'interfaccia con una `AppBar` e un corpo principale.
- **`AppBar`**: Barra dell'applicazione con un titolo e un pulsante per aprire il modulo di aggiunta di una persona.
- **`Padding`**: Aggiunge margini interni attorno al contenuto principale.
- **`Column`**: Disposizione verticale degli elementi.
- **Modulo di Aggiunta Persona**:
  - Mostra un modulo con campi di testo per nome, lavoro e posizione.
  - Un pulsante per aggiungere la persona utilizzando il metodo `_addPerson`.
- **`ListView.builder`**:
  - Crea una lista di persone aggiunte utilizzando il provider `PeopleProvider`.
  - Ogni persona è rappresentata come una `Card` con un effetto di elevazione e un gradiente di colore.
  - **`InkWell`**: Rileva il tocco sugli elementi per mostrare i dettagli della persona.
  - **`ListTile`**: Contiene il titolo (nome della persona), sottotitolo (lavoro e posizione) e un pulsante di eliminazione.

Provider
- `PeopleProvider`:
  - Gestisce la lista delle persone.
  - Fornisce metodi per aggiungere e rimuovere persone.
- `FormStateProvider`:
  - Gestisce lo stato del modulo (aperto/chiuso).
  - Fornisce metodi per aprire e chiudere il modulo.

Navbard.dart
Importazioni
- **`import 'package:app/calendar_home.dart';`**: Importa il widget della home page del calendario.
- **`import 'package:flutter/material.dart';`**: Importa il framework Flutter per la costruzione di interfacce utente.
- **`import 'package:google_nav_bar/google_nav_bar.dart';`**: Importa la libreria per la barra di navigazione di Google.
- **`inventary.dart`**: Importa il file che gestisce l'inventario.
- **`people_invenory.dart`**: Importa il file che gestisce l'inventario delle persone.
- **`settings_controller.dart`**: Importa il file che gestisce le impostazioni, in particolare la modalità tema (chiaro/scuro).

Classe NavBar
- **`NavBar`**: Un widget stateful che gestisce la barra di navigazione e il cambio di pagina.
  - **`SettingsController settingsController`**: Un controller per gestire le impostazioni dell'app, come il tema.

Stato di NavBar
    - _NavBarState`: Lo stato interno del widget `NavBar`.
   - Proprietà:
   - `PageController _pageController`: Controlla il cambio di pagina nel `PageView`.
   - `int _selectedPage`: Tiene traccia della pagina attualmente selezionata.
   - `initState`: Inizializza il `PageController` con la pagina selezionata iniziale.
   - `dispose`: Libera le risorse utilizzate dal `PageController` quando il widget viene eliminato.

Metodo `build`
    - `Scaffold*: Struttura di base dell'interfaccia con una `AppBar`, un `body` principale e una `bottomNavigationBar`.
    - `AppBar`: Contiene un pulsante per cambiare la modalità tema (chiaro/scuro).
    - `IconButton`: Cambia l'icona in base alla modalità tema corrente e aggiorna il tema quando viene premuto.
    - `PageView`: Consente la navigazione tra diverse schermate scorrendo.
    - `onPageChanged`: Aggiorna `_selectedPage` quando cambia la pagina.
    - `children`: Contiene le schermate `CalendarHomePage`, `InventoryScreen` e `PeopleInventory`.
    - `GNav`: Barra di navigazione inferiore.
    - `backgroundColor`: Colore di sfondo della barra di navigazione.
    - `color`: Colore delle icone non attive.
    - `activeColor`: Colore delle icone attive.
    - `tabBackgroundColor`: Colore di sfondo del tab attivo.
    - `gap`: Spazio tra icona e testo.
    - `padding`: Padding interno del tab.
    - `tabs`: Definisce i tab della barra di navigazione con icone e testi.
    - `selectedIndex`: Indice del tab attualmente selezionato.
    - `onTabChange`: Cambia la pagina del `PageView` quando viene selezionato un tab.
