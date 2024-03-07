// import 'package:audio_book_app/models/audio_player_service.dart';
import 'package:audio_book_app/models/audio_player_service.dart';
import 'package:audio_book_app/providers/audios.dart';
import 'package:audio_book_app/providers/books.dart';
import 'package:audio_book_app/screens/audio_player_screen.dart';
import 'package:audio_book_app/screens/convertin_screen.dart';
import 'package:audio_book_app/screens/home_screen.dart';
import 'package:audio_book_app/screens/logout_screen.dart';
import 'package:audio_book_app/screens/mylibrary_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Books(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Audios(),
          ),
          ChangeNotifierProvider(
            create: (context) => AudioPlayerService(),
          ),
        ],
        child: MaterialApp(
            title: 'Audify',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.orange, secondary: Colors.deepOrange),
              primaryColor: Colors.orange,
              useMaterial3: true,
            ),
            home: const HomeScreen(),
            routes: {
              HomeScreen.routeName: (ctx) => const HomeScreen(),
              ConvertingScreen.routeName: (ctx) => const ConvertingScreen(),
              LogoutScreen.routeName: (ctx) => const LogoutScreen(),
              MyLibraryScreen.routeName: (ctx) => const MyLibraryScreen(),
              AudioPlayerScreen.routeName: (ctx) => const AudioPlayerScreen()
            }));
  }
}
