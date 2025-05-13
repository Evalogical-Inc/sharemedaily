// To parse this JSON data, do
//
//     final categoryResponseModel = categoryResponseModelFromJson(jsonString);

import 'dart:convert';

CategoryResponseModel categoryResponseModelFromJson(String str) => CategoryResponseModel.fromJson(json.decode(str));


class CategoryResponseModel {
    List<Result> result;

    CategoryResponseModel({
        required this.result,
    });

    factory CategoryResponseModel.fromJson(Map<String, dynamic> json) => CategoryResponseModel(
        result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
    );
}

class Result {
    int id;
    String category;
    String categoryImage;
    bool isSelected;

    Result({
        required this.id,
        required this.category,
        required this.categoryImage,
        required this.isSelected
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        category: json["category"],
        categoryImage: json["category_image"],
        isSelected: false
    );
}
