// import 'dart:html';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:math';
import 'dart:ui';

import '../../constants/routes.dart';
import 'package:http/http.dart' as http;

import '../../reset_password.dart';

class Analytics extends StatefulWidget {
  const Analytics({super.key});

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    HomeView(),
    AllOrdersView(),
    ProfileView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            boxShadow: [
              BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: const Color(0xFFC33500),
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white.withOpacity(.60),
              selectedFontSize: 14,
              unselectedFontSize: 14,
              onTap: _onItemTapped,

              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  label: 'Dashboard',
                  icon: Icon(Icons.home_filled),
                ),
                BottomNavigationBarItem(
                  label: 'Orders',
                  icon: Icon(Icons.shopping_cart),
                ),
                BottomNavigationBarItem(
                  label: 'Profile',
                  icon: Icon(Icons.account_circle),
                ),
              ],
              currentIndex: _selectedIndex,
              // selectedItemColor: Colors.amber[800],
            ),
          )),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List detailskeys = [];
  List detailsvalues = [];
  var data;

  Future analyticsapicall() async {
    http.Response response;
    response = await http.get(
      Uri.parse('https://mibillingsystem.herokuapp.com/orderAnalytics'),
      headers: {'Content-Type': 'application/json'},
    );
    final data = jsonDecode(response.body);

    // detailskeys = data.keys.toList();
    detailskeys = ['Best Selling Product', 'Total Sales'];
    if (data['status'] == 'SUCCESS') {
      print(data);
      detailsvalues.add(data['bestselling_product']);
      detailsvalues.add(data['total_sales']);
    } else {
      detailsvalues = ['', ''];
    }
    setState(() {});
  }

  @override
  void initState() {
    analyticsapicall();
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
            'ANALYTICS',
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
        body: Column(
          children: [getAnalytics()],
        ));
  }

  Widget getAnalytics() {
    return Expanded(
      child: GridView.builder(
          itemCount: detailskeys.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.all(10),
              color: const Color(0xFFF2F2F2),
              shadowColor: Colors.blueGrey,
              elevation: 10,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 20, 0, 0),
                    child: ListTile(
                      horizontalTitleGap: 16.0,
                      title: Text(
                        "${detailskeys[index]}",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFE6709)),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Text(
                          "${detailsvalues[index]}",
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class AllOrdersView extends StatefulWidget {
  const AllOrdersView({super.key});

  @override
  State<AllOrdersView> createState() => _AllOrdersViewState();
}

class _AllOrdersViewState extends State<AllOrdersView> {
  List allOrders = [];

  Future allordersapicall() async {
    http.Response response;
    response = await http.get(
      Uri.parse('https://mibillingsystem.herokuapp.com/getAllOrders'),
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
            'ORDERS',
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
        body: Column(
          children: [
            ordersList(),
          ],
        ));
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
                    title: Text('Order ID: ${allOrders[index]['order_id']}'),
                    subtitle: Text('${allOrders[index]['product'].join(', ')}'),
                    trailing: Text('Amount: ₹${allOrders[index]['price']}'),
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

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
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
                                    'Manager ID: ${data['id']}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20, color: Color(0xFF626262)),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: Text(
                                    'Branch: ${data['branch']}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20, color: Color(0xFF626262)),
                                  ),
                                )
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
                        Navigator.of(context).push(MaterialPageRoute(
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
