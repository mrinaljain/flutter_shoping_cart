import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_shop/models/order_item.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  const OrderItem({this.order});

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$ ${widget.order.amount}'),
            subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
            ),
          ),
          if (_expanded)
            Container(
              height: min(widget.order.products.length * 20.0 + 100.0, 180.0),
              child: ListView.builder(
                  itemCount: widget.order.products.length,
                  itemBuilder: (ctx, i) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.order.products[i].title),
                          Text(
                              '${widget.order.products[i].quantity} x ${widget.order.products[i].price}')
                        ],
                      )),
            )
        ],
      ),
    );
  }
}
