import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future<void> addUserDetail(Map<String, dynamic> userInfoMap, String id) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .set(userInfoMap);
  }

  
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getReviewsForBook(String bookTitle) {
  try {
    return _firestore
        .collection('books')
        .doc(bookTitle)
        .collection('reviews')
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.map((doc) => doc.data()).toList());
  } catch (e) {
    print('Error fetching reviews: $e');
    throw e;
  }
}
  Future<void> updateLikes(String bookTitle, String reviewId, int likes) async {
  try {
    await FirebaseFirestore.instance
        .collection('books')
        .doc(bookTitle)
        .collection('reviews')
        .doc(reviewId)
        .update({'likes': likes + 1});
  } catch (e) {
    print('Error updating likes: $e');
    throw e;
  }
}
  
  Future<void> addReview(String bookTitle, String userName, int rating, String reviewText) async {
  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('books')
        .where('Name', isEqualTo: bookTitle)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      
      DocumentReference reviewRef = await FirebaseFirestore.instance
      
          .collection('books')
          .doc(bookTitle)
          .collection('reviews')
          .add({
        'userName': userName,
        'rating': rating,
        'reviewText': reviewText,
        'likes': 0, // Initialize likes to 0
        'timestamp': DateTime.now(), // Optional: Add timestamp
      });
      updateLikes(bookTitle, reviewRef.id, 0);
    } else {
      print('Book not found for title: $bookTitle');
    }
  } catch (e) {
    print('Error adding review: $e');
    throw e;
  }
}



  Future<void> addBookInfo(Map<String, dynamic> bookInfoMap) async {
    await FirebaseFirestore.instance
        .collection('books')  // Store all book information in the "books" collection
        .add(bookInfoMap);
  }

  Stream<QuerySnapshot> getBookInfo() {
    return FirebaseFirestore.instance.collection('books').snapshots();
  }
}
