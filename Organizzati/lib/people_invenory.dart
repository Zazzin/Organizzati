import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers_people.dart';
import 'models_person.dart';
import 'form_state_provider.dart'; // Importa il nuovo provider

class PeopleInventory extends StatefulWidget {
  const PeopleInventory({super.key});

  @override
  _PeopleInventoryState createState() => _PeopleInventoryState();
}

class _PeopleInventoryState extends State<PeopleInventory> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  void _addPerson(PeopleProvider provider, FormStateProvider formProvider) {
    final String name = _nameController.text;
    final String job = _jobController.text;
    final String location = _locationController.text;

    if (name.isNotEmpty && job.isNotEmpty && location.isNotEmpty) {
      provider.addPerson(Person(name: name, job: job, location: location));
      _nameController.clear();
      _jobController.clear();
      _locationController.clear();
      formProvider.showFormState(false);
    }
  }

  void _showPersonDetails(BuildContext context, Person person) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(person.name),
          content: Text('Job: ${person.job}\nLocation: ${person.location}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final peopleProvider = Provider.of<PeopleProvider>(context);
    final formProvider = Provider.of<FormStateProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Staff',
              style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                formProvider.toggleForm();
              },
              style: ElevatedButton.styleFrom(
                iconColor: const Color.fromARGB(255, 35, 158, 219),
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(8),
                textStyle: const TextStyle(fontSize: 24),
              ),
              child: const Icon(Icons.add),

            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            if (formProvider.showForm || peopleProvider.people.isEmpty)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _jobController,
                        decoration: InputDecoration(
                          labelText: 'Job',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          labelText: 'Work Location',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => _addPerson(peopleProvider, formProvider),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        child: const Text('Add Person'),
                      ),
                    ],
                  ),
                ),
              )
            else
            const SizedBox(height: 20),
            Expanded(
              child: peopleProvider.people.isEmpty
                  ? const Center(child: Text('No people added'))
                  : ListView.builder(
                      itemCount: peopleProvider.people.length,
                      itemBuilder: (context, index) {
                        final person = peopleProvider.people[index];
                        return InkWell(
                          
                          onTap: () => _showPersonDetails(context, person),
                          child: Card(
                            elevation: 2,
                            child: Container(
                              
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color.fromARGB(255, 77, 244, 166),
                                    const Color.fromARGB(124, 152, 248, 248), // Colore finale
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListTile(
                                title: Text(person.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                                subtitle: Text('${person.job} - ${person.location}', style: const TextStyle(color: Colors.black)),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Colors.black,
                                  onPressed: () {
                                    peopleProvider.removePerson(index);
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}