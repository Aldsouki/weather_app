import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = 'f620c093650d4a04a4311454242709'; // Add your API key here
  final String baseUrl = 'https://api.weatherapi.com/v1';

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    final response = await http.get(
      Uri.parse('$baseUrl/current.json?key=$apiKey&q=$city'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
