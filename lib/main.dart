import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
//TODO: 1:14:22

// provider scope
void main() {
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Weather App'),
    );
  }
}

// Hardcoded list of cities
enum City {
  stockholm,
  paris,
  tokyo,
  newYork,
}

// A weather emoji is a string
typedef WeatherEmoji = String;

// Simulates api call for getting the weather for a city
Future<WeatherEmoji> getWeather(City city) {
  return Future.delayed(
    const Duration(seconds: 1),
    () =>
        {
          City.stockholm: "❄️",
          City.paris: "🌧",
          City.tokyo: "🌬",
        }[city] ??
        "?",
  );
}

// City weather state; will be changed by the UI
final currentCityProvider = StateProvider<City?>((ref) => null);

// UI writes to this; if the weather is unknown, we return a question mark emoji
const unknownWeatherEmoji = "❓";

// UI reads this; listens for changes in the currentCityProvider
final weatherProvider = FutureProvider<WeatherEmoji>((ref) {
  final city = ref.watch(currentCityProvider);
  if (city != null) {
    return getWeather(city);
  } else {
    return unknownWeatherEmoji;
  }
});

// Home page screen
class MyHomePage extends ConsumerWidget {
  /// Init homepage
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  /// The title of the homepage
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
      ),
    );
  }
}
