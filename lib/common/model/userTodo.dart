import 'dart:convert';

import 'package:will_support/common/model/todo.dart';
import 'package:will_support/common/model/user.dart';

class UserTodo {
  User user;
  Todo todo;

  UserTodo(this.user, this.todo);

  factory UserTodo.fromJson(dynamic json) {
    var decodedJson = jsonDecode(json);

    var tempUser = User(decodedJson['userId'] as String, "", "", "", decodedJson['profileImageUrl'] as String);
    var tempTodo = Todo(decodedJson['todoId'] as String, decodedJson['todoText'] as String, decodedJson['isComplete'] as bool);

    return UserTodo(
        tempUser,
        tempTodo
    );
  }
}