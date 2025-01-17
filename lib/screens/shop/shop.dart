import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:laptop_harbour/screens/detail_page/detail_page.dart';
import 'package:laptop_harbour/widgets/main_screen.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  String searchText = "";
  List<dynamic> products = [];
  List<dynamic> categories = [];
  List<dynamic> brands = [];
  bool isLoading = true;
  String? selectedCategory;
  String? selectedBrand;
  String? selectedSortBy;
  String? selectedPriceRange;

  @override
  void initState() {
    super.initState();
    fetchProperties(); // Fetch properties (categories and brands) initially
    fetchProducts(); // Fetch initial products
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'auth_token');
  }

  // Fetch categories and brands
  Future<void> fetchProperties() async {
    final token = await getToken();
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/products/SearchAndFilter'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print('Properties Response: $data'); // Debugging
        if (data != null && data['allProperties'] != null) {
          setState(() {
            categories = data['allProperties']['categories'] ?? [];
            brands = data['allProperties']['brands'] ?? [];
          });
        }
      } else {
        showError("Failed to fetch properties: ${response.statusCode}");
      }
    } catch (e) {
      showError("Error fetching properties: $e");
    }
  }

  // Fetch products with optional filters (category, brand, search, sorting)
  Future<void> fetchProducts() async {
    try {
      setState(() {
        isLoading = true;
      });

      final token = await getToken();
      Uri url = Uri.parse('http://127.0.0.1:8000/api/products/SearchAndFilter');

      Map<String, String> queryParams = {};

      // Ensure we don't add null or empty values to queryParams
      if (selectedCategory != null && selectedCategory!.isNotEmpty) {
        queryParams['category'] = selectedCategory!;
      }
      if (selectedBrand != null && selectedBrand!.isNotEmpty) {
        queryParams['brand'] = selectedBrand!;
      }
      if (searchText.isNotEmpty) {
        queryParams['search'] = searchText;
      }
      if (selectedSortBy != null && selectedSortBy!.isNotEmpty) {
        queryParams['sortBy'] = selectedSortBy!;
      }
      if (selectedPriceRange != null && selectedPriceRange!.isNotEmpty) {
        queryParams['price_range'] = selectedPriceRange!;
      }

      final response = await http.get(
        url.replace(queryParameters: queryParams),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        try {
          var data = jsonDecode(response.body);
          if (data != null && data['products'] != null) {
            setState(() {
              products = data['products']; // Correct key as 'products'
            });
          } else {
            setState(() {
              products = [];
            });
          }
        } catch (e) {
          print("ERRORRRR: ${e.toString()}");
          showError("Error decoding response data.");
        }
      } else {
        showError("Failed to fetch products");
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("ERROR");
      print(e.toString());
    }
  }

  // Add to wishlist
  Future<void> addToWishlist(String slug) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/wishlist'),
      body: jsonEncode({'slug': slug}),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 201) {
      showSuccess("Product added to wishlist");
    } else {
      final responseBody = jsonDecode(response.body);
      showError(responseBody['message'] ?? "Failed to add to wishlist");
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: TextStyle(color: Colors.red))),
    );
  }

  void showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: TextStyle(color: Colors.green))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Laptop Shop"),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search Bar with Button
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  searchText = value.toLowerCase();
                                });
                              },
                              decoration: InputDecoration(
                                hintText: "Search products...",
                                hintStyle: TextStyle(
                                    color: Colors
                                        .grey[500]), // Lighter hint text color
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    fetchProducts(); // Trigger search on button click
                                  },
                                  icon: Icon(Icons.search),
                                  color: Colors.grey,
                                  splashColor: Colors
                                      .orange[200], // Subtle splash effect
                                  padding: EdgeInsets.all(
                                      10), // Added padding for better tap area
                                  iconSize:
                                      28.0, // Larger icon size for better visibility
                                ),

                                filled: true,
                                fillColor: Colors.grey[
                                    200], // Light background for the TextField
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      25.0), // Softer, larger border radius
                                  borderSide:
                                      BorderSide.none, // Remove border line
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal:
                                        15.0), // Padding for better alignment
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      // Categories
                      Text(
                        "Categories",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 10),
                      categories.isEmpty
                          ? Center(child: Text("No categories available"))
                          : SizedBox(
                              height: 30,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: categories.length,
                                itemBuilder: (context, index) {
                                  final category = categories[index];
                                  final isActive = selectedCategory ==
                                      category['id'].toString();

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: SizedBox(
                                      width: 80,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            selectedCategory = isActive
                                                ? null
                                                : category['id'].toString();
                                          });
                                          fetchProducts(); // Fetch products based on selected category
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: isActive
                                              ? Colors.orange
                                              : Colors.grey[
                                                  300], // Active = orange, Inactive = light grey
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                4.0), // Decreased border radius
                                          ),
                                        ),
                                        child: Text(
                                          category['title'], // Category name
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: isActive
                                                ? Colors.white
                                                : Colors
                                                    .black, // White text for active
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                      SizedBox(height: 20),
                      // Brands as Buttons
                      Text(
                        "Brands",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      brands.isEmpty
                          ? Center(child: Text("No brands available"))
                          : SizedBox(
                              height: 30,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: brands.length,
                                itemBuilder: (context, index) {
                                  final brand = brands[index];
                                  final isActive =
                                      selectedBrand == brand['id'].toString();

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: SizedBox(
                                      width: 80,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: isActive
                                              ? Colors.orange
                                              : Colors.grey[
                                                  300], // Active = orange, Inactive = light grey
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                4.0), // Decreased border radius
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            selectedBrand = isActive
                                                ? null
                                                : brand['id'].toString();
                                          });
                                          fetchProducts(); // Fetch products based on selected brand
                                        },
                                        child: Text(
                                          brand['title'], // Brand name
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: isActive
                                                  ? Colors.white
                                                  : Colors
                                                      .black), // White text for active
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                      SizedBox(height: 20),
                      // Sorting
                      Text(
                        "Sort By",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      DropdownButton<String>(
                        value: selectedSortBy,
                        hint: Text("Select Sort Option"),
                        items: [
                          DropdownMenuItem(
                              value: "price_asc",
                              child: Text("Price (Low to High)")),
                          DropdownMenuItem(
                              value: "price_desc",
                              child: Text("Price (High to Low)")),
                          DropdownMenuItem(
                              value: "newest", child: Text("Newest")),
                          DropdownMenuItem(
                              value: "oldest", child: Text("Oldest")),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedSortBy = value;
                          });
                          fetchProducts();
                        },
                      ),
                      SizedBox(height: 20),
                      // Product Grid
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return GestureDetector(
                            onTap: () {
                              // Navigate directly to the DetailPage with the correct product_id
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailPage(
                                      productId: product[
                                          'id']), // Pass the product ID here
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Color.fromARGB(255, 240, 240, 240),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade300,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
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
                                          color: Colors.red,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 4.0),
                                          child: Text(
                                            "SALE",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      IconButton(
                                        icon: Icon(Icons.favorite_border,
                                            color: Colors.orange),
                                        onPressed: () {
                                          addToWishlist(product['slug']);
                                        },
                                      ),
                                    ],
                                  ),
                                  // Product Image
                                  Center(
                                    child: Image.network(
                                      "http://127.0.0.1:8000/" +
                                          product['photo'], // Image path
                                      fit: BoxFit.contain,
                                      height: 70,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    product['title'], // Product name
                                    style: TextStyle(
                                      fontWeight: FontWeight.w100,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Rs ${product['price']}", // Regular price
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      if (product['discount'] > 0)
                                        Text(
                                          "Rs ${product['price'] - product['discount']}", // Discounted price
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                     ],
                  ),
                ),
              ),
            ),
    );
  }
}
