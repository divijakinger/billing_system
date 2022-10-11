import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../constants/routes.dart';
import '../../reset_password.dart';
import 'package:http/http.dart' as http;

class AdminView extends StatefulWidget {
  const AdminView({super.key});

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    HomeView(),
    AllOrdersView(),
    AddCouponView(),
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
                  label: 'Products',
                  icon: Icon(Icons.inventory),
                ),
                BottomNavigationBarItem(
                  label: 'Users',
                  icon: Icon(Icons.group_add),
                ),
                BottomNavigationBarItem(
                  label: 'Coupons',
                  icon: Icon(Icons.local_offer),
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
  final _productname = TextEditingController();
  final _productprice = TextEditingController();
  final _productqty = TextEditingController();
  final _productype = TextEditingController();
  final _productwarranty = TextEditingController();
  // 1 - TV ,2 - Laptop, 3 - Phone, 4 - Headphone

  Future createproductapicall() async {
    http.Response response;
    response = await http.post(
        Uri.parse('https://mibillingsystem.herokuapp.com/addProduct'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': _productname.text,
          'price': _productprice.text,
          'qty': _productqty.text,
          'category': _productype.text,
          'warranty': _productwarranty.text
        }));
    final data = jsonDecode(response.body);
    print(data);
  }

  Future productDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Product Added Successfully'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Ok'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Image.asset(
          'assets/images/mi_logo.png',
          width: 50,
          height: 50,
          color: const Color(0xFFFE7609),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'ADD PRODUCT',
              style: TextStyle(
                  fontSize: 30,
                  color: Color(0xFFFE6709),
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                controller: _productname,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFE6709))),
                    focusColor: Color(0xFFFE6709),
                    labelText: 'Product Name',
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
                controller: _productprice,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFE6709))),
                    labelText: 'Product Price',
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
                controller: _productqty,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFE6709))),
                    labelText: 'Product Quantity',
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
                controller: _productype,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFE6709))),
                    labelText: 'Product Type',
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
                controller: _productwarranty,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFE6709))),
                    labelText: 'Product Warranty(in Days)',
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
                onPressed: () {
                  createproductapicall();
                  productDialog();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFE7609)),
                child: const Text(
                  'Add',
                  style: TextStyle(fontSize: 25),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AllOrdersView extends StatefulWidget {
  const AllOrdersView({super.key});

  @override
  State<AllOrdersView> createState() => _AllOrdersViewState();
}

class _AllOrdersViewState extends State<AllOrdersView> {
  final _firstname = TextEditingController();
  final _lastname = TextEditingController();
  final __phone = TextEditingController();
  var user_type = '0';
  var store_id = '1';

  List<DropdownMenuItem<String>> get dropstoredownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Upvan"), value: "1"),
      DropdownMenuItem(child: Text("Kopri"), value: "2"),
      DropdownMenuItem(child: Text("Evarard"), value: "3"),
      DropdownMenuItem(child: Text("Station"), value: "4"),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<String>> get dropuserdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Manager"), value: "1"),
      DropdownMenuItem(child: Text("Cashier"), value: "0"),
    ];
    return menuItems;
  }

  String selectedstoreValue = "1";
  String selecteduserValue = '0';

  Future createuserapicall() async {
    http.Response response;
    response = await http.post(
      Uri.parse('https://mibillingsystem.herokuapp.com/createWorker'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'firstname': _firstname.text,
        'lastname': _lastname.text,
        'type': user_type,
        'store_id': store_id,
        'phone': __phone.text
      }),
    );
    final data = jsonDecode(response.body);
    print(data);
  }

  Future userDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('User Added Successfully'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Ok'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Image.asset(
          'assets/images/mi_logo.png',
          width: 50,
          height: 50,
          color: const Color(0xFFFE7609),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'ADD USER',
              style: TextStyle(
                  fontSize: 30,
                  color: Color(0xFFFE6709),
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                controller: _firstname,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFE6709))),
                    focusColor: Color(0xFFFE6709),
                    labelText: 'First Name',
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
                controller: _lastname,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFE6709))),
                    labelText: 'Last Name',
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
                controller: __phone,
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
            DropdownButton(
                value: selecteduserValue,
                onChanged: (String? newValue) {
                  setState(() {
                    selecteduserValue = newValue!;
                  });
                },
                items: dropuserdownItems),
            DropdownButton(
                value: selectedstoreValue,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedstoreValue = newValue!;
                  });
                },
                items: dropstoredownItems),
            SizedBox(
              width: 200,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  createuserapicall();
                  userDialog();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFE7609)),
                child: const Text(
                  'Add',
                  style: TextStyle(fontSize: 25),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AddCouponView extends StatefulWidget {
  const AddCouponView({super.key});

  @override
  State<AddCouponView> createState() => _AddCouponViewState();
}

class _AddCouponViewState extends State<AddCouponView> {
  final _couponname = TextEditingController();
  final _coupondisc = TextEditingController();
  final _date = TextEditingController();

  Future createcouponapicall() async {
    http.Response response;
    response = await http.post(
        Uri.parse('https://mibillingsystem.herokuapp.com/addCoupon'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'coupon_name': _couponname.text,
          'discount': _coupondisc.text,
          'date': _date.text
        }));
    final data = jsonDecode(response.body);
  }

  Future couponDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Coupon Added Successfully'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Ok'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Image.asset(
          'assets/images/mi_logo.png',
          width: 50,
          height: 50,
          color: const Color(0xFFFE7609),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'ADD COUPON',
            style: TextStyle(
                fontSize: 30,
                color: Color(0xFFFE6709),
                fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              controller: _couponname,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFE6709))),
                  focusColor: Color(0xFFFE6709),
                  labelText: 'Coupon Name',
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
              controller: _coupondisc,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFE6709))),
                  labelText: 'Discount (in %)',
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
              controller: _date,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFE6709))),
                  labelText: 'Expiry (YYYY-MM-DD)',
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
              onPressed: () {
                createcouponapicall();
                couponDialog();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFE7609)),
              child: const Text(
                'Add',
                style: TextStyle(fontSize: 25),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  Future getadmindetailsapicall() async {
    http.Response response;
    response = await http.get(
      Uri.parse('https://mibillingsystem.herokuapp.com/getDetails'),
      headers: {'Content-Type': 'application/json'},
    );
    final data = jsonDecode(response.body);
    return data;
  }

  var futuredata;

  @override
  void initState() {
    futuredata = getadmindetailsapicall();
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
                                  style: const TextStyle(
                                      fontSize: 25, color: Color(0xFFFE7609)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Admin ID: ${data['id']}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
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
