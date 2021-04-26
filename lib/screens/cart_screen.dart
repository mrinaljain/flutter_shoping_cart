import 'package:flutter/material.dart';
import 'package:my_shop/providers/cart.dart' show Cart;
import 'package:my_shop/providers/orders.dart';
import 'package:my_shop/screens/orders_screen.dart';
import 'package:my_shop/widgets/cart_item.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static final routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Your Cart")),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total:',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text('\$ ${cart.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.headline6.color,
                        )),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  TextButton(
                      onPressed: () {
                        Provider.of<Orders>(context, listen: false).addOrder(
                            cartProducts: cart.items.values.toList(),
                            total: cart.totalAmount);
                        cart.clearCart();
                      },
                      child: Text('Order Now')),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: cart.itemCount,
                itemBuilder: (ctx, i) => CartItem(
                      id: cart.items.values.toList()[i].id,
                      productId:
                          cart.items.keys.toList()[i], // ye samaj nhi aaya
                      price: cart.items.values.toList()[i].price,
                      quantity: cart.items.values.toList()[i].quantity,
                      title: cart.items.values.toList()[i].title,
                    )),
          ),
        ],
      ),
    );
  }
}
