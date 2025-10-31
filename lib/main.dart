import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Pages/LoginPage.dart';
import 'Pages/HomePage.dart';
import 'repository/theme_manager.dart';
import 'repository/auth_repository.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  static final GlobalKey<_MyAppState> navigatorKey = GlobalKey<_MyAppState>();
  
  const MyApp({super.key});
  
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;
  bool _isLoggedIn = false;
  final AuthRepository _authRepository = AuthRepository();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await _authRepository.loadCurrentUser();
    setState(() {
      _isLoggedIn = _authRepository.isLoggedIn();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.grey,
        ),
      ),
      themeMode: ThemeManager.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: _isLoading 
        ? const Scaffold(
            backgroundColor: Color(0xFF54A781),
            body: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          )
        : _isLoggedIn ? const HomePage() : const LoginPage(),
    );
  }
  
  void updateTheme() {
    setState(() {});
  }
}