import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CheckoutPage extends StatefulWidget {
  final List<dynamic> cartItems;
  final double totalAmount;

  CheckoutPage({required this.cartItems, required this.totalAmount});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();

  // Form Fields
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController zipController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController couponController = TextEditingController();
  String? selectedShippingMethod;
  String? selectedPaymentMethod = "Credit Card";

  List<Map<String, String>> shippingMethods = [];

  @override
  void initState() {
    super.initState();
    fetchShippingMethods();
  }

  Future<void> fetchShippingMethods() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/shipment'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          shippingMethods = data
              .map((shipment) => {
                    "id": shipment["id"].toString(),
                    "type": shipment["type"].toString(),
                  })
              .cast<Map<String, String>>()
              .toList();
        });
      } else {
        showError("Failed to fetch shipping methods.");
      }
    } catch (e) {
      showError("An error occurred while fetching shipping methods: $e");
    }
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'auth_token');
  }

  Future<void> submitCheckout() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final token = await getToken();

    if (token == null) {
      showError("Token not found. Please log in.");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/create/orders'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'first_name': firstNameController.text,
          'last_name': lastNameController.text,
          'address1': addressController.text,
          'address2': '', // Optional
          'coupon': couponController.text.isNotEmpty
              ? int.tryParse(couponController.text)
              : null,
          'phone': phoneController.text,
          'post_code': zipController.text,
          'email': emailController.text,
          'shipping': selectedShippingMethod != null
              ? int.parse(selectedShippingMethod!)
              : null,
          'payment_method': selectedPaymentMethod == 'Credit Card'
              ? 'paypal'
              : 'cod',
          'total_amount': widget.totalAmount,
          'country': countryController.text
        }),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        showSuccess("Order placed successfully!");
        print('Order ID: ${responseData['order_id']}');
        Navigator.pop(context);
      } else {
        final errorData = jsonDecode(response.body);
        showError("Error: ${errorData['message']}");
      }
    } catch (e) {
      showError("An error occurred: $e");
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.red)),
      ),
    );
  }

  void showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.green)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Checkout",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.orange,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Order Summary",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = widget.cartItems[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            "http://127.0.0.1:8000/${item['product']['photo']}",
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          item['product']['title'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("Quantity: ${item['quantity']}"),
                        trailing: Text(
                          "\$${item['amount']}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total",
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      "\$${widget.totalAmount}",
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                buildSectionHeader("Shipping Details"),
                buildTextFormField(
                  controller: firstNameController,
                  label: "First Name",
                  validator: "Please enter your first name",
                ),
                buildTextFormField(
                  controller: lastNameController,
                  label: "Last Name",
                  validator: "Please enter your last name",
                ),
                buildTextFormField(
                  controller: addressController,
                  label: "Address",
                  validator: "Please enter your address",
                ),
                buildTextFormField(
                  controller: cityController,
                  label: "City",
                  validator: "Please enter your city",
                ),
                buildTextFormField(
                  controller: countryController,
                  label: "Country",
                  validator: "Please enter your Country",
                ),
                buildTextFormField(
                  controller: zipController,
                  label: "ZIP Code",
                  keyboardType: TextInputType.number,
                  validator: "Please enter your ZIP code",
                ),
                buildTextFormField(
                  controller: phoneController,
                  label: "Phone Number",
                  keyboardType: TextInputType.phone,
                  validator: "Please enter your phone number",
                ),
                buildTextFormField(
                  controller: emailController,
                  label: "Email",
                  keyboardType: TextInputType.emailAddress,
                  validator: "Please enter your email",
                ),

                buildTextFormField(
                  controller: couponController,
                  label: "Coupon Code (optional)",
                ),
                const SizedBox(height: 16),
                buildSectionHeader("Shipping Method"),
                DropdownButtonFormField<String>(
                  value: selectedShippingMethod,
                  items: shippingMethods
                      .map((method) => DropdownMenuItem<String>(
                            value: method["id"],
                            child: Text(method["type"]!),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedShippingMethod = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return "Please select a shipping method";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                buildSectionHeader("Payment Method"),
                DropdownButtonFormField<String>(
                  value: selectedPaymentMethod,
                  items: ["Credit Card", "PayPal", "Cash on Delivery"]
                      .map((method) => DropdownMenuItem(
                            value: method,
                            child: Text(method),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentMethod = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: submitCheckout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      elevation: 5,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Submit Checkout",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.orange,
        ),
      ),
    );
  }

  Widget buildTextFormField({
    required TextEditingController controller,
    required String label,
    String? validator,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: validator != null
            ? (value) {
                if (value == null || value.isEmpty) {
                  return validator;
                }
                return null;
              }
            : null,
      ),
    );
  }
}
