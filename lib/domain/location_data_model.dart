class LocationDataModel {
  String? mainAddress;
  String? secondaryAddress;
  LocationDataModel({
    required this.mainAddress,
    required this.secondaryAddress,
  });

  LocationDataModel.fromJson(Map<String, dynamic> json) {
    mainAddress = json['mainAddress'];
    secondaryAddress = json['secondaryAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mainAddress'] = mainAddress;
    data['secondaryAddress'] = secondaryAddress;
    return data;
  }
}
