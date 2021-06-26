import 'dart:convert';

class Todo {
  String id;
  String todoText;
  bool isComplete;

  Todo(this.id, this.todoText, this.isComplete);

  factory Todo.fromJson(dynamic json) {
    var decodedJson = jsonDecode(json);

    return Todo(
      decodedJson['id'] as String,
      decodedJson['todoText'] as String,
      decodedJson['isComplete'] as bool
    );
  }
}