import 'package:billing_system/views/cashier/cashier_profile.dart';
import 'package:billing_system/views/cashier/create_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../constants/routes.dart';

class TodayOrdersView extends StatefulWidget {
  const TodayOrdersView({super.key});

  @override
  State<TodayOrdersView> createState() => _TodayOrdersViewState();
}

class _TodayOrdersViewState extends State<TodayOrdersView> {
  List allOrders = [];

  Future allordersapicall() async {
    http.Response response;
    response = await http.get(
      Uri.parse('https://mibillingsystem.herokuapp.com/getCashierOrders'),
      headers: {'Content-Type': 'application/json'},
    );
    final data = jsonDecode(response.body);
    allOrders = data['data'];

    setState(() {});
  }

  @override
  void initState() {
    allordersapicall();
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
          'TODAY',
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
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.account_circle,
              color: Color(0xFFFE6709),
              size: 35,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CashierProfile()));
            },
          )
        ],
      ),
      body: Column(
        children: [
          ordersList(),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: 65.0,
          width: 65.0,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateOrderView()));
              },
              backgroundColor: const Color(0xFFFE7609),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              // elevation: 5.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget ordersList() {
    return Expanded(
      child: ListView.builder(
          itemCount: allOrders.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                        'Payment Method: ${allOrders[index]['payment_method']}'),
                    subtitle:
                        Text('${allOrders[index]['products'].join(', ')}'),
                    trailing: Text('Amount: ₹${allOrders[index]['amount']}'),
                    tileColor: const Color(0xFFF0F0F0),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
