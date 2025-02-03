import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const _baseUrl = 'https://api.openweathermap.org/data/2.5';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Map<String, dynamic>> getWeather(String city) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/weather?q=$city&appid=$apiKey'),
    );

    print(Uri.parse('$_baseUrl/weather?q=$city&appid=$apiKey'));
    print("Response: ${response.body}");

    if (response.statusCode != 200) throw Exception('Failed to load weather');
    return json.decode(response.body);
  }
}
