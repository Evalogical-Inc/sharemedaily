// To parse this JSON data, do
//
//     final categoryBase = categoryBaseFromJson(jsonString);


import 'dart:convert';

CategoryBase categoryBaseFromJson(String str) => CategoryBase.fromJson(json.decode(str));

String categoryBaseToJson(CategoryBase data) => json.encode(data.toJson());

class CategoryBase {
    int id;
    String category;

    CategoryBase({
        required this.id,
        required this.category,
    });

    factory CategoryBase.fromJson(Map<String, dynamic> json) => CategoryBase(
        id: json["id"] ?? '' ,
        category: json["category"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "category": category,
    };
}
