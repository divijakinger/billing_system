import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:math';
import 'dart:ui';
import 'package:http/http.dart' as http;

import '../../constants/routes.dart';
import '../../reset_password.dart';

class CashierProfile extends StatefulWidget {
  const CashierProfile({super.key});

  @override
  State<CashierProfile> createState() => _CashierProfileState();
}

class _CashierProfileState extends State<CashierProfile> {
  Future getdetailsapicall() async {
    http.Response response;
    response = await http.get(
      Uri.parse('https://mibillingsystem.herokuapp.com/getDetails'),
      headers: {'Content-Type': 'application/json'},
    );
    final data = jsonDecode(response.body);
    return data;

    // branchname = data['branch'];
    // firstname = data['firstname'];
    // lastname = data['lastname'];
    // id = data['id'];

    // setState(() {});
  }

  var futuredata;

  @override
  void initState() {
    futuredata = getdetailsapicall();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'PROFILE',
            style: TextStyle(
                color: Color(0xFFFE7609),
                fontWeight: FontWeight.bold,
                fontSize: 30),
          ),
          leading: Image.asset(
            'assets/images/mi_logo.png',
            width: 50,
            height: 50,
            color: const Color(0xFFFE7609),
          ),
        ),
        body: FutureBuilder(
          future: futuredata,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data as Map;
              return Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: Color(0xFF757575),
                          ),
                          child: Center(
                            child: Text(
                              "${data['firstname'][0]}${data['lastname'][0]}",
                              style: const TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25),
                          child: Container(
                            height: 100,
                            width: 250,
                            child: Column(
                              children: [
                                Text(
                                  '${data['firstname']} ${data['lastname']}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 25, color: Color(0xFFFE7609)),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Cashier ID: ${data['id']}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20, color: Color(0xFF626262)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 250,
                  ),
                  SizedBox(
                    width: 250,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ResetPassword()));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFE7609)),
                      child: const Text(
                        'Reset Password',
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 250,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              loginRoute, (route) => false);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFE7609)),
                      child: const Text(
                        'Log Out',
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  )
                ],
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ));
  }
}
