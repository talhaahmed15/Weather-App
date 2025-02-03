import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/Controller/favorite_controller.dart';
import 'package:weather_app/Controller/theme_controller.dart';
import 'package:weather_app/Controller/weather_controller.dart';
import 'package:weather_app/Model/weather.dart';
import 'package:weather_app/Screens/favorite_screen.dart';
import 'package:weather_app/Widgets/responsive_layout.dart';

class HomeScreen extends StatelessWidget {
  final _cityController = TextEditingController();
  final WeatherController _weatherController = Get.find();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Get.to(() => FavoritesScreen()),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Obx(() => Switch(
                  value: Get.find<ThemeController>().isDarkMode,
                  onChanged: (value) =>
                      Get.find<ThemeController>().toggleTheme(),
                )),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _cityController,
                      decoration: InputDecoration(
                        hintText: 'Enter city name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () =>
                        _weatherController.fetchWeather(_cityController.text),
                    child: const Text('Search'),
                  ),
                ],
              ),
            ),
            Expanded(flex: 9, child: Obx(() => _buildWeatherDisplay())),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherHeader() {
    return Obx(() {
      final weather = _weatherController.currentWeather;
      final favController = Get.find<FavoritesController>();

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            weather!.city,
          ),
          IconButton(
            icon: Icon(
              favController.isFavorite(weather.city)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () => favController.toggleFavorite(weather.city),
          ),
        ],
      );
    });
  }

  Widget _buildWeatherDisplay() {
    if (_weatherController.isLoading) {
      return Center(child: const CircularProgressIndicator());
    }

    if (_weatherController.error!.isNotEmpty) {
      return Center(
        child: Text(
          'Error: ${_weatherController.error}',
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    if (_weatherController.currentWeather == null) {
      return Center(child: const Text('Search for a city to get weather'));
    }

    return ResponsiveLayout(
      mobile: MobileWeatherDisplay(weather: _weatherController.currentWeather!),
      tablet: TabletWeatherDisplay(weather: _weatherController.currentWeather!),
    );
  }
}

class MobileWeatherDisplay extends StatelessWidget {
  final Weather weather;

  const MobileWeatherDisplay({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(weather.city,
                style: Theme.of(context).textTheme.headlineMedium),
            Obx(() {
              final favController = Get.find<FavoritesController>();
              return IconButton(
                icon: Icon(
                  favController.isFavorite(weather.city)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: () => favController.toggleFavorite(weather.city),
              );
            }),
          ],
        ),
        const SizedBox(height: 20),
        Text('${weather.temperature.toStringAsFixed(1)}°C',
            style: Theme.of(context).textTheme.displayMedium),
        const SizedBox(height: 20),
        Text(weather.condition,
            style: Theme.of(context).textTheme.headlineMedium),
      ],
    );
  }
}

class TabletWeatherDisplay extends StatelessWidget {
  final Weather weather;

  const TabletWeatherDisplay({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(weather.city,
                  style: Theme.of(context).textTheme.displaySmall),
              const SizedBox(height: 20),
              Text(weather.condition,
                  style: Theme.of(context).textTheme.displayMedium),
            ],
          ),
          Text('${weather.temperature.toStringAsFixed(1)}°C',
              style: Theme.of(context).textTheme.displayLarge),
        ],
      ),
    );
  }
}
