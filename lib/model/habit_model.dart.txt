class Habit {
  final int id;
  final String name;
  final String description;
  final String frequency; // e.g., "daily", "weekly"
  final bool completed;

  Habit({
    required this.id,
    required this.name,
    required this.description,
    required this.frequency,
    required this.completed,
  });

  // Convert a Habit into a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'frequency': frequency,
      'completed': completed ? 1 : 0,
    };
  }
}
