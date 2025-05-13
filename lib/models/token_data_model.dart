// To parse this JSON data, do
//
//     final tokenDataModel = tokenDataModelFromJson(jsonString);


import 'dart:convert';

TokenDataModel tokenDataModelFromJson(String str) => TokenDataModel.fromJson(json.decode(str));

String tokenDataModelToJson(TokenDataModel data) => json.encode(data.toJson());

class TokenDataModel {
    Data data;

    TokenDataModel({
        required this.data,
    });

    factory TokenDataModel.fromJson(Map<String, dynamic> json) => TokenDataModel(
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
    };
}

class Data {
    String message;
    String accessToken;
    String refreshToken;
    DateTime accessTokenExpiry;
    DateTime refreshTokenExpiry;

    Data({
        required this.message,
        required this.accessToken,
        required this.refreshToken,
        required this.accessTokenExpiry,
        required this.refreshTokenExpiry,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        message: json["message"],
        accessToken: json["access_token"],
        refreshToken: json["refresh_token"],
        accessTokenExpiry: DateTime.parse(json["access_token_expiry"]),
        refreshTokenExpiry: DateTime.parse(json["refresh_token_expiry"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "access_token": accessToken,
        "refresh_token": refreshToken,
        "access_token_expiry": accessTokenExpiry.toIso8601String(),
        "refresh_token_expiry": refreshTokenExpiry.toIso8601String(),
    };
}
