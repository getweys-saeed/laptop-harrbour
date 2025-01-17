import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DetailPage extends StatefulWidget {
  final int productId;

  const DetailPage({super.key, required this.productId});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isLoading = true;
  Map<String, dynamic> product = {};
  List<Map<String, dynamic>> reviews = [];
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final TextEditingController reviewController = TextEditingController();
  double rating = 0.0;

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
    fetchReviewsDetails();
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'auth_token');
  }

  Future<void> fetchProductDetails() async {
    final token = await getToken();

    if (token == null) {
      showError("Token not found. Please log in.");
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/products?id=${widget.productId}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          product = jsonDecode(response.body)['product'];
          isLoading = false;
        });
      } else {
        showError(
            "Failed to load product. Status code: ${response.statusCode}");
      }
    } catch (e) {
      showError("Error: $e");
    }
  }

  Future<void> fetchReviewsDetails() async {
    final token = await getToken();

    if (token == null) {
      showError("Token not found. Please log in.");
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(
            'http://127.0.0.1:8000/api/getreviews?slug=${widget.productId}'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        setState(() {
          reviews = List<Map<String, dynamic>>.from(
              jsonDecode(response.body)['data']);
        });
      } else {
        showError(
            "Failed to load reviews. Status code: ${response.statusCode}");
      }
    } catch (e) {
      showError("Error: $e");
    }
  }

  Future<void> addToCart() async {
    final token = await getToken();
    if (token == null) {
      showError("Token not found. Please log in.");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/cart'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'slug': widget.productId,
          'quantity': 1,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData.containsKey('success')) {
          showError(responseData['success']);
        }
      } else {
        final responseData = jsonDecode(response.body);
        showError(responseData['error']);
      }
    } catch (e) {
      showError("Error: $e");
    }
  }

  Future<void> submitReview() async {
    final token = await getToken();
    if (token == null) {
      showError("Token not found. Please log in.");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/reviews'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'slug': widget.productId,
          'rate': rating,
          'review': reviewController.text,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData.containsKey('success')) {
          showError(responseData['success']);
        }

        setState(() {
          reviewController.clear();
          rating = 0.0;
        });
        fetchReviewsDetails(); // Refresh reviews after submitting a new one
      } else {
        final responseData = jsonDecode(response.body);
        if (responseData.containsKey('error')) {
          showError(responseData['error']);
        }
      }
    } catch (e) {
      showError("Error: $e");
    }
  }

  void showError(String message) {
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.red)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 243, 243, 243),
        title: const Text("Product Details"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image Section
                  Container(
                    width: double.infinity,
                    height: 250,
                    color: const Color.fromARGB(255, 243, 243, 243),
                    child: Center(
                      child: Image.network(
                        "http://127.0.0.1:8000/${product['photo'] ?? ''}",
                        height: 150,
                        width:150,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Title
                        Text(
                          product['title'] ?? "Product Title",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Product Price
                        Row(
                          children: [
                            Text(
                              "\$${product['price'] ?? '0.00'}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (product['discounted_price'] != null)
                              Text(
                                "\$${product['discount']}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product['stock'] != null && product['stock'] > 0
                                  ? "In Stock: ${product['stock']}"
                                  : "Out of Stock",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: product['stock'] != null &&
                                        product['stock'] > 0
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            Text(
                              "Condition: ${product['condition'] ?? 'New'}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.grey),
                            )
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Product Description
                        Text(
                          "Product Description",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          product['description'] ??
                              "Product description goes here.",
                          style:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        // Product Summary
                        Text(
                          "Product Summary",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Text(
                           "${product['summary'] ?? 'No summary available.'}",
                          style:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        // Stock Section

                        const SizedBox(height: 24),
                        const Text(
                          "Reviews",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        reviews.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: reviews.length,
                                itemBuilder: (context, index) {
                                  final review = reviews[index];
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          review['user_name'] ?? "Anonymous",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          children:
                                              List.generate(5, (starIndex) {
                                            return Icon(
                                              starIndex < review['rate']
                                                  ? Icons.star
                                                  : Icons.star_border,
                                              color: Colors.amber,
                                              size: 18,
                                            );
                                          }),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          review['review'] ??
                                              "No review content.",
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )
                            : const Text(
                                "No reviews yet. Be the first to review this product.",
                                style: TextStyle(color: Colors.grey),
                              ),
                        const SizedBox(height: 24),
                        TextField(
                          controller: reviewController,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            hintText: "Write your review...",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text("Rating:"),
                            ...List.generate(5, (index) {
                              return IconButton(
                                icon: Icon(
                                  Icons.star,
                                  color: rating > index
                                      ? Colors.amber
                                      : Colors.grey,
                                ),
                                onPressed: () =>
                                    setState(() => rating = index + 1.0),
                              );
                            }),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: submitReview,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                          child: const Text("Submit Review"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: ElevatedButton(
          onPressed: addToCart,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            "Add to Cart",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
