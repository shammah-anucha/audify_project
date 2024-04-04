import 'package:audio_book_app/providers/audios.dart';
import 'package:audio_book_app/providers/books.dart';
// import 'package:audio_book_app/screens/audio_page_screen.dart';
import 'package:audio_book_app/screens/audio_player_screen.dart';
import 'package:audio_book_app/screens/converting_screen.dart';
import 'package:audio_book_app/screens/home_screen.dart';
import 'package:audio_book_app/screens/login_screen.dart';
import 'package:audio_book_app/screens/logout_screen.dart';
import 'package:audio_book_app/screens/mylibrary_screen.dart';
import 'package:audio_book_app/screens/signup_screen.dart';
// import 'package:audio_book_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/auth.dart';

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
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Books(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Audios(),
        ),
      ],
      child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
                  title: 'Audify',
                  theme: ThemeData(
                    colorScheme: ColorScheme.fromSeed(
                        seedColor: Colors.orange, secondary: Colors.deepOrange),
                    primaryColor: Colors.orange,
                    useMaterial3: true,
                  ),
                  home: auth.isAuth
                      ? const HomeScreen()
                      // : FutureBuilder(
                      // future: auth.tryAutoLogin(),
                      // builder: (ctx, authResultSnapshot) =>
                      // authResultSnapshot.connectionState ==
                      // ConnectionState.waiting
                      // ? SplashScreen()
                      : AuthScreen(),
                  // ),
                  routes: {
                    HomeScreen.routeName: (ctx) => const HomeScreen(),
                    ConvertingScreen.routeName: (ctx) =>
                        const ConvertingScreen(),
                    LogoutScreen.routeName: (ctx) => const LogoutScreen(),
                    MyLibraryScreen.routeName: (ctx) => const MyLibraryScreen(),
                    SignUpScreen.routeName: (ctx) => SignUpScreen(),
                    AuthScreen.routeName: (ctx) => AuthScreen(),
                    AudioPlayerScreen.routeName: (ctx) =>
                        const AudioPlayerScreen(),
                    // AudioPage.routeName: (ctx) => const AudioPage()
                  })),
    );
  }
}
