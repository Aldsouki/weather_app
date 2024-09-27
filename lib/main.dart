import 'package:flutter/material.dart';
import 'package:weather_app/weather_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,  // Match the Figma dark theme
      ),
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final _cityController = TextEditingController();
  Map<String, dynamic>? _weatherData;
  bool _loading = false;

  Future<void> _fetchWeather() async {
    setState(() {
      _loading = true;
    });

    try {
      WeatherService service = WeatherService();
      final data = await service.fetchWeather(_cityController.text);
      setState(() {
        _weatherData = data;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print('Error fetching weather: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Enter City',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchWeather,
              child: Text('Get Weather'),
            ),
            SizedBox(height: 20),
            _loading
                ? CircularProgressIndicator()
                : _weatherData != null
                    ? Column(
                        children: [
                          Text(
                            _weatherData!['location']['name'],
                            style: TextStyle(fontSize: 24),
                          ),
                          Text(
                            '${_weatherData!['current']['temp_c']}°C',
                            style: TextStyle(fontSize: 40),
                          ),
                          Image.network(
                            'https:${_weatherData!['current']['condition']['icon']}',
                            scale: 1.5,
                          ),
                          Text(
                            _weatherData!['current']['condition']['text'],
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      )
                    : Text('No data available'),
          ],
        ),
      ),
    );
  }
}
