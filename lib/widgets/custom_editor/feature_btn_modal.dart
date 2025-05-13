import 'dart:convert';

FeatureButtonStatus featureButtonStatusFromJson(String str) {
    final jsonData = json.decode(str);
    return FeatureButtonStatus.fromJson(jsonData);
}

String featureButtonStatusToJson(FeatureButtonStatus data) {
    return json.encode(data);
}

class FeatureButtonStatus {
    int index;
    bool status;

    FeatureButtonStatus({
        required this.index,
        required this.status,
    });

    factory FeatureButtonStatus.fromJson(Map<String, dynamic> json) =>  FeatureButtonStatus(
        index: json["index"],
        status: json["status"],
    );

}
