import 'dart:convert';

import 'package:billing_system/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;

class ReviewOrderView extends StatefulWidget {
  final orderDetails;
  final ordernameDetails;
  const ReviewOrderView(
      {super.key, required this.orderDetails, required this.ordernameDetails});
  @override
  State<ReviewOrderView> createState() => _ReviewOrderViewState();
}

class _ReviewOrderViewState extends State<ReviewOrderView> {
  List<DropdownMenuItem<String>> paymentMethods = [
    DropdownMenuItem(child: Text("Cash"), value: "Cash"),
    DropdownMenuItem(child: Text("UPI"), value: "UPI"),
    DropdownMenuItem(child: Text("Card"), value: "Card"),
  ];
  String selectedValue = "Cash";

  final _cardnumber = TextEditingController();
  final _cardexpiry = TextEditingController();
  final _cardcvv = TextEditingController();
  final _senderupi = TextEditingController();

  @override
  void initState() {
    widget.orderDetails['payment_type'] = 0;
    widget.orderDetails['cardnumber'] = '';
    widget.orderDetails['cardexpiry'] = '';
    widget.orderDetails['cardcvv'] = '';
    widget.orderDetails['senders_upi'] = '';
    calcfinalamount();
    super.initState();
  }

  Future openCardDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Card Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(hintText: 'Card Number'),
              controller: _cardnumber,
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Card Expiry'),
              controller: _cardexpiry,
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Card CVV'),
              controller: _cardcvv,
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () {
                setState(() {
                  widget.orderDetails['payment_type'] = 2;
                  widget.orderDetails['cardnumber'] = _cardnumber.text;
                  widget.orderDetails['cardexpiry'] = _cardexpiry.text;
                  widget.orderDetails['cardcvv'] = _cardcvv.text;
                  Navigator.of(context).pop();
                });
              },
              autofocus: true,
              child: const Text('Submit')),
        ],
      ),
    );
  }

  Future openUpiDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter UPI Details'),
        content: TextField(
          decoration: const InputDecoration(hintText: 'UPI ID'),
          controller: _senderupi,
        ),
        actions: [
          TextButton(
              onPressed: () {
                setState(() {
                  widget.orderDetails['payment_type'] = 1;
                  widget.orderDetails['senders_upi'] = _senderupi.text;
                  Navigator.of(context).pop();
                });
              },
              autofocus: true,
              child: const Text('Submit')),
        ],
      ),
    );
  }

  void _showcontent() {
    showDialog(
      context: context, barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: const [
                Text('How do you want to recieve your invoice?'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Whatsapp'),
              onPressed: () {
                widget.orderDetails['communication_type'] = 'whatsapp';
                createorderapicall();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(splashScreen, (route) => false);
              },
            ),
            TextButton(
              child: const Text('Email'),
              onPressed: () {
                widget.orderDetails['communication_type'] = 'email';
                createorderapicall();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(splashScreen, (route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  Future createorderapicall() async {
    http.Response response;
    response = await http.post(
        Uri.parse('https://mibillingsystem.herokuapp.com/createOrder'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(widget.orderDetails));
    final data = jsonDecode(response.body);
  }

  void calcfinalamount() {
    var amount = widget.orderDetails['amount'];
    var loyalty = widget.orderDetails['loyalty_points'];
    if (amount - loyalty < 0) {
      amount = 0;
      loyalty = loyalty - amount;
    } else {
      amount = amount - loyalty;
      loyalty = 0;
    }
    widget.orderDetails['final_amount'] = amount;
    widget.orderDetails['loyalty_points'] = loyalty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: 450,
                width: 400,
                decoration: const BoxDecoration(
                    color: Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Review Order Details',
                        style: TextStyle(fontSize: 25),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Products ordered : ${widget.ordernameDetails['products'].join(', ')}',
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Coupon Used : ${widget.orderDetails['coupon_name']}',
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Total Amount : ${widget.orderDetails['amount']}',
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Your Loyalty Points : ${widget.orderDetails['loyalty_points']}',
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Final Amount : ${widget.orderDetails['final_amount']}',
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Select Your Payment Method : ',
                            style:
                                TextStyle(fontSize: 20, color: Colors.black)),
                        DropdownButton(
                          iconSize: 30,
                          iconEnabledColor: const Color(0xFFFE6709),
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black),
                          items: paymentMethods,
                          value: selectedValue,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedValue = newValue!;
                              if (selectedValue == 'Card') {
                                openCardDialog();
                              } else if (selectedValue == 'UPI') {
                                openUpiDialog();
                              } else if ((selectedValue == 'Cash')) {
                                widget.orderDetails['payment_type'] = 0;
                              }
                            });
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 50,
              width: 150,
              child: ElevatedButton(
                // <-- ElevatedButton
                onPressed: _showcontent,
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE74C3C),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: const Text(
                  'Generate Invoice',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
