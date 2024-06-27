import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'home.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey="pk_test_51NkfZPQcTOlW4IdimsgJedt6Yh48183nWQsWen9OoOQojmPGO1b9coUJXDky8HBPXyEhNcvoZ4QripbP5Ye8PL6R00bCZWDVQK";
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:     const HomePage(),
      builder: EasyLoading.init(),
    );
  }
}