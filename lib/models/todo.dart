class Todo {
  String id;
  String title;
  String description;
  DateTime dueDate;
  bool isCompleted;
  bool isSticky;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
    this.isSticky = false,
  });
}
