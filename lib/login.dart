import 'package:book_store_app/admin.dart';
import 'package:book_store_app/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Function to handle login button press
  void _signInWithEmailAndPassword() async {
    try {
      // Sign in with email and password
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // If login successful, check for specific credential and navigate accordingly
      if (userCredential != null) {
        final User? user = userCredential.user;
        print(user);
        // Check for specific credential
        if (emailController.text == 'admin@gmail.com' && passwordController.text == 'admin123') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminPage()));
        } else {
          // Route to a default page if not a specific credential
          Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
        }
      }
    } catch (e) {
      // Handle login errors
      print('Error: $e');
      // You can display an error message to the user here
    }
  }

  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Stack(
            children: [
              Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/2),
              padding: EdgeInsets.only(top: 45, left: 20, right: 20),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color.fromARGB(255, 27, 1, 95), Color.fromARGB(224, 72, 64, 165),], 
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.elliptical(MediaQuery.of(context).size.width, 110)
                  )
              ),
            ),
            
          
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)
                ),
                margin: EdgeInsets.only(left: 30, right: 30, top: 90),

                child: SingleChildScrollView(
                          child: Form(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            Text('Welcome to Our Book Store', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, fontFamily: 'Gloock'),),

                            Padding(
                            padding: const EdgeInsets.fromLTRB(0,30,0,35),
                            child: Text('Login', 
                            style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Gloock'
                          ),),
                                ),
                              
                      Material(
                        elevation: 6.0,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: Column(
                            children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(40,30,40,30),
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFececf8),
                          labelText: 'Email Address',
                          labelStyle: TextStyle(fontFamily: 'Manrope'),
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder( borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none,)
                        ),
                        onChanged: (String value){},
                          validator: (value){
                            return value!.isEmpty ? 'Please enter email' : null;
                          },
                        ),
                      ),
              
                      Padding(
                      padding: const EdgeInsets.fromLTRB(40,0,40,0),
                      child: TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFececf8),
                        labelText: 'Password',
                        labelStyle: TextStyle(fontFamily: 'Manrope'),
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (String value){},
                        validator: (value){
                          return value!.isEmpty ? 'Please enter password' : null;
                              },
                            ),
                            ),
                        SizedBox(height: 20,),
                            GestureDetector(
                              onTap: _signInWithEmailAndPassword,
                              child: Material(
                                elevation: 3,
                                borderRadius: BorderRadius.circular(10),
                                
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  width: 275,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 5, top: 5),
                                  child: Center(
                                    child: Text('Login', 
                                    style: TextStyle(
                                      fontSize: 30, 
                                      color: Colors.white,
                                      fontFamily: 'Catamaran'),)),
                                ),            
                                  ),
                              ),
                            ),
                      
                      Padding(
                      padding: const EdgeInsets.fromLTRB(0,10,0,20),
                      child: TextButton(
                      onPressed: (){
                      Navigator.pop(context);
                      }, 
                      child: Text('Not registered? Click to Register', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontFamily: 'Manrope', fontSize: 17),),
                      ),
                    ),
                            ],
                          ),
                        
                        ),
                      ),
                                        
                     
                          ],
                          ),
                        ),
                        ),
              )
          
            ],
            
          ),
        ),
      ),
    );;
  }
}