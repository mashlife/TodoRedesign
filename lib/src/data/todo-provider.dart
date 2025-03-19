import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_redesign/src/models/todo_model.dart';

class TodoProvider extends ChangeNotifier {
  final String _dataKey = "Get_Todo_Data";

  final List<TodoModel> _todoData = [];
  List<TodoModel> get data => _todoData;

  final List<TodoModel> _selected = [];
  List<TodoModel> get selected => _selected;

  void addToSelected(TodoModel todo) {
    _selected.add(todo);
    notifyListeners();
  }

  void deleteFromSelected(TodoModel todo) {
    _selected.removeWhere((t) => t == todo);
    notifyListeners();
  }

  void clearSelected() {
    _selected.clear();
    notifyListeners();
  }

  void addToList(TodoModel todo) {
    _todoData.add(todo);
    saveTodoList();
    notifyListeners();
  }

  void updateList(TodoModel todo) {
    final index = _todoData.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      _todoData[index] = todo;
    } else {
      _todoData.add(todo);
    }
    saveTodoList();
    notifyListeners();
  }

  void updateListAtIndex(TodoModel todo, int index) {
    if (index >= 0 && index < _todoData.length) {
      _todoData[index] = todo;
      saveTodoList();
      notifyListeners();
    }
  }

  void removeFromList(TodoModel todo) {
    _todoData.removeWhere((t) => t == todo);
    saveTodoList();
    notifyListeners();
  }

  Future<void> saveTodoList() async {
    final sp = await SharedPreferences.getInstance();
    final List<String> todoJsonList =
        _todoData.map((todo) => jsonEncode(todo.toMap())).toList();
    await sp.setStringList(_dataKey, todoJsonList);
  }

  Future<void> getTodoList() async {
    final sp = await SharedPreferences.getInstance();
    final List<String>? todoJsonList = sp.getStringList(_dataKey);

    if (todoJsonList != null) {
      _todoData.clear();
      _todoData.addAll(todoJsonList.map((json) => TodoModel.fromMap(json)));
    } else {
      print("todo data null");
    }
    notifyListeners();
  }
}
