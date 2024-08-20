import 'dart:ui';
import 'package:flutter/material.dart';
import 'database.dart';

class Details2 extends StatefulWidget {
  final String bookTitle;
  final String image, name, detail, author, genre, price;
  final int rating;
  Details2({
    required this.name, 
    required this.image, 
    required this.author, 
    required this.detail, 
    required this.genre, 
    required this.price,
    required this.rating,
    required this.bookTitle
    });

  @override
  State<Details2> createState() => _Details2State();
}

class _Details2State extends State<Details2> {
  final TextEditingController _reviewController = TextEditingController();
  int _rating = 0;

  


  void submitReview() async {
    // Validate review parameters
    if (validateReviewParams(_rating, _reviewController.text)) {
      // Parameters are valid, add the review
      await DatabaseMethods().addReview(widget.bookTitle, 'User', _rating, _reviewController.text);
      // Clear the review text field and rating
      _reviewController.clear();
      setState(() {
        _rating = 0;
      });
      // Show a success message or navigate to another page
      print('Review submitted successfully.');
    }
  }


  bool validateReviewParams(int rating, String reviewText) {
  // Check if rating is valid (1 to 5)
  if (rating < 1 || rating > 5) {
    print('Invalid rating. Rating must be between 1 and 5.');
    return false;
  }

  // Check if review text is not empty
  if (reviewText.trim().isEmpty) {
    print('Review text cannot be empty.');
    return false;
  }

  // All parameters are valid
  return true;
}


  
  
  
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: NetworkImage(widget.image), fit: BoxFit.cover),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  leading: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(255, 147, 147, 147).withOpacity(0.2),
                        ),
                        child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 30),
                      ),
                    ),
                  ),
                  expandedHeight: 450,
                  flexibleSpace: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Image.network(widget.image, width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height / 2),
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: scrollmethod(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container scrollmethod() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.elliptical(MediaQuery.of(context).size.width, 50)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(left: 20, top: 10, right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Row(
              children: [
                SizedBox(height: 70),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 218, 218, 218).withOpacity(0.31),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.genre,
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 20),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15),
              ],
            ),
            SizedBox(height: 10),
            Text(widget.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(widget.author, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black45)),
            SizedBox(height: 10),
            Text('\$' + widget.price, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                5,
                (index) {
                  return Icon(
                    index < widget.rating ? Icons.star_rounded : Icons.star_border_rounded,
                    size: 40,
                    color: Colors.amber,
                  );
                },
              ),
            ),
            Text('Book Overview', style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(
              widget.detail,
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            SizedBox(height: 12,),
            Center(
              child: GestureDetector(
                onTap: () {},
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 270,
                    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, right: 22.0, left: 22.0 ),
                      child: Row(
                        children: [
                          Icon(Icons.shopping_cart_rounded, size: 40, color: Colors.white,),
                          SizedBox(width: 22,),
                          Text("Add to Cart", style: TextStyle(fontSize: 27, color: Colors.white),),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 25,),
            Text("Reviews", style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)),
            SizedBox(height: 12,),
            ReviewsWidget(bookTitle: widget.bookTitle),
            
            Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rate this book:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Row(
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < _rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                ),
                onPressed: () {
                  setState(() {
                    _rating = index + 1;
                  });
                },
              );
            }),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _reviewController,
            decoration: InputDecoration(
              labelText: 'Write your review...',
              border: OutlineInputBorder(),
            ),
            maxLines: 5,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: submitReview,
            child: Text('Submit Review'),
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



// Sample data for reviews (replace it with data fetched from the database)
List<Review> reviews = [
  Review(
    userName: 'User1',
    rating: 4,
    reviewText: 'Great book! Highly recommended.',
    likes: 10,
  ),
  Review(
    userName: 'User2',
    rating: 5,
    reviewText: 'Amazing book! Must read.',
    likes: 15,
  ),
];

class Review {
  String? userName;
  final int rating;
  final String reviewText;
  int likes; // Updated to store likes

  Review({
    this.userName,
    required this.rating,
    required this.reviewText,
    required this.likes,
  });

  // Method to increment likes
  void like() {
    likes++;
  }
}



class ReviewsWidget extends StatefulWidget {
  final String bookTitle;

  ReviewsWidget({required this.bookTitle});

  @override
  _ReviewsWidgetState createState() => _ReviewsWidgetState();
}

class _ReviewsWidgetState extends State<ReviewsWidget> {
  late Stream<List<Map<String, dynamic>>> _reviewsStream;

  @override
  void initState() {
    super.initState();
    _reviewsStream = _fetchReviewsForBook();
  }

  Stream<List<Map<String, dynamic>>> _fetchReviewsForBook() {
    String? bookTitle = widget.bookTitle;
    if (bookTitle != null) {
      return DatabaseMethods().getReviewsForBook(bookTitle);
    } else {
      return Stream.value([]); // Return empty stream if book not found
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _reviewsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<Map<String, dynamic>> reviews = snapshot.data ?? [];
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              // Build your review list tile here
              // You can use the data from reviews[index]
              return ListTile(
                title: Text('User'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Rating: ${reviews[index]['rating']}'),
                    Text(reviews[index]['reviewText'] ?? ''),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.thumb_up),
                          onPressed: () {
                            // Handle like functionality
                            setState(() {
                              reviews[index]['likes']++;
                            });
                          },
                        ),
                        Text('${reviews[index]['likes']}'),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}
