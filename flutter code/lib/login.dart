import 'dart:convert';

import 'package:billing_system/constants/routes.dart';
import 'package:billing_system/views/manager/analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _phone = TextEditingController();
  final _password = TextEditingController();

  Future loginapicall() async {
    http.Response response;
    response = await http.post(
      Uri.parse('https://mibillingsystem.herokuapp.com/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"phone": _phone.text, "password": _password.text}),
    );
    final data = jsonDecode(response.body);
    if (data['status'] == 'SUCCESS') {
      print(data['type']);
      if (data['type'] == 2) {
        setState(() {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(adminRoute, (route) => false);
        });
      } else if (data['type'] == 3) {
        setState(() {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(customerRoute, (route) => false);
        });
      } else if (data['type'] == 0) {
        setState(() {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(cashierRoute, (route) => false);
        });
      } else {
        setState(() {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(managerRoute, (route) => false);
        });
      }
    } else {
      return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Invalid Login"),
          content: const Text("Please enter correct credentials"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text("Ok"),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.login,
            color: Color(0xFFFE6709),
            size: 100,
            semanticLabel: 'LOGIN',
          ),
          const Text(
            'LOGIN',
            style: TextStyle(
                fontSize: 30,
                color: Color(0xFFFE6709),
                fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFE6709))),
                  focusColor: Color(0xFFFE6709),
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(color: Color(0xFF000000)),
                  border: OutlineInputBorder(),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Color(0xFFFE6709),
                  ))),
            ),
          ),
          const SizedBox(height: 0),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              controller: _password,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFE6709))),
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Color(0xFF000000)),
                  border: OutlineInputBorder(),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Color(0xFFFE6709),
                  ))),
            ),
          ),
          SizedBox(
            width: 200,
            height: 40,
            child: ElevatedButton(
              onPressed: loginapicall,
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFE7609)),
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 25),
              ),
            ),
          )
        ],
      ),
    );
  }
}
