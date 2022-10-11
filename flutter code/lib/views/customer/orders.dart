import 'dart:convert';
import 'package:billing_system/constants/routes.dart';
import 'package:billing_system/views/customer/customer_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;

import 'order_detail.dart';

class CustomerOrdersView extends StatefulWidget {
  const CustomerOrdersView({super.key});

  @override
  State<CustomerOrdersView> createState() => _CustomerOrdersViewState();
}

class _CustomerOrdersViewState extends State<CustomerOrdersView> {
  List allOrders = [];

  Future customerordersapicall() async {
    http.Response response;
    response = await http.get(
      Uri.parse('https://mibillingsystem.herokuapp.com/getCustomerOrders'),
      headers: {'Content-Type': 'application/json'},
    );
    final data = jsonDecode(response.body);
    allOrders = data['data'];

    setState(() {});
  }

  @override
  void initState() {
    customerordersapicall();
    super.initState();
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
                      builder: (context) => CustomerProfileView()));
            },
          )
        ],
        title: const Text(
          'YOUR ORDERS',
          style: TextStyle(
              color: Color(0xFFFE7609),
              fontWeight: FontWeight.bold,
              fontSize: 30),
        ),
      ),
      body: Column(
        children: [getCustomerOrders()],
      ),
    );
  }

  Widget getCustomerOrders() {
    return Expanded(
      child: GridView.builder(
          itemCount: allOrders.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemBuilder: (context, index) {
            var cat_icon;
            if (allOrders[index]['category'] == 'Phone') {
              cat_icon = const Icon(
                Icons.phone_iphone,
                size: 30,
                color: Colors.white,
              );
            } else if (allOrders[index]['category'] == 'Laptop') {
              cat_icon = const Icon(
                Icons.laptop_mac,
                size: 30,
                color: Colors.white,
              );
            } else if (allOrders[index]['category'] == 'Tv') {
              cat_icon = const Icon(
                Icons.tv,
                size: 30,
                color: Colors.white,
              );
            } else {
              cat_icon = const Icon(
                Icons.headphones,
                size: 30,
                color: Colors.white,
              );
            }
            return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 150,
                  width: 180,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SingleOrderDetail(
                                orderDetails: allOrders[index]),
                          ));
                    },
                    child: Card(
                      elevation: 20,
                      color: const Color(0xFFC33500),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: cat_icon,
                            onTap: () {},
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            '${allOrders[index]['product_name']}',
                            style: const TextStyle(
                                fontSize: 20, color: Color(0xFFFFFFFF)),
                          )
                        ],
                      ),
                    ),
                  ),
                ));
          }),
    );
  }
}
