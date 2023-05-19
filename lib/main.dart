import 'package:flutter/material.dart';
import 'package:music_player/category_choose_screen.dart';
import 'package:music_player/forgot_screen.dart';
import 'package:music_player/login_screen.dart';
import 'package:music_player/provider/auth.dart';
import 'package:music_player/provider/songsProvider.dart';
import 'package:music_player/signUp_scrern.dart';
import 'package:music_player/splash_screen.dart';
import 'package:music_player/tracks.dart';
import 'package:provider/provider.dart';

import 'music_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(value: SongsProvider())
      ],
      child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
                title: 'Music Player',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                home: auth.userId == null
                    ? FutureBuilder(
                        future: auth.tryAutoLogin(),
                        builder: (ctx, authResultSnapshot) {
                          if (authResultSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Scaffold(
                              body: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          return auth.isAuth == true
                              ? SplashScreen(
                                  isLogged: true,
                                )
                              : SplashScreen(
                                  isLogged: false,
                                );
                        })
                    : SplashScreen(
                        isLogged: true,
                      ),
                debugShowCheckedModeBanner: false,
              )),
    );
  }
}
