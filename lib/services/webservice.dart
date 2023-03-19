import 'dart:convert';

import 'package:vokast/models/base_model.dart';
import 'package:http/http.dart' as http;

class WebService {
  Future<BaseModel> getData(String url, BaseModel baseModel) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {

      List<dynamic> list = json.decode(response.body);
      baseModel.fromJson(list);

      return baseModel;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
