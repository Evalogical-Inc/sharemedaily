// To parse this JSON data, do
//
//     final quotesDataModel = quotesDataModelFromJson(jsonString);

import 'dart:convert';

List<QuotesDataModel> quotesDataModelFromJson(String str) => List<QuotesDataModel>.from(json.decode(str).map((x) => QuotesDataModel.fromJson(x)));


class QuotesDataModel {
    String categoryName;
    List<CategoryItem> categoryItems;

    QuotesDataModel({
        required this.categoryName,
        required this.categoryItems,
    });

    factory QuotesDataModel.fromJson(Map<String, dynamic> json) => QuotesDataModel(
        categoryName: json["categoryName"],
        categoryItems: List<CategoryItem>.from(json["categoryItems"].map((x) => CategoryItem.fromJson(x))),
    );
}

class CategoryItem {
    CategoryImage image;
    Quote quote;

    CategoryItem({
        required this.image,
        required this.quote,
    });

    factory CategoryItem.fromJson(Map<String, dynamic> json) => CategoryItem(
        image: CategoryImage.fromJson(json["image"]),
        quote: Quote.fromJson(json["quote"]),
    );
}

class CategoryImage {
    String imageId;
    String path;
    CategoryImageAuthor author;

    CategoryImage({
        required this.imageId,
        required this.path,
        required this.author,
    });

    factory CategoryImage.fromJson(Map<String, dynamic> json) => CategoryImage(
        imageId: json["imageId"],
        path: json["path"],
        author: CategoryImageAuthor.fromJson(json["author"]),
    );
}

class CategoryImageAuthor {
    String id;
    String author;
    String profile;

    CategoryImageAuthor({
        required this.id,
        required this.author,
        required this.profile,
    });

    factory CategoryImageAuthor.fromJson(Map<String, dynamic> json) => CategoryImageAuthor(
        id: json["id"],
        author: json["author"],
        profile: json["profile"],
    );
}

class Quote {
    int quoteId;
    String quote;
    QuoteAuthor author;
    int categoryId;

    Quote({
        required this.quoteId,
        required this.quote,
        required this.author,
        required this.categoryId,
    });

    factory Quote.fromJson(Map<String, dynamic> json) => Quote(
        quoteId: json["quoteId"],
        quote: json["quote"],
        categoryId: json["category_id"],
        author: QuoteAuthor.fromJson(json["author"]),
    );
}

class QuoteAuthor {
    String author;

    QuoteAuthor({
        required this.author,
    });

    factory QuoteAuthor.fromJson(Map<String, dynamic> json) => QuoteAuthor(
        author: json["author"],
    );
}
