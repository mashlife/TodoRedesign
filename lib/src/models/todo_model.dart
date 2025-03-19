// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

enum TodoStatus { ready, pending, completed }

class TodoModel {
  String? id;
  String? title;
  String? description;
  String? note;
  String? createdAt;
  TodoStatus? status;
  TodoModel({
    this.id,
    this.title,
    this.description,
    this.note,
    this.createdAt,
    this.status,
  });

  TodoModel copyWith({
    String? id,
    String? title,
    String? description,
    String? note,
    String? createdAt,
    TodoStatus? status,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'note': note,
      'createdAt': createdAt,
      'status': status?.name,
    };
  }

  factory TodoModel.fromMap(String source) {
    final map = jsonDecode(source) as Map<String, dynamic>;

    return TodoModel(
      id: map['id'] != null ? map['id'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      note: map['note'] != null ? map['note'] as String : null,

      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      status:
          map['status'] != null
              ? TodoStatus.values.firstWhere((e) => e.name == map['status'])
              : TodoStatus.ready,
    );
  }

  factory TodoModel.fromCsv(String source) {
    List<String> values = source.trim().split(',');

    String decodedNote = utf8.decode(base64.decode(values[3]));

    return TodoModel(
      id: values[0],
      title: values[1],
      description: values[2],
      note: decodedNote, // Decoded JSON string
      createdAt: values[4],
      status: TodoStatus.values.firstWhere(
        (e) => e.name == values[5],
        orElse: () => TodoStatus.ready,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(covariant TodoModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.description == description &&
        other.note == note &&
        other.createdAt == createdAt &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        note.hashCode ^
        createdAt.hashCode ^
        status.hashCode;
  }
}
