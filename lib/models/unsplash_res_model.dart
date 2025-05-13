// To parse this JSON data, do
//
//     final unsplashResModel = unsplashResModelFromJson(jsonString);

import 'dart:convert';

UnsplashResModel unsplashResModelFromJson(String str) => UnsplashResModel.fromJson(json.decode(str));

// String unsplashResModelToJson(UnsplashResModel data) => json.encode(data.toJson());

class UnsplashResModel {
    int? total;
    int? totalPages;
    List<Result>? results;

    UnsplashResModel({
        this.total,
        this.totalPages,
        this.results,
    });

    factory UnsplashResModel.fromJson(Map<String, dynamic> json) => UnsplashResModel(
        total: json["total"],
        totalPages: json["total_pages"],
        results:  List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
    );
}

class Result {
    String? id;
    Urls? urls;
    ResultLinks? links;
    User? user;

    Result({
        this.id,
        this.urls,
        this.links,
        this.user,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        urls: Urls.fromJson(json["urls"]),
        links: ResultLinks.fromJson(json["links"]),
        user: User.fromJson(json["user"]),
    );
}

class ResultLinks {
    String? self;
    String? html;
    String? download;

    ResultLinks({
        this.self,
        this.html,
        this.download,
    });

    factory ResultLinks.fromJson(Map<String, dynamic> json) => ResultLinks(
        self: json["self"],
        html: json["html"],
        download: json["download"],
    );
}

class Urls {
    String? raw;
    String? full;
    String? regular;
    String? small;
    String? thumb;
    String? smallS3;

    Urls({
        this.raw,
        this.full,
        this.regular,
        this.small,
        this.thumb,
        this.smallS3,
    });

    factory Urls.fromJson(Map<String, dynamic> json) => Urls(
        raw: json["raw"],
        full: json["full"],
        regular: json["regular"],
        small: json["small"],
        thumb: json["thumb"],
        smallS3: json["small_s3"],
    );
}

class User {
    String? id;
    String? name;
    UserLinks? links;
    ProfileImage? profileImage;

    User({
        this.id,
        this.name,
        this.links,
        this.profileImage,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        links: UserLinks.fromJson(json["links"]),
        profileImage: ProfileImage.fromJson(json["profile_image"]),
    );
}

class UserLinks {
    String? self;

    UserLinks({
        this.self,
    });

    factory UserLinks.fromJson(Map<String, dynamic> json) => UserLinks(
        self: json["self"],
    );
}

class ProfileImage {
    String? medium;

    ProfileImage({
        this.medium,
    });

    factory ProfileImage.fromJson(Map<String, dynamic> json) => ProfileImage(
        medium: json["medium"],
    );
}
