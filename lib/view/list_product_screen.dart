import 'package:final_test/model/product.dart';
import 'package:final_test/view/add_product_screen.dart';
import 'package:final_test/view/product_detail_screen.dart';
import 'package:final_test/view_model/product_view_model.dart';
import 'package:flutter/material.dart';

class ListProductScreen extends StatefulWidget {
  const ListProductScreen({super.key});

  @override
  State<ListProductScreen> createState() => _ListProductScreenState();
}

class _ListProductScreenState extends State<ListProductScreen> {
  late Future<List<Product>> lstProducts;

  @override
  void initState() {
    super.initState();
    lstProducts = ProductViewModel().getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'List of Products',
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 20),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddProductScreen()));
            },
            icon: Icon(Icons.add_circle_outline_rounded),
            color: Colors.white,
            iconSize: 30,
          ),
        ],
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(224, 145, 145, 0.8),
      ),
      body: FutureBuilder(
        future: lstProducts,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final products = snapshot.data;
            return Container(
              margin: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20),
                itemCount: products!.length,
                itemBuilder: (context, index) {
                  return ItemCardView(
                    product: products[index],
                  );
                },
              ),
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

class ItemCardView extends StatefulWidget {
  const ItemCardView({
    super.key,
    required this.product,
  });
  final Product product;
  @override
  State<ItemCardView> createState() => _ItemCardViewState();
}

class _ItemCardViewState extends State<ItemCardView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailScreen(
                      productId: widget.product.id!,
                    )));
      },
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Delete Product'),
              content:
                  const Text('Are you sure you want to delete this product?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    ProductViewModel().deleteProduct(widget.product.id!);
                    Navigator.pop(context);
                  },
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        width: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Color(0xffD5D5D5).withOpacity(0.3),
              blurRadius: 4,
              spreadRadius: 4,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                child: Image.network(
                  widget.product.images![0].toString(),
                  height: 120,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.product.title!,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "\$" + widget.product.price.toString(),
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.green),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
