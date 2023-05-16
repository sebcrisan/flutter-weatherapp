import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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

    /// The current weather (async)
    final currentWeather = ref.watch(weatherProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
      ),
      body: Column(
        children: [
          currentWeather.when(
              data: (data) => Text(data, style: const TextStyle(fontSize: 40),),
              error: (_, __) => const Text('Error'),
              loading: () => const Padding(
                padding:  EdgeInsets.all(8.0),
                child:  CircularProgressIndicator(),
              ),),
          Expanded(child: ListView.builder(itemCount: City.values.length, itemBuilder: (context, index){
            /// The city for which the weather will be retrieved
            final city = City.values[index];
            /// Boolean that is true when a city is selected, can be used to rebuild
            final isSelected = city == ref.watch(currentCityProvider);
            return ListTile(title: Text(city.toString()),
            trailing: isSelected ? const Icon(Icons.check) : null,
            onTap: (){
              ref.read(currentCityProvider.notifier).state = city;
            },);
          },)),
        ],
      ),
    );
  }
}
