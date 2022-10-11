import 'package:billing_system/constants/routes.dart';
import 'package:billing_system/views/cashier/phone_check.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateOrderView extends StatefulWidget {
  const CreateOrderView({super.key});

  @override
  State<CreateOrderView> createState() => _CreateOrderViewState();
}

class _CreateOrderViewState extends State<CreateOrderView> {
  List allProducts = [];
  List<String> allProductNames = [];
  List currentOrderNames = [];
  Map namePrice = {};
  List currentOrderIDs = [];
  Map nameID = {};
  String? temp = '';
  double total = 0;
  Map finalOrder = {};
  Map finalnameOrder = {};
  final _coupon = TextEditingController();
  String Coupon = '';
  var coupon_id = -1;
  bool unused_coupon = true;

  Future couponapicall() async {
    http.Response response;
    response = await http.post(
        Uri.parse('https://mibillingsystem.herokuapp.com/checkCoupon'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'coupon': _coupon.text}));
    final data = jsonDecode(response.body);
    // setState(() {});
    return data;
  }

  Future allproductsapicall() async {
    http.Response response;
    response = await http.get(
      Uri.parse('https://mibillingsystem.herokuapp.com/getAllProducts'),
      headers: {'Content-Type': 'application/json'},
    );
    final data = jsonDecode(response.body);
    print(data);
    allProducts = data['data'];
    for (var k in allProducts) {
      allProductNames.add(k[1]);
    }
    for (var k in allProducts) {
      nameID[k[1]] = k[0];
    }
    for (var k in allProducts) {
      namePrice[k[1]] = k[2];
    }

    setState(() {});
  }

  @override
  void initState() {
    allproductsapicall();
    super.initState();
  }

  void changeItem(String? s) {
    temp = s;
  }

  Future openDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter a Coupon Code'),
        content: TextField(
          decoration: const InputDecoration(hintText: 'Coupon Code'),
          controller: _coupon,
        ),
        actions: [
          TextButton(
            onPressed: () async {
              var coupon = await couponapicall();
              if (coupon['status'] == 'FAIL') {
                return showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Invalid Coupon'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            setState(() {
                              Navigator.of(context).pop();
                            });
                          },
                          child: Text('Ok'))
                    ],
                  ),
                );
              } else {
                Coupon = _coupon.text;
                total = total - (total * (coupon['data'][1] / 100));
                coupon_id = coupon['data'][0];
                unused_coupon = false;
                setState(() {
                  Navigator.of(context).pop();
                });
              }
            },
            child: const Text('Submit'),
            autofocus: true,
          ),
          TextButton(
              onPressed: () {
                setState(() {
                  Navigator.of(context).pop();
                });
              },
              child: const Text('Cancel'))
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
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: DropdownSearch<String>(
                popupProps:
                    const PopupPropsMultiSelection.menu(showSearchBox: true),
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF000000))),
                      focusColor: Color(0xFFFE7609),
                      labelText: 'Search for Product Here',
                      hintText: 'Product ID',
                      hintStyle: TextStyle(color: Color(0xFF263238)),
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xFF263238))),
                ),
                items: allProductNames,
                onChanged: changeItem,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 20.0, 0),
                child: SizedBox(
                  height: 50,
                  width: 150,
                  child: ElevatedButton.icon(
                    // <-- ElevatedButton
                    onPressed: () {
                      if (temp != '') {
                        setState(() {
                          currentOrderNames.add(temp);
                          total = total + namePrice[temp];
                          temp = '';
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.add,
                      size: 30.0,
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE74C3C),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    label: const Text(
                      'Add Item',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Container(
                height: 450,
                width: 400,
                decoration: const BoxDecoration(
                    color: Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Column(
                  children: [
                    Container(
                      height: 75,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: [
                            const Text(
                              'Order Summary',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 22),
                            ),
                            const Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: const Color(0xFFFE6709),
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  color: Colors.white),
                              child: IconButton(
                                onPressed: unused_coupon
                                    ? () {
                                        openDialog();
                                      }
                                    : null,
                                icon: const Icon(
                                  Icons.percent_outlined,
                                  size: 30,
                                  color: Color(0xFFE74C3C),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(currentOrderNames[index]),
                          trailing: Text(
                              namePrice[currentOrderNames[index]].toString()),
                          leading: IconButton(
                            icon: const Icon(
                              Icons.check_box,
                              color: Color(0xFFFE6709),
                              size: 25,
                            ),
                            onPressed: () {
                              setState(() {
                                total =
                                    total - namePrice[currentOrderNames[index]];
                                currentOrderNames.removeAt(index);
                                if (total < 0) {
                                  total = 0;
                                }
                              });
                            },
                            isSelected: true,
                          ),
                        );
                      },
                      itemCount: currentOrderNames.length,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Spacer(),
                    Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  width: 1.5, color: Color(0xFF000000)))),
                      height: 50,
                      width: 400,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: [
                            const Text(
                              'Order Total',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 18),
                            ),
                            const Spacer(),
                            Container(
                              child: Text(total.toString(),
                                  style: const TextStyle(fontSize: 18)),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
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
              onPressed: () {
                List temp = [];
                List temp1 = [];
                for (var t in currentOrderNames) {
                  temp.add(nameID[t]);
                  temp1.add(t);
                }
                finalOrder['products'] = temp;
                finalOrder['amount'] = total;
                finalnameOrder['products'] = temp1;
                finalnameOrder['amount'] = total;
                finalOrder['coupon'] = coupon_id;
                finalOrder['coupon_name'] = Coupon;
                finalOrder['loyalty_points'] = 0;
                setState(() {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PhoneCheckView(
                      orderDetails: finalOrder,
                      ordernameDetails: finalnameOrder,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
