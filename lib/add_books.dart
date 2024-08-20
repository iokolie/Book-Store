
import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'database.dart';

class AddBooks extends StatefulWidget {
  const AddBooks({Key? key}) : super(key: key);

  @override
  State<AddBooks> createState() => _AddBooksState();
}

class _AddBooksState extends State<AddBooks> {

  int _rating = 0; // Add a variable to hold the rating

  // Method to update the rating when the user taps on a star
  Widget buildRatingStars() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _rating = index + 1;
            });
          },
          child: Icon(
            index < _rating ? Icons.star_rounded : Icons.star_border_rounded,
            size: 40,
            color: Colors.amber,
          ),
        );
      }),
    );
  }

  final List<String> items = ['Fiction', 'Fantasy', 'Romance', 'Mystery', 'Novel', 'Thriller', 'Childrens Literature', 'True Crime', 'Manga'];
  String? value;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController genreController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController authorController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  String randomAlphaNumeric(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(length, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }

  Future<void> getImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  Future<void> uploadItem() async {
    if (selectedImage != null &&
        nameController.text.isNotEmpty &&
        authorController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        descController.text.isNotEmpty &&
        value != null) {
      try {
        final String addId = randomAlphaNumeric(10);
        final Reference firebaseStorageRef = FirebaseStorage.instance.ref().child("BookImages").child(addId);
        final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
        final TaskSnapshot snapshot = await task;
        final String downloadUrl = await snapshot.ref.getDownloadURL();

        final Map<String, dynamic> addItem = {
          "Image": downloadUrl,
          "Name": nameController.text,
          "Author": authorController.text,
          "Price": priceController.text,
          "Genre": value!,
          "Detail": descController.text,
          "Rating": _rating // Add rating to the item details
        };

        await DatabaseMethods().addBookInfo(addItem);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text('New book has been added!', style: TextStyle(fontSize: 20)),
          ),
        );

        // Clear fields after successful addition
        nameController.clear();
        authorController.clear();
        priceController.clear();
        descController.clear();
        genreController.clear();
        selectedImage = null;
        setState(() {});
      } catch (e) {
        print('Error uploading item: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('An error occurred. Please try again later.'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please provide all required information.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black),
        ),
        centerTitle: true,
        title: Text('Add Books'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Upload the Book Thumbnail', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 25),
              selectedImage == null
                  ? GestureDetector(
                      onTap: getImage,
                      child: Center(
                        child: Material(
                          elevation: 10.0,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: 170,
                            width: 150,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 2.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(Icons.camera_alt_outlined, color: Colors.black),
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Material(
                        elevation: 10.0,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: 170,
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(selectedImage!, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
              SizedBox(height: 25),
              Text('Book Title', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              SizedBox(height: 25),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(border: InputBorder.none, hintText: 'Enter Book Title'),
                ),
              ),
              SizedBox(height: 25),
              Text('Book Author', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              SizedBox(height: 25),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: authorController,
                  decoration: InputDecoration(border: InputBorder.none, hintText: 'Enter Book Author'),
                ),
              ),
              SizedBox(height: 25),
              Text('Book Rating', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              buildRatingStars(), // Add the rating stars here
              SizedBox(height: 25),
              Text('Book Price', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              SizedBox(height: 25),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(border: InputBorder.none, hintText: 'Enter Book Price'),
                ),
              ),
              SizedBox(height: 25),
              Text('Select Book Genre', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              SizedBox(height: 25),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items: items
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(item, style: TextStyle(fontSize: 18, color: Colors.black)),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() {
                      this.value = value;
                    }),
                    dropdownColor: Colors.white,
                    hint: Text('Select a Genre'),
                    iconSize: 30,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                    value: value,
                  ),
                ),
              ),
              SizedBox(height: 25),
              Text('Book Description', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              SizedBox(height: 25),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  maxLines: 6,
                  controller: descController,
                  decoration: InputDecoration(border: InputBorder.none, hintText: 'Enter Book Description'),
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: uploadItem,
                child: Center(
                  child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      width: 150,
                      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          'Add',
                          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
