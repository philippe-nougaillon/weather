import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Weather {
  final String description;
  final double temperature;
  final String iconCode;


  Weather({required this.description, required this.temperature, required this.iconCode});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      description: json['weather'][0]['description'], 
      temperature: json['weather']['temp'].toDouble(), 
      iconCode: json['weather'][0]['icon']
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();

}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Weather> futureWeather;

  Future<Weather> fetchWeather() async {
    final url = 'https://api.openweathermap.org/data/2.5/weather/q=Paris,fr&units=metrics&appid=8026186ef6bf29fdb211a2cc3b2a6d2b';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      //print ('JSON récupéré : ${response.body}');
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erreur chargement météo');
    }
  }

  @override
  void initState() {
    super.initState();
    futureWeather = fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(backgroundColor: Colors.indigo, 
          title: const Text("Météo Paris", style: TextStyle(color: Colors.white)),
        ),
        body: Center(
          child: FutureBuilder<Weather>(
            future: futureWeather, 
            builder: (BuildContext context, AsyncSnapshot<Weather> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Erreur :${snapshot.error}');
              } else if (snapshot.hasData) {
                final weather = snapshot.data!;
                final iconUrl = 'http://openweathermap.org/img/wn/${weather.iconCode}@2x.png';

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(iconUrl),
                    SizedBox(height: 20),
                    Text('Description: ${weather.description}'),
                    Text('Température: ${weather.temperature}'),
                  ],
                );
              } else {
                return Text('Aucune données');
              }
            },
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(WeatherScreen());
}

