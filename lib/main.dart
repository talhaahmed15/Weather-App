import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:weather_app/Controller/favorite_controller.dart';
import 'package:weather_app/Controller/theme_controller.dart';
import 'package:weather_app/Controller/weather_controller.dart';
import 'package:weather_app/Screens/home_screen.dart';
import 'package:weather_app/Services/notification_service.dart';
import 'services/weather_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();
  await GetStorage.init();

  final weatherService = WeatherService("e0bef66a762757cc1b28ee2e97809f77");
  Get.put<WeatherController>(WeatherController(weatherService));
  Get.put<ThemeController>(ThemeController());
  Get.put<FavoritesController>(FavoritesController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: Get.find<ThemeController>().isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,
      home: HomeScreen(),
    );
  }
}
