import 'dart:convert';

// To parse this JSON data, do:
//     final addFavoriteResponse = addFavoriteResponseFromJson(jsonString);

AddFavoriteResponse addFavoriteResponseFromJson(String str) => AddFavoriteResponse.fromJson(json.decode(str));

class AddFavoriteResponse {
  String? message;
  AddFavoriteModel? result;

  AddFavoriteResponse({
    required this.message,
    required this.result,
  });

  factory AddFavoriteResponse.fromJson(Map<String, dynamic> json) => AddFavoriteResponse(
    message: json["message"],
    result: json["result"] != null ? AddFavoriteModel.fromJson(json["result"]) : null,
  );
}

class AddFavoriteModel {
  int? id;
  int? userId;
  String? quote;
  String? quotesImage;
  int? categoryId;
  DateTime? updatedAt;
  DateTime? createdAt;

  AddFavoriteModel({
    required this.id,
    required this.userId,
    required this.quote,
    required this.quotesImage,
    required this.categoryId,
    required this.updatedAt,
    required this.createdAt,
  });

  factory AddFavoriteModel.fromJson(Map<String, dynamic> json) => AddFavoriteModel(
    id: json["id"],
    userId: json["user_id"],
    quote: json["quote"],
    quotesImage: json["quotes_image"],
    categoryId: json["category_id"],
    updatedAt: DateTime.parse(json["updatedAt"]), // Convert string to DateTime
    createdAt: DateTime.parse(json["createdAt"]), // Convert string to DateTime
  );
}
