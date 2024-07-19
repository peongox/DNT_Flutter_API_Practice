import 'dart:convert';
import 'package:final_test/api_services/api_urls.dart';
import 'package:final_test/model/product.dart';
import 'package:http/http.dart' as http;

class ProductViewModel {
  Future<List<Product>> getProducts() async {
    List<Product> lstPro = [];
    var response = await http.get(Uri.parse(getApi));
    var data = jsonDecode(response.body);
    lstPro = data.map<Product>((json) => Product.fromJson(json)).toList();
    return lstPro;
  }

  Future<Product> getProductById(int id) async {
    Product product = Product();
    var response = await http.get(Uri.parse(getApi + '/$id'));
    var data = jsonDecode(response.body);
    product = Product.fromJson(data);
    return product;
  }

  Future<void> addProduct(
      String title, int price, String description, List<String> images) async {
    final response = await http.post(
      Uri.parse(postApi),
      body: jsonEncode({
        'title': title,
        'categoryId': 1,
        'price': price,
        'description': description,
        'images': images,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    print(response.body);
  }

  Future<void> editProduct(String name, int id) async {
    final response = await http.put(Uri.parse(getApi + '/$id'),
        body: jsonEncode({
          'title': name,
        }),
        headers: {'Content-Type': 'application/json'});
  }

  Future<void> deleteProduct(int id) async {
    final response = await http.delete(Uri.parse(getApi + '/$id'));
  }
}
