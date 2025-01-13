import 'package:flutter/material.dart';
import 'package:laptop_harbour/config/colors.dart';
import 'package:laptop_harbour/globals/asset_path.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "My Cart",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 60, 60, 60),
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6, bottom: 6),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 110,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                color: const Color.fromARGB(255, 241, 241, 241),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Container(
                                    height: 110,
                                    width: 100,
                                    child: Image.asset(
                                      AssetPath.appLogo,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        // Title - Ensure it takes full width of available space
                                        Text(
                                          "Hp laptop Core I5",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2, // Wrap to the next line if needed
                                        ),
                                        Text(
                                          "${20}",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Align widget for increment/decrement buttons
                                  Align(
                                    alignment: Alignment(0.0, 0.299),
                                    child: Container(
                                      height: 30,
                                      width: 120,  // Adjusted width for the button container
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(255, 250, 250, 250),
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center, // Centers the icons
                                        children: [
                                          // Decrement Button
                                          InkWell(
                                            borderRadius: BorderRadius.circular(20),
                                            onTap: () {
                                              print("Decrement for item $index");
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: Icon(
                                                Icons.remove,
                                                size: 18, // Smaller icon size
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          // Quantity Text
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                            child: Text(
                                              "1",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          // Increment Button
                                          InkWell(
                                            borderRadius: BorderRadius.circular(20),
                                            onTap: () {
                                              print("Increment for item $index");
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: Icon(
                                                Icons.add,
                                                size: 18, // Smaller icon size
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          // Cancel Button
                                          InkWell(
                                            borderRadius: BorderRadius.circular(20),
                                            onTap: () {
                                              print("Cancel for item $index");
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: Icon(
                                                Icons.cancel,
                                                size: 18,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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
                      Text(
                        "Total",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        "&888",
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor, // Set button color
                        padding: const EdgeInsets.symmetric(horizontal: 40), // Set padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Rounded corners
                        ),
                      ),
                      child: Text(
                        "Buy Now",
                        style: TextStyle(fontSize: 16, color: Colors.white),
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
