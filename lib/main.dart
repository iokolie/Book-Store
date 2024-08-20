import 'package:book_store_app/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'admin.dart';
import 'firebase_options.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
     debugShowCheckedModeBanner: false,
    home: Bookapp(
      
    ),
  ));
  
}

class Bookapp extends StatefulWidget {
  const Bookapp({super.key});

  @override
  State<Bookapp> createState() => _BookAppState();
}

class _BookAppState extends State<Bookapp> {

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  } 
  static Future<User?> signupfunction({
    required String email, 
    required String password, 
    required BuildContext context}) async{
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try{
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch(e){
      if(e.code == "user-not-found"){
        print("No user found for that email");
      }
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {

    TextEditingController emailcontroller = TextEditingController();
    TextEditingController passwdcontroller = TextEditingController();

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder(
          future: _initializeFirebase(),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.done){
          return Container(
            child: Stack(
              children: [
                Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/2),
                padding: EdgeInsets.only(top: 45, left: 20, right: 20),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color.fromARGB(255, 27, 1, 95), Color.fromARGB(224, 72, 64, 165), ], 
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
                              child: Text('Register', 
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
                            controller: emailcontroller,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFececf8),
                              labelText: 'Email Address',
                              labelStyle: TextStyle(fontFamily: 'Manrope'),
                              
                              hintStyle: TextStyle(fontFamily: 'Manrope'),
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder( borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none
                              )
                            ),
                            onChanged: (String value){},
                              validator: (value){
                                return value!.isEmpty ? 'Please enter email' : emailcontroller.text = value;
                              },
                            ),
                          ),
                                        
                          Padding(
                          padding: const EdgeInsets.fromLTRB(40,0,40,0),
                          child: TextFormField(
                            controller: passwdcontroller,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xFFececf8),
                            labelText: 'Password',
                            labelStyle: TextStyle(fontFamily: 'Manrope'),
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20), 
                              borderSide: BorderSide.none)
                            ),
                            onChanged: (String value){},
                            validator: (value){
                              return value!.isEmpty ? 'Please enter password' : passwdcontroller.text = value;
                                  },
                                ),
                                ),
                                        
                            SizedBox(height: 20,),
                            GestureDetector(
                              onTap: () async{
                                  User? user = await signupfunction(email: emailcontroller.text, password: passwdcontroller.text, context: context);
                                  print(user);
                                  if(user != null){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                                  }
                                },
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
                                    child: Text('Register', 
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                          }, 
                          child: Text('Already registered? Click to Login', 
                          style: TextStyle(
                            color: Color.fromARGB(255, 27, 1, 95), 
                            fontSize: 17, 
                            fontFamily: 'Manrope'),),
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
          );
                          }
                return const Center(child: CircularProgressIndicator(),);
              }
        ),
      ),
    );
  }
}