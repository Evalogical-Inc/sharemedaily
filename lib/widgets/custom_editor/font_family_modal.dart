// To parse this JSON data, do
//
//     final fontFamilyModal = fontFamilyModalFromJson(jsonString);

import 'dart:convert';

FontFamilyModal fontFamilyModalFromJson(String str) {
    final jsonData = json.decode(str);
    return FontFamilyModal.fromJson(jsonData);
}

String fontFamilyModalToJson(FontFamilyModal data) {
    return json.encode(data);
}

class FontFamilyModal {
    bool isActive;
    String fontFamily;
    String label;

    FontFamilyModal({
        required this.isActive,
        required this.fontFamily,
        required this.label,
    });

    factory FontFamilyModal.fromJson(Map<String, dynamic> json) => FontFamilyModal(
        isActive: json["isActive"],
        fontFamily: json["fontFamily"],
        label: json["label"],
    );
    
     

   
}
