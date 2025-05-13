import 'dart:convert';

FavoriteResModel favoriteResModelFromJson(String str) => FavoriteResModel.fromJson(json.decode(str));

String favoriteResModelToJson(FavoriteResModel result) => json.encode(result.toJson());

class FavoriteResModel {
    List<FavoriteListItemDatum> result;

    FavoriteResModel({
        required this.result,
    });

    factory FavoriteResModel.fromJson(Map<String, dynamic> json) => FavoriteResModel(
        result: List<FavoriteListItemDatum>.from(json["result"].map((x) => FavoriteListItemDatum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
    };
}

class FavoriteListItemDatum {
    int id;
    String quote;
    String quoteImage;
    String imageAuthor;
    DateTime createdAt;
    DateTime updatedAt;
    int userId;
    int categoryId;

    FavoriteListItemDatum({
        required this.id,
        required this.quote,
        required this.quoteImage,
        required this.imageAuthor,
        required this.createdAt,
        required this.updatedAt,
        required this.userId,
        required this.categoryId,
    });

    factory FavoriteListItemDatum.fromJson(Map<String, dynamic> json) => FavoriteListItemDatum(
        id: json["id"],
        quote: json["quote"],
        quoteImage: json["quotes_image"],
        imageAuthor: json["image_author"] ?? '',
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        userId: json["user_id"],
        categoryId: json["category_id"] ?? 0,
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "quote": quote,
        "quotes_image": quoteImage,
        "image_author": imageAuthor,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "user_id": userId,
        "category_id": categoryId,
    };
}
