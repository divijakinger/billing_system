import 'dart:async';
import 'dart:convert';

import 'package:billing_system/views/cashier/final_order_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;

class PhoneCheckView extends StatefulWidget {
  final orderDetails;
  final ordernameDetails;
  const PhoneCheckView(
      {super.key, required this.orderDetails, required this.ordernameDetails});

  @override
  State<PhoneCheckView> createState() => _PhoneCheckViewState();
}

class _PhoneCheckViewState extends State<PhoneCheckView> {
  List<Container> conts = [];

  final _firstname = TextEditingController();
  final _lastname = TextEditingController();
  final _email = TextEditingController();
  var user_id = -1;
  var loyalty_points = 0;

  Future createuserapicall() async {
    http.Response response;
    response = await http.post(
      Uri.parse('https://mibillingsystem.herokuapp.com/regCustomer'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "firstname": _firstname.text,
        'lastname': _lastname.text,
        'email': _email.text,
        'phone': _phone.text
      }),
    );
    final data = jsonDecode(response.body);
    return data;
  }

  Future userSuccess() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: Text('User Created Successfully'),
        actions: [
          TextButton(
              onPressed: () {
                setState(() {
                  Navigator.of(context).pop();
                });
              },
              autofocus: true,
              child: const Text('Ok')),
        ],
      ),
    );
  }

  void addCont(bool check, List data) {
    if (check == true) {
      user_id = data[0];
      loyalty_points = data[4];
      widget.orderDetails['user_id'] = user_id;
      widget.orderDetails['loyalty_points'] = loyalty_points;
      conts.clear();
      conts.add(
        Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: 450,
              width: 400,
              decoration: const BoxDecoration(
                  color: Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'USER DETAILS',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                    child: Text(
                      "Name : ${data[1]} ${data[2]}",
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                    child: Text(
                      'Email : ${data[3]}',
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      setState(() {});
    } else {
      conts.clear();
      conts.add(
        Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: 300,
              width: 400,
              decoration: const BoxDecoration(
                  color: Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                    child: TextFormField(
                      controller: _firstname,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'First Name',
                        labelStyle: TextStyle(color: Color(0xFF000000)),
                        filled: true,
                        fillColor: Color(0xFFF2F2F2),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF000000)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF000000)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                    child: TextFormField(
                      controller: _lastname,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Last Name',
                        labelStyle: TextStyle(color: Color(0xFF000000)),
                        filled: true,
                        fillColor: Color(0xFFF2F2F2),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF000000)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF000000)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                    child: TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Color(0xFF000000)),
                        filled: true,
                        fillColor: Color(0xFFF2F2F2),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF000000)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF000000)),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                      onPressed: () async {
                        var Userdata = await createuserapicall();
                        user_id = Userdata['user_id'];
                        widget.orderDetails['user_id'] = user_id;
                        userSuccess();
                      },
                      child:
                          const Text('Submit', style: TextStyle(fontSize: 15)))
                ],
              ),
            ),
          ),
        ),
      );
      setState(() {});
    }
  }

  final _phone = TextEditingController();

  Future phonecheckapicall() async {
    http.Response response;
    response = await http.post(
      Uri.parse('https://mibillingsystem.herokuapp.com/checkCustomer'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"phone": _phone.text}),
    );
    final data = jsonDecode(response.body);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    widget.orderDetails['user_id'] = user_id;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: Image.asset(
            'assets/images/mi_logo.png',
            width: 50,
            height: 50,
            color: const Color(0xFFFE7609),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Phone Number',
                      labelStyle: TextStyle(color: Color(0xFF000000)),
                      filled: true,
                      fillColor: Color(0xFFF2F2F2),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF000000)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF000000)),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 20.0, 0),
                    child: FloatingActionButton(
                      heroTag: 'checking',
                      onPressed: () async {
                        var data = await phonecheckapicall();
                        if (data['status'] == 'SUCCESS') {
                          addCont(true, data['data']);
                        } else {
                          addCont(false, []);
                        }
                      },
                      backgroundColor: const Color(0xFFFE7609),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                      // elevation: 5.0,
                    ),
                  ),
                ],
              ),
              ListView.builder(
                itemCount: conts.length,
                itemBuilder: (_, index) => conts[index],
                shrinkWrap: true,
              ),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: 65.0,
            width: 65.0,
            child: FittedBox(
              child: FloatingActionButton(
                heroTag: 'forward',
                onPressed: () {
                  setState(() {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ReviewOrderView(
                        orderDetails: widget.orderDetails,
                        ordernameDetails: widget.ordernameDetails,
                      ),
                    ));
                  });
                },
                backgroundColor: const Color(0xFFFE7609),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
                // elevation: 5.0,
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat);
  }
}
