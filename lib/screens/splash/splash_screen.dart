import 'package:flutter/material.dart';
import 'package:produtosapp/screens/home/home_screen.dart';
import 'package:produtosapp/screens/login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

class Splash extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<SharedPreferences>(
            future: SharedPreferences.getInstance(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }

              return SplashScreen(
                seconds: 5,
                navigateAfterSeconds: snapshot.data.getBool('isLogged') == true
                    ? HomeScreen()
                    : LoginScreen(),
                loaderColor: Colors.transparent,
              );
            },
          ),
          Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Desafio Mobile Flutter'),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('Gerenciador de produtos'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
