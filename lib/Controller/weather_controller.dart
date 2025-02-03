import 'package:get/get.dart';
import 'package:weather_app/Model/weather.dart';
import 'package:weather_app/Services/notification_service.dart';
import '../services/weather_service.dart';

class WeatherController extends GetxController {
  final WeatherService _weatherService;
  final Rx<Weather?> _currentWeather = Rx<Weather?>(null);
  final RxBool _isLoading = false.obs;
  final RxString _error = ''.obs;

  WeatherController(this._weatherService);

  Weather? get currentWeather => _currentWeather.value;
  bool get isLoading => _isLoading.value;
  String? get error => _error.value;

  void clearWeather() {
    _currentWeather.value = null;
    _error.value = '';
  }

  Future<void> fetchWeather(String city) async {
    try {
      _isLoading.value = true;
      _error.value = '';

      final data = await _weatherService.getWeather(city);
      _currentWeather.value = Weather.fromJson(data);

      // Check for temperature alert
      if (_currentWeather.value!.temperature > 30) {
        _showTemperatureAlert();
      }
    } catch (e) {
      _error.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading.value = false;
    }
  }

  void _showTemperatureAlert() {
    NotificationService.showNotification(
      title: 'High Temperature Alert!',
      body:
          '${currentWeather!.temperature.toStringAsFixed(1)}°C in ${currentWeather!.city}',
    );
  }
}
