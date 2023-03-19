import 'package:vokast/models/base_model.dart';
import 'package:vokast/models/db_model.dart';

class RadioAPIModel extends BaseModel {
  List<RadioModel> data;

  RadioAPIModel({
    required this.data,
  });

  @override
  fromJson(List<dynamic> json) {
    data = (json)
        .map(
          (i) => RadioModel.fromJson(i),
        )
        .toList();
  }
}

class RadioModel extends DBBaseModel {
  static String tableName = 'radio-2';

  late final String id;
  late final String name;
  late final String url;
  late final String website;
  late final String image;
  late final bool isFavorite;

  RadioModel({
    required this.id,
    required this.name,
    required this.url,
    required this.website,
    required this.image,
    required this.isFavorite,
  });

  factory RadioModel.fromJson(Map<String, dynamic> json) {
    return RadioModel(
      id: json['changeuuid'],
      name: json['name'],
      url: json['url_resolved'],
      website: json['homepage'],
      image: json['favicon'],
      isFavorite: false,
    );
  }

  static RadioModel fromMap(Map<String, dynamic> map) {
    return RadioModel(
        id: map['changeuuid'],
        name: map['name'],
        url: map['url_resolved'],
        website: map['homepage'],
        image: map['favicon'],
        isFavorite: map['isFavorite'] == 1 ? true : false);
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'name': name,
      'url_resolved': url,
      'homepage': website,
      'favicon': image,
    };

    if (id != null) {
      map['changeuuid'] = id;
    }

    return map;
  }
}
