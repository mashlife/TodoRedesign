import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_redesign/src/providers/todo-provider.dart';
import 'package:todo_redesign/src/utils/colors.dart';
import 'package:todo_redesign/src/utils/extenstions.dart';
import 'package:todo_redesign/src/utils/text-types.dart';
import 'package:todo_redesign/src/utils/utils.dart';
import 'package:todo_redesign/src/views/AddTodo.dart';
import 'package:todo_redesign/src/views/HomeScreen/widgets/show_import_popup.dart';
import 'package:todo_redesign/src/views/HomeScreen/widgets/show_menu_popup.dart';
import 'package:todo_redesign/src/views/TodoScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _getTodos();
  }

  _getTodos() async {
    await context.read<TodoProvider>().getTodoList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: TextType.titleText("What ToDo!"),
            backgroundColor: Colors.green[300],
            actions:
                provider.selected.isEmpty
                    ? [
                      IconButton(
                        icon: const Icon(Icons.import_contacts_rounded),
                        onPressed: () => showImportPopup(context),
                      ),
                    ]
                    : [
                      IconButton(
                        icon:
                            provider.data.length != provider.selected.length
                                ? const Icon(Icons.select_all_rounded)
                                : Icon(Icons.deselect_rounded),
                        onPressed: () {
                          if (provider.data.length !=
                              provider.selected.length) {
                            provider.clearSelected();
                            for (var e in provider.data) {
                              provider.addToSelected(e);
                            }
                          } else {
                            provider.clearSelected();
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          for (var e in provider.selected) {
                            provider.removeFromList(e);
                          }
                          provider.clearSelected();
                        },
                      ),
                    ],
          ),
          floatingActionButton: InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: () => context.navigate(AddTodoScreen()),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Color(0xf5100ad9),
              child: Padding(
                padding: EdgeInsets.all(4),
                child: Hero(
                  tag: "Create Todo",
                  child: Icon(
                    Icons.add_rounded,
                    size: 30,
                    color: AppColors.creamWhite,
                  ),
                ),
              ),
            ),
          ),
          body:
              provider.data.isEmpty
                  ? Center(child: TextType.titleText("Create a new Todo"))
                  : SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: provider.data.length,
                            separatorBuilder:
                                (context, index) => Utils.vertSpacer(10),
                            itemBuilder: (context, index) {
                              final todo = provider.data[index];
                              final isSelected = provider.selected.contains(
                                todo,
                              );

                              return Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.blue[50] : null,
                                  border: Border.all(
                                    color: Colors.blue[600]!,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap:
                                      provider.selected.isEmpty
                                          ? () => context.navigate(
                                            TodoScreen(todo: todo),
                                          )
                                          : () {
                                            if (provider.selected.contains(
                                              todo,
                                            )) {
                                              provider.deleteFromSelected(todo);
                                            } else {
                                              provider.addToSelected(todo);
                                            }
                                          },
                                  onLongPressStart:
                                      provider.selected.isEmpty
                                          ? (details) => showTilesPopup(
                                            context,
                                            details.globalPosition,
                                            todo,
                                          )
                                          : null,

                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Hero(
                                        tag: "Todo title ${todo.id}",
                                        child: TextType.titleText(todo.title!),
                                      ),
                                      Utils.vertSpacer(5),
                                      Hero(
                                        tag: "ToDo description ${todo.id}",
                                        child: TextType.subTitle(
                                          todo.description!,
                                        ),
                                      ),
                                      Utils.vertSpacer(5),
                                      TextType.placeholder(
                                        DateFormat("dd MMM, yyyy").format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                            int.parse(todo.createdAt!),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
        );
      },
    );
  }
}
