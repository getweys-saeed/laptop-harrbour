import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:laptop_harbour/screens/checkout/checkout.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  List<dynamic> cartItems = [];
  bool isLoading = true;
  double totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'auth_token');
  }

  Future<void> fetchCartItems() async {
    final token = await getToken();

    if (token == null) {
      showError("Token not found. Please log in.");
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/allcart'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          cartItems = data['cart'];
          totalAmount = cartItems.fold(
            0.0,
            (sum, item) => sum + item['amount'],
          );
          isLoading = false;
        });
      } else {
        showError(
            "Failed to load cart items. Status code: ${response.statusCode}");
      }
    } catch (e) {
      showError("Error: $e");
    }
  }

  Future<void> deleteCartItem(int cartId) async {
    final token = await getToken();

    if (token == null) {
      showError("Token not found. Please log in.");
      return;
    }

    try {
      final response = await http.delete(
        Uri.parse('http://127.0.0.1:8000/api/cart/delete'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'id': cartId}),
      );

      if (response.statusCode == 200) {
        setState(() {
          cartItems.removeWhere((item) => item['id'] == cartId);
          totalAmount = cartItems.fold(
            0.0,
            (sum, item) => sum + item['amount'],
          );
        });
        showSuccess("Cart item deleted successfully.");
      } else {
        showError(
            "Failed to delete cart item. Status code: ${response.statusCode}");
      }
    } catch (e) {
      showError("Error: $e");
    }
  }

  Future<void> updateCart(int index, int quantity) async {
    final token = await getToken();

    if (token == null) {
      showError("Token not found. Please log in.");
      return;
    }

    final itemId = cartItems[index]['id'];

    try {
      final response = await http.put(
        Uri.parse('http://127.0.0.1:8000/api/cart/update'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'quant': [quantity],
          'qty_id': [itemId],
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          cartItems[index]['quantity'] = quantity;
          cartItems[index]['amount'] =
              cartItems[index]['product']['price'] * quantity;
          totalAmount = cartItems.fold(
            0.0,
            (sum, item) => sum + item['amount'],
          );
        });
        showSuccess("Cart updated successfully.");
      } else {
        showError("Failed to update cart. Status code: ${response.statusCode}");
      }
    } catch (e) {
      showError("Error: $e");
    }
  }

  void showError(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void showSuccess(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "My Cart",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final item = cartItems[index];
                            return Container(
                              height: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 5,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              margin:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Stack(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 120,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Image.network(
                                            "http://127.0.0.1:8000/${item['product']['photo']}",
                                            height: 90,
                                            width: 49,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              item['product']['title'] ??
                                                  "Product Title",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              "\$${item['amount']}",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.orange,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Container(
                                          height: 30,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  if (item['quantity'] > 1) {
                                                    updateCart(index,
                                                        item['quantity'] - 1);
                                                  }
                                                },
                                                child: const Icon(
                                                  Icons.remove,
                                                  size: 20,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Text(
                                                  "${item['quantity']}",
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  updateCart(index,
                                                      item['quantity'] + 1);
                                                },
                                                child: const Icon(
                                                  Icons.add,
                                                  size: 20,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    top: 1,
                                    right: 1,
                                    child: IconButton(
                                      icon: const Icon(Icons.cancel,
                                          size: 17, color: Colors.red),
                                      onPressed: () {
                                        final int cartId = item[
                                            'id']; // Get the cart item's ID
                                        deleteCartItem(
                                            cartId); // Call the delete function with the ID
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              "\$$totalAmount",
                              style: const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CheckoutPage(
                                      cartItems: cartItems,
                                      totalAmount: totalAmount,
                                    ),
                                  ));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Buy Now",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
