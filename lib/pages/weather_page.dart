import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/services/weather_service.dart';
import '../models/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService("YOUR API KEY");
  Weather? _weather;
  bool _isLoading = true;
  String? _errorMessage;

  Future<void> _fetchWeather() async {
    try {
      String cityName = await _weatherService.getCurrentCity();
      Weather weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
      if (kDebugMode) {
        print(e);
      }
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return "assets/sunny.json";

    switch (mainCondition.toLowerCase()) {
      case "clouds":
      case "mist":
      case "smoke":
      case "haze":
      case "dust":
      case "fog":
        return "assets/cloud.json";
      case "rain":
      case "drizzle":
      case "shower rain":
        return "assets/rain.json";
      case "thunderstorm":
        return "assets/thunder.json";
      case "clear":
        return "assets/sunny.json";
      default:
        return "assets/sunny.json";
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _errorMessage != null
            ? Text(
          _errorMessage!,
          style: const TextStyle(color: Colors.white, fontSize: 24),
          textAlign: TextAlign.center,
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _weather?.cityName ?? "Loading city...",
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
            const SizedBox(height: 20),
            _weather != null
                ? Lottie.asset(
              getWeatherAnimation(_weather?.mainCondition),
              height: 200,
            )
                : Container(),
            const SizedBox(height: 20),
            Text(
              "${_weather?.temperature.round()}°C",
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
            Text(
              _weather?.mainCondition ?? "",
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
