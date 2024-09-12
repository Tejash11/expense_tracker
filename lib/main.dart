import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:smart_expense_tracker/model/transaction_model.dart';
import 'package:smart_expense_tracker/screens/budget_calculator.dart';
import 'package:smart_expense_tracker/screens/dashboard.dart';
import 'package:smart_expense_tracker/screens/home.dart';
import 'package:smart_expense_tracker/screens/login_page.dart';
import 'package:smart_expense_tracker/screens/onboarding1.dart';
import 'package:smart_expense_tracker/screens/onboarding2.dart';
import 'package:smart_expense_tracker/screens/profile.dart';
import 'package:smart_expense_tracker/screens/register_page.dart';
import 'package:smart_expense_tracker/screens/savings.dart';
import 'package:smart_expense_tracker/screens/splashscreen.dart';
import 'package:smart_expense_tracker/screens/transaction.dart';

void main() async{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor:
      brightness == Brightness.light ? Colors.white : Colors.black,
      statusBarIconBrightness:
      brightness == Brightness.light ? Brightness.dark : Brightness.light,
    ));

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/onboarding1' : (context) => Onboarding1(),
        '/onboarding2' : (context) => Onboarding2(),
        '/login_page' : (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/dashboard' : (context) => Dashboard(),
        '/home' : (context) => Home(),
        '/transaction' : (context) => Transaction(transactions: [],),
        '/savings' : (context) => Savings(),
        '/profile' : (context) => Profile(),
        'budget_calculator' : (context) => BudgetCalculatorPage(),
      },
    );
  }
}