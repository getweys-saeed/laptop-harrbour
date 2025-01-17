import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FavouratePage extends StatefulWidget {
  const FavouratePage({super.key});

  @override
  _FavouratePageState createState() => _FavouratePageState();
}

class _FavouratePageState extends State<FavouratePage> {
  List<dynamic> wishlist = [];
  final storage = FlutterSecureStorage(); 
  String? token;
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    fetchWishlist();
  }

  Future<void> fetchWishlist() async {
    token = await storage.read(key: 'auth_token');
    if (token == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Authentication Error'),
            content: const Text('User not authenticated! Please log in.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/allwishlist'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          wishlist = json.decode(response.body)['wishlist'];
          isLoading = false;
        });
      } else {
        showErrorDialog('Failed to load wishlist');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showErrorDialog('Error fetching wishlist: $e');
    }
  }

  Future<void> deleteWishlistItem(int id) async {
    token ??= await storage.read(key: 'auth_token');

    try {
      final response = await http.delete(
        Uri.parse('http://127.0.0.1:8000/api/wishlist/delete'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'id': id}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          setState(() {
            wishlist.removeWhere((item) => item['id'] == id);
          });
          showSuccessDialog(data['message']);
        } else {
          showErrorDialog('Failed to delete item');
        }
      } else {
        showErrorDialog('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      showErrorDialog('An error occurred: $e');
    }
  }

  Future<void> addToCart() async {
    token ??= await storage.read(key: 'auth_token');
    if (token == null) {
      showErrorDialog('User not authenticated!');
      return;
    }

    try {
      List<String> failedItems = [];

      for (var item in wishlist) {
        final response = await http.post(
          Uri.parse('http://127.0.0.1:8000/api/cart'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'slug': item['product']['id'],
            'quantity': 1,
          }),
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          if (responseData.containsKey('success')) {
            showSuccessDialog(responseData['success']);
          }
        } else {
          failedItems.add(item['product']['title']);
        }
      }

      if (failedItems.isEmpty) {
        showSuccessDialog('All items added to cart successfully!');
      } else {
        showErrorDialog('Failed to add: ${failedItems.join(', ')}');
      }
    } catch (e) {
      showErrorDialog('An error occurred: $e');
    }
  }

  // Success Dialog
  void showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Error Dialog
  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
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
            "My WishList",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 60, 60, 60),
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                    child: wishlist.isEmpty
                        ? const Center(
                            child: Text(
                              "No wishlist available",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: wishlist.length,
                            itemBuilder: (context, index) {
                              var product = wishlist[index]['product'];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 16.0,
                                ),
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Center(
                                        child: Image.network(
                                          'http://127.0.0.1:8000/${product['photo']}',
                                          height: 90,
                                          width: 90,
                                          fit: BoxFit.cover,
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
                                            product['title'],
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "₹${wishlist[index]['amount']}",
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        await deleteWishlistItem(
                                            wishlist[index]['id']);
                                      },
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: ElevatedButton(
                onPressed: () async {
                  await addToCart();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Add To Cart",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
