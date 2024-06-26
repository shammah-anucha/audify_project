import 'package:audio_book_app/models/conversion.dart';
import 'package:audio_book_app/providers/audios.dart';
import 'package:audio_book_app/providers/books.dart';
import 'package:audio_book_app/providers/reset_password.dart';
import 'package:audio_book_app/screens/audio_player_screen.dart';
import 'package:audio_book_app/screens/converting_screen.dart';
import 'package:audio_book_app/screens/converting_second_screen.dart';
import 'package:audio_book_app/screens/home_screen.dart';
import 'package:audio_book_app/screens/login_screen.dart';
import 'package:audio_book_app/screens/logout_screen.dart';
import 'package:audio_book_app/screens/mylibrary_screen.dart';
import 'package:audio_book_app/screens/recover_password.dart';
import 'package:audio_book_app/screens/reset_password.dart';
import 'package:audio_book_app/screens/signup_screen.dart';
import 'package:audio_book_app/widgets/success.dart';
import 'package:audio_book_app/widgets/thankyou.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
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
        ChangeNotifierProvider(
          create: (ctx) => ForgotPassword(),
        ),
        ChangeNotifierProvider(
          create: (context) => ConversionModel(),
          child: const MyApp(),
        )
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
                      : const AuthScreen(),
                  // ),
                  routes: {
                    HomeScreen.routeName: (ctx) => const HomeScreen(),
                    ConvertingScreen.routeName: (ctx) =>
                        const ConvertingScreen(),
                    ConvertingSecondScreen.routeName: (ctx) =>
                        const ConvertingSecondScreen(),
                    LogoutScreen.routeName: (ctx) => const LogoutScreen(),
                    MyLibraryScreen.routeName: (ctx) => const MyLibraryScreen(),
                    SignUpScreen.routeName: (ctx) => const SignUpScreen(),
                    AuthScreen.routeName: (ctx) => const AuthScreen(),
                    AudioPlayerScreen.routeName: (ctx) =>
                        const AudioPlayerScreen(),
                    Thankyou.routeName: (ctx) => const Thankyou(),
                    RecoverPasswordScreen.routeName: (ctx) =>
                        const RecoverPasswordScreen(),
                    ResetPassWordScreen.routeName: (ctx) =>
                        const ResetPassWordScreen(),
                    SuccessScreen.routeName: (ctx) => const SuccessScreen(),
                    // AudioPage.routeName: (ctx) => const AudioPage()
                  })),
    );
  }
}
