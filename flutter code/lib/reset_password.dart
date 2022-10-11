import 'dart:convert';

import 'package:billing_system/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _oldpass = TextEditingController();
  final _newpassword = TextEditingController();
  final _renewpassword = TextEditingController();

  Future restpassapicall() async {
    http.Response response;
    response = await http.post(
      Uri.parse('https://mibillingsystem.herokuapp.com/resetPassword'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(
          {"old_password": _oldpass.text, "new_password": _newpassword.text}),
    );
    final data = jsonDecode(response.body);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Reset Password',
            style: TextStyle(
                fontSize: 30,
                color: Color(0xFFFE6709),
                fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              controller: _oldpass,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFE6709))),
                  focusColor: Color(0xFFFE6709),
                  labelText: 'Enter Old Password',
                  labelStyle: TextStyle(color: Color(0xFF000000)),
                  border: OutlineInputBorder(),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Color(0xFFFE6709),
                  ))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              controller: _newpassword,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFE6709))),
                  labelText: 'Enter New Password',
                  labelStyle: TextStyle(color: Color(0xFF000000)),
                  border: OutlineInputBorder(),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Color(0xFFFE6709),
                  ))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              controller: _renewpassword,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFE6709))),
                  focusColor: Color(0xFFFE6709),
                  labelText: 'Re-enter New Password',
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
              onPressed: () async {
                // print(_newpassword.text);
                // print(_renewpassword.text);
                if (_newpassword.text == _renewpassword.text) {
                  var data = await restpassapicall();
                  if (data['status'] == 'SUCCESS') {
                    showDialog(
                      context: context,
                      barrierDismissible: false, // user must tap button!

                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Success'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: const [
                                Text('Password Reset Successful'),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: const Text('Ok'),
                              onPressed: () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    loginRoute, (route) => false);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    showDialog(
                      context: context,
                      barrierDismissible: false, // user must tap button!

                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Wrong Password'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: const [
                                Text('You have inputted wrong old password'),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: const Text('Ok'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                } else {
                  showDialog(
                    context: context,
                    barrierDismissible: false, // user must tap button!

                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('No Match'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: const [
                              Text('The new passwords do not match'),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: const Text('Ok'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFE7609)),
              child: const Text(
                'Reset',
                style: TextStyle(fontSize: 25),
              ),
            ),
          )
        ],
      ),
    );
  }
}
