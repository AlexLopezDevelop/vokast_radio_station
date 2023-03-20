import 'package:vokast/models/base_model.dart';
import 'package:vokast/models/db_model.dart';

class RadioAPIModel extends BaseModel {
  List<RadioModel> data;

  RadioAPIModel({
    required this.data,
  });

  @override
  fromJson(Map<String, dynamic> json) {
    data = (json['stations'] as List).map(
      (i) => RadioModel.fromJson(i),
    ).toList();
    print(data);
  }
}

class RadioModel extends DBBaseModel {
  static String tableName = 'radio';

  @override
  late final int id;
  late final String name;
  late final String url;
  late final String image;
  late final bool isFavorite;
  late final String? genre;

  RadioModel({
    required this.id,
    required this.name,
    required this.url,
    required this.image,
    required this.isFavorite,
    required this.genre,
  });

  factory RadioModel.fromJson(Map<String, dynamic> json) {
    return RadioModel(
      id: json['radio_id'],
      name: json['radio_name'],
      url: json['radio_url'],
      image: json['radio_image'],
      isFavorite: false,
      genre: json['genre'],
    );
  }

  static RadioModel fromMap(Map<String, dynamic> map) {
    return RadioModel(
        id: map['radio_id'],
        name: map['radio_name'],
        url: map['radio_url'],
        image: map['radio_image'],
        isFavorite: map['isFavorite'] == 1 ? true : false,
        genre: map['genre']);
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'radio_name': name,
      'radio_url': url,
      'radio_image': image,
    };

    if (id != null) {
      map['radio_id'] = id;
    }

    return map;
  }
}
