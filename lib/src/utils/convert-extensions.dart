import 'dart:convert';
import 'dart:io';

import 'package:todo_redesign/src/models/todo_model.dart';

class ConvertExtensions {
  static Future<void> downloadAsCSV(TodoModel todo) async {
    String encodedNote = base64.encode(utf8.encode(todo.note ?? ''));
    String csvStr =
        '${todo.id},${todo.title},${todo.description},$encodedNote,${todo.createdAt},${todo.status?.name}';
    File file = File('/storage/emulated/0/Download/${todo.title}.csv');
    await file.writeAsString(csvStr);
  }

  static Future<TodoModel> importFromCSV(String filePath) async {
    File file = File(filePath);
    String csvContent = await file.readAsString();

    return TodoModel.fromCsv(csvContent);
  }

  static Future<void> downloadAsJson(TodoModel todo) async {
    String jsonStr = jsonEncode(todo.toMap());
    File file = File('/storage/emulated/0/Download/${todo.title}.json');
    await file.writeAsString(jsonStr);
  }

  static Future<TodoModel> importFromJson(String filePath) async {
    File file = File(filePath);
    String jsonContent = await file.readAsString();
    return TodoModel.fromMap(jsonContent);
  }
}
