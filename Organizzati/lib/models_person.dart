/// Represents a person with a name, job, and location.
class Person {
  final String name;
  final String job;
  final String location;

  /// Constructs a [Person] object with the given [name], [job], and [location].
  Person({required this.name, required this.job, required this.location});

  /// Constructs a [Person] object from a JSON [Map].
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      name: json['name'],
      job: json['job'],
      location: json['location'],
    );
  }

  /// Converts this [Person] object to a JSON [Map].
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'job': job,
      'location': location,
    };
  }
}
