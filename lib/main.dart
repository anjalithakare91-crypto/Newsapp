import 'package:flutter/material.dart';
import 'package:news_app/main_navigation_screen.dart';
import 'package:news_app/services/auth_service.dart';
import 'login.dart';

void main() {
  runApp(const NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "News Appp",
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const AppStart(),
    );
  }
}

class AppStart extends StatelessWidget {
  const AppStart({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService.isLoggedIn(),
      builder: (context, snapshot) {

        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data!) {
          return const MainNavigationScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}