import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather/models/weather.dart';

Future<Weather> fetchWeather() async {
  final url = 'https://api.openweathermap.org/data/2.5/weather?q=Paris,fr&units=metric&APPID=8026186ef6bf29fdb211a2cc3b2a6d2b';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    //print ('JSON récupéré : ${response.body}');
    return Weather.fromJson(json.decode(response.body));
  } else {
    throw Exception('Erreur chargement météo');
  }
}
