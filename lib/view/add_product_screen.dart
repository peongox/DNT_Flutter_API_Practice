import 'dart:ui';

import 'package:final_test/model/category.dart';
import 'package:final_test/model/product.dart';
import 'package:final_test/view_model/product_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  static Color _selectedColor = Color.fromRGBO(224, 145, 145, 1);
  static Color _unselectedColor = Colors.grey;
  Color _nameTFColor = _unselectedColor;
  Color _cateTFColor = _unselectedColor;
  Color _priceTFColor = _unselectedColor;
  Color _descTFColor = _unselectedColor;
  Color _imgTFColor = _unselectedColor;

  FocusNode _nameFocusNode = FocusNode();
  FocusNode _cateFocusNode = FocusNode();
  FocusNode _priceFocusNode = FocusNode();
  FocusNode _descFocusNode = FocusNode();
  FocusNode _imgFocusNode = FocusNode();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _cateController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _imgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.fromLTRB(16, 64, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'New Product',
                style: TextStyle(
                    color: Color.fromRGBO(224, 145, 145, 1),
                    fontSize: 40,
                    fontWeight: FontWeight.w800),
              ),
              const Spacer(),
              TextField(
                controller: _nameController,
                focusNode: _nameFocusNode,
                decoration: InputDecoration(
                  labelText: 'Product Name:',
                  labelStyle: TextStyle(color: _nameTFColor),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _cateController,
                focusNode: _cateFocusNode,
                decoration: InputDecoration(
                  labelText: 'Category:',
                  labelStyle: TextStyle(
                    color: _cateTFColor,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _priceController,
                focusNode: _priceFocusNode,
                decoration: InputDecoration(
                  labelText: 'Price:',
                  labelStyle: TextStyle(
                    color: _priceTFColor,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descController,
                focusNode: _descFocusNode,
                maxLines: 5,
                minLines: 1,
                decoration: InputDecoration(
                  labelText: 'Description:',
                  labelStyle: TextStyle(
                    color: _descTFColor,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _imgController,
                focusNode: _imgFocusNode,
                maxLines: 3,
                minLines: 1,
                decoration: InputDecoration(
                    labelText: 'Image URL (maximum 3 images):',
                    labelStyle: TextStyle(
                      color: _imgTFColor,
                    )),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Cancel',
                        style:
                            TextStyle(color: Color.fromRGBO(224, 145, 145, 1)),
                      ),
                      style: ButtonStyle(
                        side: WidgetStateProperty.all(
                          BorderSide(
                            color: Color.fromRGBO(224, 145, 145, 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        setState(() {
                          print("working");
                          ProductViewModel().addProduct(
                            _nameController.text,
                            int.parse(_priceController.text),
                            _descController.text,
                            _imgController.text.split('\n'),
                          );
                          Navigator.pop(context);
                        });
                      },
                      child: const Text('Add'),
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                              Color.fromRGBO(224, 145, 145, 1))),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
