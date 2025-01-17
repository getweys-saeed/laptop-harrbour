import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({super.key});

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  List<dynamic> orders = [];
  final FlutterSecureStorage storage = FlutterSecureStorage();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    const String apiUrl = 'http://127.0.0.1:8000/api/orders';
String? token = await storage.read(key: 'auth_token');
    if (token == null) {
      throw Exception('Token is missing');
    } // Replace with actual token

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          orders = data['data']['data']; // Extract the orders list
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showError('Failed to fetch orders. Please try again.');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showError('An error occurred. Please try again.');
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Tracking'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? const Center(child: Text('No orders found.'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Order History',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          return OrderCard(order: orders[index]);
                        },
                      ),
                    ],
                  ),
                ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final dynamic order;

  const OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    String orderNumber = order['order_number'];
    String status = order['status'];
    String shippingDetails =
        'Shipping to: ${order['first_name']} ${order['last_name']}, ${order['address1']}';
    String deliveryDate =
        'Placed on: ${DateTime.parse(order['created_at']).toLocal()}';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Number: $orderNumber',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Status: ', style: TextStyle(fontSize: 16)),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: status == 'new'
                        ? Colors.blue
                        : status == 'process'
                            ? Colors.orange
                            : status == 'delivered'
                                ? Colors.green
                                : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(shippingDetails, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            Text(deliveryDate, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Tracking Details'),
                      content: Text(
                        'Tracking Order: $orderNumber\nCurrent Status: $status\nDelivery: $deliveryDate',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                'Track Order',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
