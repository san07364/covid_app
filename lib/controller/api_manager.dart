import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../models/covid_data_model.dart';

// ignore: camel_case_types
class API_Manager {
  Box box;

  Future openBox() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('data');
    return;
  }

  Future putData(String data) async {
    await box.clear();
    box.add(data);
  }

  Future<CovidData> getData() async {
    await openBox();
    var client = http.Client();
    CovidData covidData;
    String jsString;

    try {
      var response = await client.get("https://api.covid19api.com/summary");
      String jsonString = response.body;
      //var jsonMap = json.decode(jsonString);
      await putData(jsonString);
      //covidData = CovidData.fromJson(jsonMap);
    } catch (SocketException) {
      print("no data");
    }

    jsString = box.getAt(0);

    if (jsString.isNotEmpty) {
      var jsonMap = json.decode(jsString);
      covidData = CovidData.fromJson(jsonMap);
    }
    return covidData;
  }

  void dispose() {
    box.close();
  }
}
