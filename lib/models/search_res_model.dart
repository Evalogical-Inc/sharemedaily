// To parse this JSON data, do
//
//     final searchResponseModel = searchResponseModelFromJson(jsonString);

import 'dart:convert';

SearchResponseModel searchResponseModelFromJson(String str) =>
    SearchResponseModel.fromJson(json.decode(str));

String searchResponseModelToJson(SearchResponseModel data) =>
    json.encode(data.toJson());

class SearchResponseModel {
  List<Result> result;

  SearchResponseModel({required this.result});

  factory SearchResponseModel.fromJson(Map<String, dynamic> json) =>
      SearchResponseModel(
        result:
            List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
      };
}

class Result {
  int id;
  String quote;
  String author;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic createdBy;
  int categoryId;

  Result({
    required this.id,
    required this.quote,
    required this.author,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.categoryId,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        quote: json["quote"],
        author: json["author"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        createdBy: json["created_by"],
        categoryId: json["category_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "quote": quote,
        "author": author,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "created_by": createdBy,
        "category_id": categoryId,
      };
}
