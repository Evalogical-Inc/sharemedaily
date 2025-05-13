// To parse this JSON data, do
//
//     final textAlignModal = textAlignModalFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/widgets.dart';

TextAlignModal textAlignModalFromJson(String str) {
    final jsonData = json.decode(str);
    return TextAlignModal.fromJson(jsonData);
}

String textAlignModalToJson(TextAlignModal data) {
    return json.encode(data);
}

class TextAlignModal {
    bool isActive;
    TextAlign textAlign;
    IconData icon;
    String label;

    TextAlignModal({
        required this.isActive,
        required this.textAlign,
        required this.icon,
        required this.label,
    });

    factory TextAlignModal.fromJson(Map<String, dynamic> json) => TextAlignModal(
        isActive: json["isActive"],
        textAlign: json["textAlign"],
        icon: json["icon"],
        label: json["label"],
    );

}
