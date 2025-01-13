import 'package:flutter/material.dart';

class OrderTrackingPage extends StatelessWidget {
  const OrderTrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Tracking'),
        centerTitle: true,
        backgroundColor: Colors.orange, // Set app bar color to orange
      ),
      body: SingleChildScrollView( // Added SingleChildScrollView to make the body scrollable
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Order History',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            
            // List of Orders
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 3, // Example: 3 orders, you can replace with dynamic data
              itemBuilder: (context, index) {
                return OrderCard(orderIndex: index);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final int orderIndex;

  const OrderCard({required this.orderIndex});

  @override
  Widget build(BuildContext context) {
    // Mock order details
    String orderNumber = 'ORD1234${
        orderIndex + 1
    }'; // Example order number
    String status = orderIndex == 0 ? 'Shipped' : orderIndex == 1 ? 'In Transit' : 'Delivered';
    String shippingDetails = 'Shipping to: John Doe, 123 Main Street, NY 10001';
    String deliveryDate = 'Estimated Delivery: 12th Jan, 2025';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Number
            Text(
              'Order Number: $orderNumber',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            // Order Status
            Row(
              children: [
                Text(
                  'Status: ',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: status == 'Shipped'
                        ? Colors.blue
                        : status == 'In Transit'
                            ? Colors.orange
                            : Colors.green,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            // Shipping Details
            Text(
              shippingDetails,
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8),
            // Estimated Delivery Date
            Text(
              deliveryDate,
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            // Track Order Button
            ElevatedButton(
              onPressed: () {
                // Show order details or tracking page when the button is pressed
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Tracking Details'),
                      content: Text('Tracking Order: $orderNumber\nCurrent Status: $status\nDelivery: $deliveryDate'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Button color
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
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
