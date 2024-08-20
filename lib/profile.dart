import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  String? _displayName;
  String? _address;
  bool _editingName = false;
  bool _changingPassword = false;
  bool _addingAddress = false;
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    // Fetch address data from Firestore
    DocumentSnapshot<Map<String, dynamic>> addressSnapshot =
        await FirebaseFirestore.instance
            .collection('addresses')
            .doc(user.uid)
            .get();

    if (addressSnapshot.exists) {
      setState(() {
        _address = addressSnapshot.data()?['address'];
      });
    }

    // Update display name
    await user.reload();
    setState(() {
      _displayName = user.displayName;
      _editingName = _displayName == null;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50),
              ),
              SizedBox(height: 20),
              Text(
                user?.email ?? 'No User',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              if (_editingName)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Enter your name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                )
              else
                Text(
                  _displayName ?? '',
                  style: TextStyle(fontSize: 20),
                ),
                if (_address != null)
                SizedBox(height: 20),
                Text(
                  'Shipping Address: $_address',
                  style: TextStyle(fontSize: 20),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _editingName
                      ? _updateProfile(user)
                      : setState(() {
                          _editingName = true;
                        });
                },
                child: Text(_editingName ? 'Save Name' : 'Edit Name'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _addingAddress = true;
                  });
                },
                child: Text('Add Shipping Address'),
              ),
              SizedBox(height: 20),
              if (_addingAddress)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          labelText: 'Enter your shipping address',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          
                            updateUserAddress(userId, _addressController.text);
                          
                        },
                        child: Text('Save Address'),
                      ),
                    ],
                  ),
                ),
              
              SizedBox(height: 20),
              if (!_changingPassword)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _changingPassword = true;
                    });
                  },
                  child: Text('Change Password'),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Enter new password',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          _changePassword(user);
                        },
                        child: Text('Submit'),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateProfile(User? user) async {
    try {
      if (user != null && _nameController.text.trim().isNotEmpty) {
        await user.updateDisplayName(_nameController.text.trim());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile updated successfully'),
          ),
        );
        setState(() {
          _displayName = _nameController.text.trim();
          _editingName = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: $e'),
        ),
      );
    }
  }

  Future<void> _changePassword(User? user) async {
    try {
      if (user != null && _passwordController.text.trim().isNotEmpty) {
        await user.updatePassword(_passwordController.text.trim());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password changed successfully'),
          ),
        );
        setState(() {
          _changingPassword = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to change password: $e'),
        ),
      );
    }
  }

  // Function to retrieve current user ID from Firebase Authentication
Future<String?> getCurrentUserId() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return user.uid;
  } else {
    // If user is not signed in, return null
    return null;
  }
}

// Function to update user's address in Firestore
Future<void> updateUserAddress(String? userId, String newAddress) async {
  String? userId = await getCurrentUserId();
  try {
    // Get a reference to the "addresses" collection
    CollectionReference addressesCollection =
        FirebaseFirestore.instance.collection('addresses');

    // Check if the document exists for the user ID
    DocumentReference userAddressDocRef =
        addressesCollection.doc(userId);

    if (!(await userAddressDocRef.get()).exists) {
      // If the document doesn't exist, create it with the address
      await userAddressDocRef.set({'address': newAddress});
    } else {
      // If the document exists, update the address
      await userAddressDocRef.update({'address': newAddress});
    }

    print('Address updated successfully');
  } catch (e) {
    print('Error updating address: $e');
  }
}

// Function to update current user's address
Future<void> updateCurrentUserAddress(String newAddress) async {
  // Get current user's ID
  String? userId = await getCurrentUserId();

  if (userId != null) {
    // If user ID is available, update the address
    await updateUserAddress(userId, newAddress);
  } else {
    // Handle case where user is not signed in
    print('User is not signed in');
  }
}

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
