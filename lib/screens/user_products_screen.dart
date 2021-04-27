import 'package:flutter/material.dart';
import 'package:my_shop/providers/products.dart';
import 'package:my_shop/widgets/app_drawer.dart';
import 'package:my_shop/widgets/user_product_item.dart';
import 'package:provider/provider.dart';

import 'edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static final routeName = 'userProducts';
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              })
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
            itemCount: productsData.items.length,
            separatorBuilder: (_, i) => Divider(),
            itemBuilder: (_, i) => UserProductItem(
                  id: productsData.items[i].id,
                  title: productsData.items[i].title,
                  imageUrl: productsData.items[i].imageUrl,
                )),
      ),
    );
  }
}
