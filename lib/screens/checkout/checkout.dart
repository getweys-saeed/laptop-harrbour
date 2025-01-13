import 'package:flutter/material.dart';
import 'package:laptop_harbour/globals/asset_path.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
        centerTitle: true,
      ),
      body: SingleChildScrollView( // Wrap the body in SingleChildScrollView for scrolling
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cart Summary
            Text(
              'Cart Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Divider(),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 3, // Replace with your cart item count
              itemBuilder: (context, index) {
                int quantity = 2; // Example quantity, replace with dynamic data
                double price = 20.00; // Example price, replace with actual price
                double totalPrice = quantity * price;

                return Container(
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.grey[200], 
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Container(
                        height: 110,
                        width: 100,
                        child: Image.asset(
                         AssetPath.appLogo, // Replace with your actual asset path
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Item ${index + 1}",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                            ),
                            Text(
                              "\$${price.toStringAsFixed(2)} x $quantity",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Total: \$${totalPrice.toStringAsFixed(2)}",
                              style: TextStyle(fontSize: 16, color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 16),
            Divider(),

            // Shipping Address
            Text(
              'Shipping Address',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Enter Shipping Address',
                  hintText: 'e.g. John Doe, 123 Main Street, New York, NY 10001',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 16),
            Divider(),

            // Payment Method
            Text(
              'Payment Method (IBAN)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Enter IBAN Number',
                  hintText: 'e.g. DE89370400440532013000',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 16),
            Divider(),

            // Order Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total (3 items)', // Display the number of items dynamically
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  '\$60.00', // Total amount
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Checkout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle checkout logic here
                  print('Proceed to Payment');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Set button background color to orange
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Proceed to Payment',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
