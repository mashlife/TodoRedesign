import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_redesign/src/data/todo-provider.dart';
import 'package:todo_redesign/src/models/todo_model.dart';
import 'package:todo_redesign/src/utils/convert-extensions.dart';

enum Menu { select, delete, downloadCSV, downloadJson }

void showTilesPopup(BuildContext context, Offset position, TodoModel todo) {
  showMenu(
    context: context,
    position: RelativeRect.fromLTRB(
      position.dx,
      position.dy,
      position.dx + 1,
      position.dy + 1,
    ),
    items: <PopupMenuEntry<Menu>>[
      PopupMenuItem<Menu>(
        value: Menu.select,
        child: ListTile(
          leading: Icon(Icons.done_rounded),
          title: Text('Select'),
        ),
      ),
      PopupMenuItem<Menu>(
        value: Menu.delete,
        child: ListTile(
          leading: Icon(Icons.delete_outline),
          title: Text('Delete'),
        ),
      ),

      PopupMenuDivider(),
      PopupMenuItem<Menu>(
        value: Menu.downloadCSV,
        child: ListTile(
          leading: Container(
            margin: EdgeInsets.only(left: 3),
            child: Image.asset(
              "assets/csv-download.png",
              fit: BoxFit.cover,
              height: 20,
              width: 20,
            ),
          ),
          title: Text('Export as CSV'),
        ),
      ),
      PopupMenuItem<Menu>(
        value: Menu.downloadJson,
        child: ListTile(
          leading: Container(
            margin: EdgeInsets.only(left: 3),
            child: Image.asset(
              "assets/json-download.png",
              fit: BoxFit.cover,
              height: 20,
              width: 20,
            ),
          ),
          title: Text('Export as Json'),
        ),
      ),
    ],
    popUpAnimationStyle: AnimationStyle(
      curve: Easing.emphasizedDecelerate,
      duration: const Duration(milliseconds: 480),
    ),
  ).then((value) {
    if (value != null) {
      _handleMenuSelection(value, context, todo);
    }
  });
}

Future<void> _handleMenuSelection(
  Menu item,
  BuildContext context,
  TodoModel todo,
) async {
  if (item == Menu.select) {
    context.read<TodoProvider>().addToSelected(todo);
  } else if (item == Menu.delete) {
    context.read<TodoProvider>().removeFromList(todo);
  } else if (item == Menu.downloadCSV) {
    await ConvertExtensions.downloadAsCSV(todo);
  } else if (item == Menu.downloadJson) {
    await ConvertExtensions.downloadAsJson(todo);
  }
}
