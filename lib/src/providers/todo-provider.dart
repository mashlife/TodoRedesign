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
      final jsondata = {
        "id": "6453",
        "title": "Mushfiqur Rahaman",
        "description":
            "Hello, hope you are doing fine. I am a Mobile Application and Server Side developer working as a freelancer for the past 2.5 years. I have worked on many projects both for clients and to develop my skills. I am going through the phase - ",
        "note":
            "[{\"insert\":\"Hello, hope you are doing fine. \\n\\nI am a Mobile Application and Server Side developer working as a freelancer for the past 2.5 years. I have worked on many projects both for clients and to develop my skills. I am going through the phase - \\n\\n\"},{\"insert\":\"The More You Know The More You Realize You Don't Know\",\"attributes\":{\"bold\":true,\"italic\":true}},{\"insert\":\"\\n\",\"attributes\":{\"code-block\":true}},{\"insert\":\"\\nI want to reach the peak of Mobile Development and Development in general. That's why I am currently looking for opportunities where I can hone my skills and find some skilled persons to guide me.\\n\\n\\nProjects\"},{\"insert\":\"\\n\",\"attributes\":{\"header\":3}},{\"insert\":\"Nshot VPN (IKEv2 protocol/ production)\"},{\"insert\":\"\\n\",\"attributes\":{\"list\":\"bullet\"}},{\"insert\":\"Cochevia (Ride-sharing/ testing phase)\"},{\"insert\":\"\\n\",\"attributes\":{\"list\":\"bullet\"}},{\"insert\":\"Earnstride (Earnpass/ testing phase)\"},{\"insert\":\"\\n\",\"attributes\":{\"list\":\"bullet\"}},{\"insert\":\"NF Network (deployed via local ISP)\"},{\"insert\":\"\\n\",\"attributes\":{\"list\":\"bullet\"}},{\"insert\":\"SportAddict (deployed via local ISP)\"},{\"insert\":\"\\n\",\"attributes\":{\"list\":\"bullet\"}},{\"insert\":\"S-Finder Mobile Schematic (production)\"},{\"insert\":\"\\n\",\"attributes\":{\"list\":\"bullet\"}},{\"insert\":\"Norix VPN (Wireguard protocol/ development)\"},{\"insert\":\"\\n\",\"attributes\":{\"list\":\"bullet\"}},{\"insert\":\"Viewzy (Full control your TV/ development)\"},{\"insert\":\"\\n\",\"attributes\":{\"list\":\"bullet\"}},{\"insert\":\"\\n\\n\"},{\"insert\":\"\\n\",\"attributes\":{\"header\":3}},{\"insert\":\"\\n\"}]",
        "createdAt": "1742389518437",
        "status": "ready",
      };

      final todo = TodoModel.fromMap(jsonEncode(jsondata));
      _todoData.add(todo);
    }
    notifyListeners();
  }
}
