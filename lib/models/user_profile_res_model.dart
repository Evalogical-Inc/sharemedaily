// To parse this JSON data, do
//
//     final profileResModel = profileResModelFromJson(jsonString);

import 'dart:convert';

ProfileResModel profileResModelFromJson(String str) => ProfileResModel.fromJson(json.decode(str));


class ProfileResModel {
    int? userId;
    String? firstName;
    dynamic lastName;
    String? email;
    dynamic isdCode;
    dynamic phoneNumber;
    dynamic profileImage;
    String? bio;
    String? gender;

    ProfileResModel({
        this.userId,
        this.firstName,
        this.lastName,
        this.email,
        this.isdCode,
        this.phoneNumber,
        this.profileImage,
        this.bio,
        this.gender
    });

    factory ProfileResModel.fromJson(Map<String, dynamic> json) => ProfileResModel(
        userId: json["userId"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        isdCode: json["isd_code"],
        phoneNumber: json["phone_number"],
        profileImage: json["profile_image"],
        bio: json["bio"],
        gender: json["gender"]
    );
}
