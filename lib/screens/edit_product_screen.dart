import 'package:flutter/material.dart';
import 'package:my_shop/providers/product.dart';
import 'package:my_shop/providers/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static final routeName = 'edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    // 'imageUrl': '',
  };
  var _isInit = true;
  @override
  void dispose() {
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    if (_editedProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: () => _saveForm())
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                initialValue: _initValues['title'],
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide a value.';
                  } else {
                    return null; //input is correct

                  }
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    id: null,
                    title: value,
                    imageUrl: _editedProduct.imageUrl,
                    price: _editedProduct.price,
                    description: _editedProduct.description,
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                initialValue: _initValues['price'],
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a price.';
                  } else if (double.tryParse(value) == null) {
                    return 'Please enter a valid number.';
                  } else if (double.parse(value) <= 0) {
                    return 'Please enter a number gratter then 0';
                  } else {
                    return null; //input is correct

                  }
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    id: null,
                    title: _editedProduct.title,
                    imageUrl: _editedProduct.imageUrl,
                    price: double.parse(value),
                    description: _editedProduct.description,
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Descripton'),
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                initialValue: _initValues['description'],
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Enter a description.';
                  } else if (value.length < 7) {
                    return 'Please enter a longer description.';
                  } else {
                    return null; //input is correct
                  }
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    id: null,
                    title: _editedProduct.title,
                    imageUrl: _editedProduct.imageUrl,
                    price: _editedProduct.price,
                    description: value,
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10, right: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    width: 100,
                    height: 100,
                    child: _imageUrlController.text.isNotEmpty
                        ? FittedBox(
                            child: Container(
                            child: Image.network(_imageUrlController.text),
                          ))
                        : Text('Image Not Loaded'),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.url,
                      controller: _imageUrlController,
                      initialValue: _initValues['imageUrl'],
                      onEditingComplete: () {
                        setState(() {});
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Enter a URL.';
                        }
                        if (!value.startsWith('http') ||
                            !value.startsWith('https')) {
                          return 'Please enter a valid URL.';
                        } else {
                          return null; //input is correct
                        }
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: null,
                          title: _editedProduct.title,
                          imageUrl: value,
                          price: _editedProduct.price,
                          description: _editedProduct.description,
                        );
                      },
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
