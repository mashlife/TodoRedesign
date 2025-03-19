import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_redesign/src/data/todo-provider.dart';
import 'package:todo_redesign/src/utils/convert-extensions.dart';

enum ImportOptions { csv, json }

showImportPopup(BuildContext context) {
  showMenu(
    context: context,
    position: RelativeRect.fromLTRB(100, 70, 0, 0),
    items: [
      PopupMenuItem<ImportOptions>(
        value: ImportOptions.csv,
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
          title: Text('Import CSV'),
        ),
      ),
      PopupMenuItem<ImportOptions>(
        value: ImportOptions.json,
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
          title: Text('Import Json'),
        ),
      ),
    ],
    popUpAnimationStyle: AnimationStyle(
      curve: Easing.emphasizedDecelerate,
      duration: const Duration(milliseconds: 480),
    ),
  ).then((value) {
    if (value != null) {
      _handleValue(context, value);
    }
  });
}

Future<void> _handleValue(BuildContext context, ImportOptions value) async {
  if (value == ImportOptions.csv) {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      final todo = await ConvertExtensions.importFromCSV(
        result.xFiles.first.path,
      );
      context.read<TodoProvider>().updateList(todo);
    } else {
      print("No Files found");
    }
  } else if (value == ImportOptions.json) {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null) {
      final todo = await ConvertExtensions.importFromJson(
        result.xFiles.first.path,
      );
      context.read<TodoProvider>().updateList(todo);
    } else {
      print("No Files found");
    }
  }
}
