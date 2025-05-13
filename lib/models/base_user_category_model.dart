// To parse this JSON data, do
//
//     final categoryBase = categoryBaseFromJson(jsonString);


import 'dart:convert';

UserCategoryBase categoryBaseFromJson(String str) => UserCategoryBase.fromJson(json.decode(str));

String categoryBaseToJson(UserCategoryBase data) => json.encode(data.toJson());

class UserCategoryBase {
    int? id;
    String category;
    int categoryId;
    String? userId;


    UserCategoryBase({
         this.id,
        required this.category,
        required this.categoryId,
        this.userId
    });

    factory UserCategoryBase.fromJson(Map<String, dynamic> json) => UserCategoryBase(
        id: json["id"],
        category: json["category"],
        categoryId: json["category_id"],
        userId: json["user_id"]
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "category": category,
        "category_id":categoryId,
        "user_id": userId
    };
}
