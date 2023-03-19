import 'package:vokast/services/webservice.dart';

import '../config.dart';
import '../models/radio.dart';
import 'db_service.dart';

class DBDownloadService {
  static Future<bool> isLocalDBAviable() async {
    await DB.init();
    List<Map<String, dynamic>> results = await DB.query(RadioModel.tableName);
    return results.isEmpty ? false : true;
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
}
