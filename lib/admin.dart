
import 'package:flutter/material.dart';
import 'add_books.dart'; // Import your AddBooks class here
import 'package:firebase_core/firebase_core.dart';

import 'manage_users.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp( // MaterialApp should wrap your entire app
      home: AdminHomePage(), // Use AdminHomePage as your home
    );
  }
}

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 55,),
            Text(
              'Admin Home',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddBooks(),
                      ),
                    );
                  },
                  child: Material(
                    elevation: 10.0,
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                          children: [
                            Icon(Icons.add_box_rounded,
                                size: 45, color: Colors.white),
                            SizedBox(width: 20),
                            Text(
                              'Manage Book Listings',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20),
                            )
                          ]),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30,),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Users(),
                      ),
                    );
                  },
                  child: Material(
                    elevation: 10.0,
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                          children: [
                            Icon(Icons.add_box_rounded,
                                size: 45, color: Colors.white),
                            SizedBox(width: 20),
                            Text(
                              'Manage User Accounts',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20),
                            )
                          ]),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
