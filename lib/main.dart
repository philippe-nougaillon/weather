import 'package:flutter/material.dart';
import 'package:weather/services/fetch_weather.dart';
import 'models/weather.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  WeatherScreenState createState() => WeatherScreenState();
}

class WeatherScreenState extends State<WeatherScreen> {
  late Future<Weather> futureWeather;

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
                    Text('Description : ${weather.description}', style: TextStyle(fontSize: 22),),
                    Text('Température : ${weather.temperature}°', style: TextStyle(fontSize: 26)),
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

