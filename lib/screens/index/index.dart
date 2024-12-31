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
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
              // Categories
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
              // List Of Categories
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
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 items per row
                      crossAxisSpacing: 10, // Spacing between items
                      mainAxisSpacing: 10, // Spacing between items
                      childAspectRatio: 0.8, // Adjusted for smaller card size
                    ),
                    itemCount: 10, // Total number of items
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(
                            6), // Reduced padding for smaller cards
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              12), // Slightly smaller radius
                          color: Color.fromARGB(
                              255, 240, 240, 240), // Background color
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300, // Subtle shadow
                              blurRadius: 5,
                              offset: Offset(0, 3), // Shadow with slight offset
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 2), // Padding for the text
                                  decoration: BoxDecoration(
                                    color: Colors.red, // Background color
                                    borderRadius: BorderRadius.circular(
                                        8), // Optional: rounded corners
                                  ),
                                  child: Text(
                                    "Sale 50%",
                                    style: TextStyle(
                                      color: Colors.white, // Text color
                                      fontSize: 12,
                                      fontWeight: FontWeight
                                          .bold, // Optional: for emphasis
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(
                                      2), // Small padding to ensure the icon doesn't touch the border
                                  decoration: BoxDecoration(
                                    shape: BoxShape
                                        .circle, // Makes the container circular
                                    color: Colors
                                        .transparent, // Transparent background (optional)
                                    border: Border.all(
                                      color: Color.fromARGB(
                                          255, 162, 162, 162), // Border color
                                      width: 1, // Border width
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.favorite,
                                    size: 16, // Icon size
                                    color: Color.fromARGB(
                                        255, 162, 162, 162), // Icon color
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                                height:
                                    8), // Added space between icons and image
                            Container(
                              width: double
                                  .infinity, // Ensure the image takes up full width
                              height: 90, // Reduced height of the card
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    10), // Rounded image corners
                                child: Image.asset(
                                  AssetPath.appLogo,
                                  width: double.infinity,
                                  height:
                                      80, // Set the height of the image to make it taller
                                  fit: BoxFit
                                      .cover, // Ensures the image covers the container
                                ),
                              ),
                            ),
                            SizedBox(height: 8), // Space between image and text
                            Text(
                              overflow: TextOverflow.ellipsis,
                              "Company Logo Represented",
                              style: TextStyle(
                                fontSize: 12, // Smaller font size
                                fontWeight: FontWeight
                                    .w800, // Regular weight for better readability
                                color:
                                    Colors.black87, // Darker text for contrast
                              ),
                            ),
                            Spacer(), // Pushes the rating icons to the bottom
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              )
            ]),
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
