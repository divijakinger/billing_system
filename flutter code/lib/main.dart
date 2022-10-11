import 'dart:async';

import 'package:billing_system/constants/routes.dart';
import 'package:billing_system/views/admin/admin_home.dart';
import 'package:billing_system/views/cashier/cashier_profile.dart';
import 'package:billing_system/views/cashier/create_order.dart';
import 'package:billing_system/views/cashier/final_order_details.dart';
import 'package:billing_system/views/cashier/payment_success.dart';
import 'package:billing_system/views/cashier/phone_check.dart';
import 'package:billing_system/views/cashier/today_order.dart';
import 'package:billing_system/views/customer/customer_profile.dart';
import 'package:billing_system/views/customer/order_detail.dart';
import 'package:billing_system/views/customer/orders.dart';
import 'package:billing_system/views/manager/analytics.dart';
import 'package:billing_system/login.dart';
import 'package:billing_system/reset_password.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Noto Sans'),
      home: MyHomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        managerRoute: (context) => const Analytics(),
        customerRoute: (context) => const CustomerOrdersView(),
        cashierRoute: (context) => const TodayOrdersView(),
        customerProfile: (context) => const CustomerProfileView(),
        createCustomerOrder: (context) => const CreateOrderView(),
        splashScreen: (context) => const PaymentSuccess(),
        cashierProfile: (context) => const CashierProfile(),
        resetPass: (context) => const ResetPassword(),
        adminRoute: (context) => const AdminView()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 2),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginView())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //FE6709
      color: const Color(0xFFFE6709),
      height: 10,
      width: 10,
      padding: const EdgeInsets.all(50),
      child: Image.asset(
        'assets/images/mi_logo.png',
        scale: 0.3,
      ),
    );
  }
}
