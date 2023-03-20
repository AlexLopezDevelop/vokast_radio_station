import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vokast/models/base_model.dart';
import 'package:http/http.dart' as http;

class WebService {
  Future<BaseModel> getData(String url, BaseModel baseModel) async {
    final apiKey = dotenv.env["API_KEY"] ?? "";
    print(apiKey);
    final response = await http.get(Uri.parse(url), headers: {
      'X-RapidAPI-Key': apiKey,
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
