import 'package:book_store_app/details.dart';
import 'package:book_store_app/profile.dart';

import 'database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Stream<QuerySnapshot> BookInfoStream = DatabaseMethods().getBookInfo();

  ontheload() async{
    BookInfoStream;
    setState(() {
    
  });
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  Widget allBooks(){
  return StreamBuilder(
    stream: BookInfoStream,
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
      return snapshot.hasData ? ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: snapshot.data!.docs.length, // Corrected this line
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index){
          DocumentSnapshot ds = snapshot.data!.docs[index];
          return GestureDetector(
            onTap: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Details2(
                name: ds["Name"], 
                image: ds["Image"], 
                author: ds["Author"], 
                detail: ds["Detail"], 
                genre: ds["Genre"], 
                price: ds["Price"], 
                rating: ds["Rating"], 
                bookTitle: ds["Name"],)));
            },
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 0.0, top: 0),
                          child: Image.network(ds["Image"], height: 170, width: 150, fit: BoxFit.cover,),
                        ),
                        Text(ds["Name"], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        SizedBox(height: 5,),
                        Text(ds["Author"], 
                          style: TextStyle(
                            color: Colors.black38, 
                            fontSize: 15, 
                            fontWeight: FontWeight.w500),),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Text("\$" + ds["Price"], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                            SizedBox(
                              width: 80,
                            ),
                            Text("${ds["Rating"] ?? "Not rated"}", style: TextStyle(fontSize: 18),), // Display rating or "Not rated" if rating is not available
                        Icon(Icons.star_rounded, color: Colors.amber, size: 25,),
                          ],
                        ),
                        
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      ) : CircularProgressIndicator();
    }
  );
}




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          margin: EdgeInsets.only(top: 60, left: 20, right: 20),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Hello User', 
                    style: TextStyle(
                      color: Colors.black, 
                      fontSize: 20, fontWeight: FontWeight.bold),),
            
                      SizedBox(width: 30,),
                    
                    Container(
            
                      margin: EdgeInsets.only(left: 90),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(Icons.search_rounded, color: Colors.white, size: 30,),
                    ),
                    decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),),
                    ),
                  
                    Container(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(Icons.shopping_cart_rounded, color: Colors.white, size: 30,),
                    ),
                    decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset("images/img1.JPG",height: 40, width: 40, fit: BoxFit.cover,),
                      ),
                    )
                  
                    
                  
                    ],
                ),
                  
                SizedBox(height: 30,),
                  
                Text('Book Store', 
                style: TextStyle(
                  color: Colors.black, 
                  fontSize: 24, 
                  fontWeight: FontWeight.bold),),
            
                  Text('Discover and Get Wonderful Books', 
                style: TextStyle(
                  color: Colors.black38, 
                  fontSize: 15, 
                  fontWeight: FontWeight.w500),),
            
                  Text('Categories', 
                style: TextStyle(
                  color: Colors.black, 
                  fontSize: 19, 
                  fontWeight: FontWeight.normal),),
            
                  SizedBox(height: 15,),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: (){
            
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black, 
                              borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Fiction', style: TextStyle(color: Colors.white, fontSize: 20),),
                            ),
                          ),
                        ),
                        SizedBox(width: 15,),
            
                        GestureDetector(
                          onTap: () {
                            
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black, 
                              borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Novel', style: TextStyle(color: Colors.white, fontSize: 20),),
                            ),
                          ),
                        ),
                        SizedBox(width: 15,),
            
                        GestureDetector(
                          onTap: () {
                            
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black, 
                              borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Romance', style: TextStyle(color: Colors.white, fontSize: 20),),
                            ),
                          ),
                        ),
                        SizedBox(width: 15,),
            
                        GestureDetector(
                          onTap: () {
                            
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black, 
                              borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('True Crime', style: TextStyle(color: Colors.white, fontSize: 20),),
                            ),
                          ),
                        ),
                        SizedBox(width: 15,),
            
            
                        GestureDetector(
                          onTap: () {
                            
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black, 
                              borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Mystery', style: TextStyle(color: Colors.white, fontSize: 20),),
                            ),
                          ),
                        ),
                        SizedBox(width: 15,),
            
                        GestureDetector(
                          onTap: () {
                            
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black, 
                              borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Manga', style: TextStyle(color: Colors.white, fontSize: 20),),
                            ),
                          ),
                        ),
                        SizedBox(width: 15,),
            
                        GestureDetector(
                          onTap: () {
                            
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black, 
                              borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Fantasy', style: TextStyle(color: Colors.white, fontSize: 20),),
                            ),
                          ),
                        ),
                        SizedBox(width: 15,),
            
                        GestureDetector(
                          onTap: () {
                            
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black, 
                              borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Thriller', style: TextStyle(color: Colors.white, fontSize: 20),),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            
                  SizedBox(height: 30,),
                  Text('New Arrivals', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
            
                  Container(
                    height: 290,
                    child: allBooks()),
            
                  SizedBox(height: 30,),
            
            
                  Column(
                    children: [
            
                      
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                          child: Row(children: [
                            GestureDetector(
                              onTap: () {
                                
                              },
                              child: Material(
                                elevation: 3,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 16.0, top: 10),
                                          child: Image.asset("images/img1.JPG", height: 170, width: 150, fit: BoxFit.cover,),
                                        ),
                                        Text('Book 1', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                        SizedBox(height: 5,),
                                        Text('Random book decription', 
                                        style: TextStyle(
                                          color: Colors.black38, 
                                          fontSize: 15, 
                                          fontWeight: FontWeight.w500),),
                                          SizedBox(height: 5,),
                                                        
                                        Text('\$100', style: TextStyle(fontSize:18, fontWeight: FontWeight.bold),),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          
                            SizedBox(width: 30,),
                          
                            GestureDetector(
                              onTap: () {
                                
                              },
                              child: Material(
                                elevation: 3,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 16.0, top: 10),
                                          child: Image.asset("images/img1.JPG", height: 170, width: 150, fit: BoxFit.cover,),
                                        ),
                                        Text('Book 1', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                        SizedBox(height: 5,),
                                        Text('Random book decription', 
                                        style: TextStyle(
                                          color: Colors.black38, 
                                          fontSize: 15, 
                                          fontWeight: FontWeight.w500),),
                                          SizedBox(height: 5,),
                                                        
                                        Text('\$100', style: TextStyle(fontSize:18, fontWeight: FontWeight.bold),),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      
                            SizedBox(width: 30,),
                      
                            GestureDetector(
                            onTap: () {
                              
                            },
                            child: Material(
                              elevation: 3,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 16.0, top: 10),
                                        child: Image.asset("images/img1.JPG", height: 170, width: 150, fit: BoxFit.cover,),
                                      ),
                                      Text('Book 1', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                      SizedBox(height: 5,),
                                      Text('Random book decription', 
                                      style: TextStyle(
                                        color: Colors.black38, 
                                        fontSize: 15, 
                                        fontWeight: FontWeight.w500),),
                                        SizedBox(height: 5,),
                                                      
                                      Text('\$100', style: TextStyle(fontSize:18, fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          ],),
                        ),
                      ),
                    ],
                  )
            
                  ],
            
                  
            
                  
            
            ),
          ),
      
        ),
      ),
    );
  }
}