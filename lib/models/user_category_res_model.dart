// To parse this JSON data, do
//
//     final categoryResponseModel = categoryResponseModelFromJson(jsonString);

import 'dart:convert';

UserCategoryResponseModel userCategoryResponseModelFromJson(String str) => UserCategoryResponseModel.fromJson(json.decode(str));


class UserCategoryResponseModel {
    List<Result> result;

    UserCategoryResponseModel({
        required this.result,
    });

    factory UserCategoryResponseModel.fromJson(Map<String, dynamic> json) => UserCategoryResponseModel(
        result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
    );
}

class Result {
    int id;
    int userId;
    int categoryId;
    String category;

    Result({
        required this.id,
        required this.userId,
        required this.categoryId,
        required this.category
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        userId: json["user_id"],
        categoryId: json["category_id"],
        category: json["category"]
    );
}
