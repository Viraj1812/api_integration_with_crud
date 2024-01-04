import 'dart:convert';

class Template {
  int code;
  List<TODO> data;

  Template({
    required this.code,
    required this.data,
  });

  factory Template.fromJson(Map<String, dynamic> json) {
    return Template(
      code: json['code'] ?? 0,
      data: List<TODO>.from(
          (json['data'] as List<dynamic>).map((x) => TODO.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class TODO {
  String id;
  String todoName;
  bool? isComplete;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  TODO({
    required this.id,
    required this.todoName,
    this.isComplete,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory TODO.fromJson(Map<String, dynamic> json) {
    return TODO(
      id: json['_id'] ?? '',
      todoName: json['todoName'] ?? '',
      isComplete: json['isComplete'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "todoName": todoName,
        "isComplete": isComplete,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}

Template templateFromJson(String str) => Template.fromJson(json.decode(str));
String templateToJson(Template data) => json.encode(data.toJson());

List<TODO> todosFromJson(String str) =>
    List<TODO>.from(json.decode(str)['data'].map((x) => TODO.fromJson(x)));

String todosToJson(List<TODO> data) =>
    json.encode({"data": List<dynamic>.from(data.map((x) => x.toJson()))});
