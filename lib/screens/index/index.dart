import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:laptop_harbour/config/colors.dart';
import 'package:laptop_harbour/screens/cart/cart.dart';
import 'package:laptop_harbour/screens/detail_page/detail_page.dart';
import 'package:laptop_harbour/screens/shop/shop.dart';
import 'package:laptop_harbour/widgets/main_screen.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  late Future<Map<String, dynamic>> futureProducts;
  final FlutterSecureStorage storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    futureProducts = fetchProducts();
  }

  Future<Map<String, dynamic>> fetchProducts() async {
    String? token = await storage.read(key: 'auth_token');
    if (token == null) {
      throw Exception('Token is missing');
    }

    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/products/SearchAndFilter'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting Text
                Row(
                  children: [
                    const Text(
                      "Hello ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      Icons.waving_hand_outlined,
                      color: primaryColor,
                      size: 20,
                    ),
                  ],
                ),
                const Text(
                  "Let's Start Shopping!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 12), // Space between text and cards

                // Discount Cards
                Text(
                  "Featured Products For You",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: SizedBox(
                    height: 200,
                    child: FutureBuilder<Map<String, dynamic>>(
                      future: futureProducts, // Assuming this is your API call
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          // Extract the 'products' key from the response and filter for featured products
                          var featuredProducts = snapshot.data?['products']
                                  ?.where(
                                      (product) => product['is_featured'] == 1)
                                  .toList() ??
                              []; // If null, default to an empty list

                          // If there are no featured products, display a message
                          if (featuredProducts.isEmpty) {
                            return const Center(
                                child: Text('No featured products available.'));
                          }

                          // Display the featured products in a horizontal ListView
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: featuredProducts.length,
                            itemBuilder: (context, index) {
                              var featuredProduct = featuredProducts[index];

                              return Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: Card(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  elevation: 8,
                                  shadowColor: Colors.black45,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: SizedBox(
                                      width: 300, // Fixed width for the card
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: 100,
                                              height: 100,
                                              child: Image.network(
                                                'http://127.0.0.1:8000/${featuredProduct['photo']}',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  featuredProduct['title'],
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailPage(
                                                          productId:
                                                              featuredProduct[
                                                                  'id'],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.orangeAccent,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    "Buy Now",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return const Center(
                              child: Text('No featured products available.'));
                        }
                      },
                    ),
                  ),
                ),
                // Categories Section
                SizedBox(height: 15),
                Text("Product You Like",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                // Product Grid Section
                const SizedBox(height: 15),
                FutureBuilder<Map<String, dynamic>>(
                  future: futureProducts,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      var products = snapshot.data!['products'];

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          var product = products[index];
                          return GestureDetector(
                             onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailPage(
                                                          productId:
                                                              product[
                                                                  'id'],
                                                        ),
                                                      ),
                                                    );
                                                  },
                            child: Container(
                              
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: const Color.fromARGB(255, 250, 250, 250),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromARGB(255, 202, 202, 202),
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (product['discount'] > 0)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Text(
                                            "Sale ",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 162, 162, 162),
                                            width: 1,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.favorite,
                                          size: 16,
                                          color:
                                              Color.fromARGB(255, 162, 162, 162),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 90,
                                    alignment: Alignment.center,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        'http://127.0.0.1:8000/${product['photo']}',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Text("${product['title']}"),
                                  Spacer(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Rs ${product['price']}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                      if (product['discount'] > 0)
                                        Text(
                                          "Rs ${product['price'] - product['discount']}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              fontSize: 12),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(child: Text('No products available'));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ShoppingPage()),
          );
        },
        child: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Bottom Navigation Bar
      bottomNavigationBar: const MainScreen(),
    );
  }
}
