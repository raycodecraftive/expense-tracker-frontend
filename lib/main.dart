import 'package:expense_tracker_frontend1/pages/home_page.dart';
import 'package:expense_tracker_frontend1/pages/login.dart';
import 'package:expense_tracker_frontend1/viewmodels/auth_viewmodel.dart';
import 'package:expense_tracker_frontend1/viewmodels/expense_viewmodel.dart';
import 'package:expense_tracker_frontend1/viewmodels/profile_viewmodel.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExpenseViewmodel()),
        ChangeNotifierProvider(create: (_) => AuthViewmodel()),
        ChangeNotifierProvider(create: (_) => ProfileViewmodel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => checkSession());
    super.initState();
  }

  void checkSession() async {
    // Check if the user is logged in

    bool isLoggedIn = false;
    var storage = const FlutterSecureStorage();
    String? token = await storage.read(key: 'token');
    context.read<ProfileViewmodel>().getProfile();

    isLoggedIn = true;

    // If the user is logged in, navigate to the HomeScreen

    if (isLoggedIn) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Login()));
    }

    // If the user is not logged in, navigate to the LoginScreen
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CupertinoActivityIndicator(
            radius: 10,
            color: Colors.black,
          ),
          SizedBox(height: 10),
          Text("Checking Your Session...")
        ],
      )),
    );
  }
}
