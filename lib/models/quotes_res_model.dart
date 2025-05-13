// To parse this JSON data, do
//
//     final quotesResModel = quotesResModelFromJson(jsonString);

import 'dart:convert';

QuotesResModel quotesResModelFromJson(String str) => QuotesResModel.fromJson(json.decode(str));


class QuotesResModel {
    int length;
    List<Quote> quotes;

    QuotesResModel({
        required this.length,
        required this.quotes,
    });

    factory QuotesResModel.fromJson(Map<String, dynamic> json) => QuotesResModel(
        length: json["length"],
        quotes: List<Quote>.from(json["quotes"].map((x) => Quote.fromJson(x))),
    );
}

class Quote {
    String image;
    String quote;

    Quote({
        required this.image,
        required this.quote,
    });

    factory Quote.fromJson(Map<String, dynamic> json) => Quote(
        image: json["image"],
        quote: json["quote"],
    );
}
