import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class SingleOrderDetail extends StatefulWidget {
  final orderDetails;
  const SingleOrderDetail({super.key, @required this.orderDetails});

  @override
  State<SingleOrderDetail> createState() => _SingleOrderDetailState();
}

class _SingleOrderDetailState extends State<SingleOrderDetail> {
  @override
  Widget build(BuildContext context) {
    var cat_icon;
    if (widget.orderDetails['category'] == 'Phone') {
      cat_icon = const Icon(
        Icons.phone_iphone,
        size: 100,
        color: Color(0xFFC33500),
      );
    } else if (widget.orderDetails['category'] == 'Laptop') {
      cat_icon = const Icon(
        Icons.laptop_mac,
        size: 100,
        color: Color(0xFFC33500),
      );
    } else if (widget.orderDetails['category'] == 'Tv') {
      cat_icon = const Icon(
        Icons.tv,
        size: 100,
        color: Color(0xFFC33500),
      );
    } else {
      cat_icon = const Icon(
        Icons.headphones,
        size: 100,
        color: Color(0xFFC33500),
      );
    }
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Container(
          height: 1000,
          width: 800,
          decoration: const BoxDecoration(
              color: Color(0xFFE0987E),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: cat_icon,
                  ),
                  Column(
                    children: [
                      Text(
                        '${widget.orderDetails['product_name']}',
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF000000)),
                      ),
                    ],
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Warranty Left : ${widget.orderDetails['warranty']} days',
                    style:
                        const TextStyle(color: Color(0xFF000000), fontSize: 22),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Price : ${widget.orderDetails['price']}',
                    style:
                        const TextStyle(color: Color(0xFF000000), fontSize: 22),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
