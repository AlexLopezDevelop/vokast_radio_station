import 'dart:convert';

import 'package:vokast/models/base_model.dart';
import 'package:http/http.dart' as http;

class WebService {
  Future<BaseModel> getData(String url, BaseModel baseModel) async {
    final response = await http.get(Uri.parse(url), headers: {
      'X-RapidAPI-Key': 'a0691df800mshff723f7acab4995p1d8626jsn83f1d693a6dd',
      'X-RapidAPI-Host': 'radio-world-75-000-worldwide-fm-radio-stations.p.rapidapi.com'
    });

    if (response.statusCode == 200) {

      Map<String, dynamic> map = json.decode(response.body);
      baseModel.fromJson(map);

      print(url);
      print(baseModel);

      return baseModel;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
