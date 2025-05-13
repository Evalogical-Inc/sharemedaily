import 'dart:convert';

EditQuoteResModel editQuoteResModelFromJson(String str) => EditQuoteResModel.fromJson(json.decode(str));

String editQuoteResModelToJson(EditQuoteResModel result) => json.encode(result.toJson());

class EditQuoteResModel {
    List<EditQuoteListItemDatum> result;

    EditQuoteResModel({
        required this.result,
    });

    factory EditQuoteResModel.fromJson(Map<String, dynamic> json) => EditQuoteResModel(
        result: List<EditQuoteListItemDatum>.from(json["result"].map((x) => EditQuoteListItemDatum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
    };
}

class EditQuoteListItemDatum {
    int id;
    String quote;
    String quoteImage;
    String imageAuthor;
    String quoteEditJson;
    String quoteEditThumbnail;
    DateTime? createdAt;
    DateTime? updatedAt;
    int userId;
    int categoryId;

    EditQuoteListItemDatum({
        required this.id,
        required this.quote,
        required this.quoteImage,
        required this.imageAuthor,
        required this.quoteEditJson,
        required this.quoteEditThumbnail,
        this.createdAt,
        this.updatedAt,
        required this.userId,
        required this.categoryId,
    });

    factory EditQuoteListItemDatum.fromJson(Map<String, dynamic> json) => EditQuoteListItemDatum(
        id: json["id"],
        quote: json["quote"],
        quoteImage: json["quotes_image"],
        imageAuthor: json["image_author"] ?? '',
        quoteEditJson: json["quotes_edit_json"],
        quoteEditThumbnail: json["quote_edits_thumbnail"],
        createdAt: json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : null,
        updatedAt: json["updatedAt"] != null ? DateTime.parse(json["updatedAt"]) : null,
        userId: json["user_id"],
        categoryId: json["category_id"] ?? 0,
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "quote": quote,
        "quotes_image": quoteImage,
        "quotes_edit_json": quoteEditJson,
        "quote_edits_thumbnail": quoteEditThumbnail,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "user_id": userId,
        "category_id": categoryId,
    };
}
