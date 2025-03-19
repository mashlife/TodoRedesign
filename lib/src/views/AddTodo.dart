import 'dart:async';
import 'dart:convert';
import 'dart:io' as io show Directory, File;
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:todo_redesign/src/providers/todo-provider.dart';
import 'package:todo_redesign/src/models/todo_model.dart';
import 'package:todo_redesign/src/utils/colors.dart';
import 'package:todo_redesign/src/utils/extenstions.dart';
import 'package:todo_redesign/src/utils/textfield.dart';
import 'package:todo_redesign/src/utils/utils.dart';
import 'package:todo_redesign/src/widgets/timestamp-embed.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  late final TextEditingController _titleController;
  late final QuillController _controller;
  late final String documentId;
  final FocusNode _editorFocusNode = FocusNode();
  final ScrollController _editorScrollController = ScrollController();
  final Random _random = Random();
  Timer? timer;

  @override
  void initState() {
    _titleController = TextEditingController();
    documentId = generateRandomNumber().toString();
    _controller = () {
      return QuillController.basic(
        config: QuillControllerConfig(
          clipboardConfig: QuillClipboardConfig(
            enableExternalRichPaste: true,
            onImagePaste: (imageBytes) async {
              if (kIsWeb) {
                return null;
              }
              // Save the image somewhere and return the image URL that will be
              // stored in the Quill Delta JSON (the document).
              final newFileName =
                  'image-file-${DateTime.now().toIso8601String()}.png';
              final newPath = path.join(
                io.Directory.systemTemp.path,
                newFileName,
              );
              final file = await io.File(
                newPath,
              ).writeAsBytes(imageBytes, flush: true);
              return file.path;
            },
          ),
        ),
      );
    }();

    timer = Timer.periodic(Duration(seconds: 3), (timer) => saveTodoList());
    super.initState();
  }

  saveTodoList() {
    if (_titleController.text.trim().isNotEmpty) {
      final List<dynamic> parsedJson = _controller.document.toDelta().toJson();

      final String firstInsert = parsedJson[0]['insert'];
      final String cleanedInsert = firstInsert.replaceAll('\n', '');

      context.read<TodoProvider>().updateList(
        TodoModel(
          id: documentId,
          title: _titleController.text.trim(),
          description: cleanedInsert,
          note: jsonEncode(_controller.document.toDelta().toJson()),
          createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
          status: TodoStatus.ready,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _editorScrollController.dispose();
    _editorFocusNode.dispose();
    timer?.cancel();
    super.dispose();
  }

  int generateRandomNumber() {
    final randomNumber = 1000 + _random.nextInt(9000);
    return randomNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            saveTodoList();
            context.navigateBack();
          },
          child: Hero(tag: "Create Todo", child: Icon(Icons.arrow_back_ios)),
        ),

        backgroundColor: Colors.green[300],
      ),
      body: SafeArea(
        child: Column(
          children: [
            CustomTextField(
              controller: _titleController,
              hintText: "Enter Title",
              fill: AppColors.background,
              textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
              focusBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide.none,
              ),
              padding: EdgeInsets.all(10),
              radius: BorderRadius.zero,
            ),
            Utils.vertSpacer(10),
            QuillSimpleToolbar(
              controller: _controller,
              config: QuillSimpleToolbarConfig(
                embedButtons: FlutterQuillEmbeds.toolbarButtons(),
                showClipboardPaste: true,
                multiRowsDisplay: false,
                toolbarSize: 50,
                decoration: BoxDecoration(
                  color: AppColors.creamWhite,
                  borderRadius: BorderRadius.circular(10),
                ),
                buttonOptions: QuillSimpleToolbarButtonOptions(
                  base: QuillToolbarBaseButtonOptions(
                    afterButtonPressed: () {
                      final isDesktop = {
                        TargetPlatform.linux,
                        TargetPlatform.windows,
                        TargetPlatform.macOS,
                      }.contains(defaultTargetPlatform);
                      if (isDesktop) {
                        _editorFocusNode.requestFocus();
                      }
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: QuillEditor(
                focusNode: _editorFocusNode,
                scrollController: _editorScrollController,
                controller: _controller,
                config: QuillEditorConfig(
                  placeholder: 'Start writing your notes...',
                  padding: const EdgeInsets.all(16),
                  embedBuilders: [
                    ...FlutterQuillEmbeds.editorBuilders(
                      imageEmbedConfig: QuillEditorImageEmbedConfig(
                        imageProviderBuilder: (context, imageUrl) {
                          // https://pub.dev/packages/flutter_quill_extensions#-image-assets
                          if (imageUrl.startsWith('assets/')) {
                            return AssetImage(imageUrl);
                          }
                          return null;
                        },
                      ),
                      videoEmbedConfig: QuillEditorVideoEmbedConfig(
                        customVideoBuilder: (videoUrl, readOnly) {
                          // To load YouTube videos https://github.com/singerdmx/flutter-quill/releases/tag/v10.8.0
                          return null;
                        },
                      ),
                    ),
                    TimeStampEmbedBuilder(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
