// To parse this JSON data, do
//
//     final quotesResponseModel = quotesResponseModelFromJson(jsonString);


import 'dart:convert';

QuotesResponseModel quotesResponseModelFromJson(String str) => QuotesResponseModel.fromJson(json.decode(str));

String quotesResponseModelToJson(QuotesResponseModel data) => json.encode(data.toJson());

class QuotesResponseModel {
    List<Datum> data;

    QuotesResponseModel({
        required this.data,
    });

    factory QuotesResponseModel.fromJson(Map<String, dynamic> json) => QuotesResponseModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    int id;
    String quote;
    String author;
    DateTime createdAt;
    DateTime updatedAt;
    dynamic createdBy;
    int categoryId;

    Datum({
        required this.id,
        required this.quote,
        required this.author,
        required this.createdAt,
        required this.updatedAt,
        required this.createdBy,
        required this.categoryId,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
