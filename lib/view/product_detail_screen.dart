import 'package:carousel_slider/carousel_slider.dart';
import 'package:final_test/model/product.dart';
import 'package:final_test/view_model/product_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductDetailScreen extends StatefulWidget {
  ProductDetailScreen({super.key, required this.productId});
  int productId;
  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<Product> product;
  late List<String>? imgList = [];
  @override
  initState() {
    super.initState();
    product = ProductViewModel().getProductById(widget.productId);
  }

  int _current = 0;
  final CarouselController _controller = CarouselController();
  bool _isEdit = true;

  static Color _selectedColor = Colors.black;
  static Color _unselectedColor = Colors.grey;
  Color _nameTFColor = _unselectedColor;
  Color _cateTFColor = _unselectedColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "Product's Detail",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color.fromRGBO(224, 145, 145, 0.8),
        actions: [
          Visibility(
            visible: _isEdit,
            child: IconButton(
              padding: const EdgeInsets.only(right: 20),
              onPressed: () {
                setState(() {
                  _isEdit = !_isEdit;
                });
              },
              icon: const Icon(Icons.edit),
              color: Colors.white,
              iconSize: 25,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: product,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final product = snapshot.data;
            TextEditingController _nameController =
                TextEditingController(text: product!.title);
            // TextEditingController _cateController = TextEditingController();
            // TextEditingController _priceController = TextEditingController();
            // TextEditingController _descController = TextEditingController();
            // TextEditingController _imgController = TextEditingController();
            imgList = product!.images;
            return Column(
              children: [
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: CarouselSlider(
                    carouselController: _controller,
                    options: CarouselOptions(
                      autoPlay: imgList!.length == 1 ? false : true,
                      enlargeCenterPage: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      },
                    ),
                    items: imgList
                        ?.map((item) => Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                              ),
                              child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(16)),
                                  child:
                                      Image.network(item, fit: BoxFit.cover)),
                            ))
                        .toList(),
                  ),
                ),
                //HIỂN THỊ INDEX CỦA BANNER
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: imgList!.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _controller.animateToPage(entry.key),
                      child: Container(
                        width: 25,
                        height: 4,
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 6),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: (_current == entry.key
                                ? const Color.fromRGBO(224, 145, 145, 1)
                                : const Color(0XFFD9D9D9))),
                      ),
                    );
                  }).toList(),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _nameController,
                        // focusNode: _nameFocusNode,
                        readOnly: _isEdit,
                        decoration: InputDecoration(
                          labelText: 'Product Name:',
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: TextEditingController(
                            text: product.title.toString()),
                        // focusNode: _nameFocusNode,
                        readOnly: _isEdit,
                        decoration: InputDecoration(
                          labelText: 'Category:',
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: TextEditingController(
                            text: product.price.toString()),
                        // focusNode: _nameFocusNode,
                        readOnly: _isEdit,
                        decoration: InputDecoration(
                          labelText: 'Price:',
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Product Description',
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.description.toString(),
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 16),
                      Visibility(
                        visible: !_isEdit,
                        child: SizedBox(
                          width: double.infinity,
                          child: Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      _isEdit = !_isEdit;
                                    });
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                        color:
                                            Color.fromRGBO(224, 145, 145, 1)),
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
                                      _isEdit = !_isEdit;
                                      ProductViewModel().editProduct(
                                          _nameController.text, product.id!);
                                    });
                                  },
                                  child: const Text('Save'),
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(
                                        Color.fromRGBO(224, 145, 145, 1)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(
              color: Color.fromRGBO(224, 145, 145, 1),
              backgroundColor: Colors.black12,
            ),
          );
        },
      ),
    );
  }
}
