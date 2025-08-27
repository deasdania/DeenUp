class CityModel {
  String? id;
  String? lokasi;

  CityModel({this.id, this.lokasi});

  CityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lokasi = json['lokasi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['lokasi'] = lokasi;
    return data;
  }
}
