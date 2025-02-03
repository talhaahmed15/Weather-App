import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/Controller/favorite_controller.dart';
import 'package:weather_app/Controller/weather_controller.dart';

class FavoritesScreen extends StatelessWidget {
  final WeatherController _weatherController = Get.find();
  final FavoritesController _favController = Get.find();

  FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Cities')),
      body: Column(
        children: [
          // Weather display section
          Obx(() {
            if (_weatherController.isLoading) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              );
            }

            if (_weatherController.error!.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error: ${_weatherController.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (_weatherController.currentWeather == null) {
              return const SizedBox.shrink();
            }

            final weather = _weatherController.currentWeather!;
            return Card(
              margin: const EdgeInsets.all(16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      weather.city,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${weather.temperature.toStringAsFixed(1)}°C',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      weather.condition,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
            );
          }),

          // Favorites list
          Expanded(
            child: Obx(() => _favController.favorites.isEmpty
                ? const Center(
                    child: Text("You have no favorite cities yet"),
                  )
                : ListView.builder(
                    itemCount: _favController.favorites.length,
                    itemBuilder: (context, index) {
                      final city = _favController.favorites[index];
                      return ListTile(
                        title: Text(city),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _favController.removeFavorite(city),
                        ),
                        onTap: () {
                          // Clear previous weather data before fetching new
                          _weatherController.clearWeather();
                          _weatherController.fetchWeather(city);
                        },
                      );
                    },
                  )),
          ),
        ],
      ),
    );
  }
}
