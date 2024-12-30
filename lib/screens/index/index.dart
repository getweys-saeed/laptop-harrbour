import 'package:flutter/material.dart';
import 'package:laptop_harbour/config/colors.dart';
import 'package:laptop_harbour/globals/asset_path.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    final int _selectedIndex = 0;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
          child: AppBar(
            backgroundColor: Colors.transparent, // Transparent background
            elevation: 0, // No shadow
            leading: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(
                      255, 236, 236, 236), // Background color
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.menu, color: Colors.black, size: 28.0),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                        255, 231, 231, 231), // Background color
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.search, color: Colors.black, size: 28.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // "Hello Admin" text
              Row(
                children: [
                  Text(
                    "Hello Admin ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.waving_hand_outlined,
                    color: primaryColor,
                    size: 20,
                  ),
                ],
              ),
              Text(
                "Let's Start Shopping!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 5), // Space between text and cards

              // Discount Cards
              SizedBox(
                height: 230,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount:
                      5, // You may want to test this with different item counts or actual data
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        elevation: 8,
                        shadowColor: Colors.black45,
                        child: Column(
                          children: [
                            // Card Text
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "10% Off During Ramadan", // Example text
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Image Section
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: SizedBox(
                                width: 200,
                                height:
                                    100, // Adjust height to avoid image stretching
                                child: Image.asset(
                                  AssetPath
                                      .appLogo, // Ensure this is the correct path
                                  fit: BoxFit.cover, width: 300,
                                ),
                              ),
                            ),
                            // Button Section
                            Padding(
                              padding:
                                  const EdgeInsets.all(8.0), // Reduced padding
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orangeAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 8, // Reduced vertical padding
                                    horizontal:
                                        12, // Optionally add horizontal padding
                                  ),
                                ),
                                child: const Text(
                                  "Shop Now",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12, // Reduced font size
                                    fontWeight: FontWeight
                                        .w600, // Adjust font weight if needed
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Categories"),
                  GestureDetector(
                    child: Text(
                      "See All ",
                      style: TextStyle(color: primaryColor),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 30,
                child: Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: Material(
                            color: Colors
                                .transparent, // Make it transparent if needed
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                minimumSize:
                                    Size.zero, // Removes default minimum size
                                padding:
                                    EdgeInsets.zero, // Tightens button layout
                                backgroundColor: const Color.fromARGB(
                                    255, 234, 234, 234), // Set background color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: Icon(
                                Icons.laptop,
                                size: 24,
                                color: Colors.black, // Set icon color
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.black45,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favourite'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
