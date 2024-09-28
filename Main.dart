import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(WeatherApp());

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  final String apiKey = 'YOUR_API_KEY';  // Add your API key here
  String cityName = "London";
  var temperature;
  var description;
  var humidity;
  var windSpeed;

  Future<void> fetchWeather(String city) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        temperature = data['main']['temp'];
        description = data['weather'][0]['description'];
        humidity = data['main']['humidity'];
        windSpeed = data['wind']['speed'];
      });
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeather(cityName);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Weather App"),
          backgroundColor: Colors.blueAccent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter City Name',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) {
                  setState(() {
                    cityName = value;
                    fetchWeather(cityName);
                  });
                },
              ),
              SizedBox(height: 20),
              if (temperature != null)
                Column(
                  children: [
                    Text(
                      '$cityName',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${temperature.toString()}°C',
                      style: TextStyle(fontSize: 40),
                    ),
                    Text(
                      description.toString().toUpperCase(),
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    Text('Humidity: $humidity%'),
                    Text('Wind Speed: $windSpeed m/s'),
                  ],
                )
              else
                CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
