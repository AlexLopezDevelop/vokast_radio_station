import 'package:vokast/services/webservice.dart';

import '../config.dart';
import '../models/radio.dart';
import 'db_service.dart';

class DBDownloadService {
  static Future<bool> isLocalDBAvailable() async {
    try {
      await DB.init();
      List<Map<String, dynamic>> results = await DB.query(RadioModel.tableName);

      return results.isEmpty ? false : true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<RadioAPIModel> fetchAllRadios(url) async {
    final serviceResponse =
        await WebService().getData(url, RadioAPIModel(data: []));
    return serviceResponse as RadioAPIModel;
  }

  static Future<List<RadioModel>> fetchRadios() async {
    RadioAPIModel radioAPIModel = await fetchAllRadios(Config.apiUrl);
    return radioAPIModel.data;
  }

  static Future<List<RadioModel>> fetchTopRadios() async {
    RadioAPIModel radioAPIModel = await fetchAllRadios(Config.topRadioUrl);
    return radioAPIModel.data;
  }

  static Future<List<RadioModel>> fetchLocalDB(url) async {
    try {
      if (!await isLocalDBAvailable()) {
        RadioAPIModel radioAPIModel = await fetchAllRadios(url);
        if (radioAPIModel.data.isNotEmpty) {
          await DB.init();

          for (var element in radioAPIModel.data) {
            await DB.insert(RadioModel.tableName, element);
          }
        }
      }

      List<Map<String, dynamic>> results = await DB.query(RadioModel.tableName);

      List<RadioModel> radioModel = <RadioModel>[];
      radioModel = results.map((e) => RadioModel.fromMap(e)).toList();

      return radioModel;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
