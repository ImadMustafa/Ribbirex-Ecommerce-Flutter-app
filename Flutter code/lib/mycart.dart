import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'menupage.dart';

class Mycart extends StatefulWidget {
  final String uid;
  const Mycart({required this.uid, super.key });

  @override
  _MycartState createState() => _MycartState();
}

class _MycartState extends State<Mycart> {

List listProducts = [];
// ignore: unused_field
bool _requestdone = false;



@override
  void initState() {
    super.initState();
    
    getmycart();
    
  }



//we call this on refresh
 Future<void> callgetpro() async {
  getmycart();
 }

  //get product method
  Future<void> getmycart() async {
      setState(() {
        _requestdone = false;
      });

     
      final uid = widget.uid;  
      //we map the data
      final useinfo = {
        'uid':uid,
        };

      
      //we convert the data into a json
      final injs = jsonEncode(useinfo);

     //we get all the products info
      final response = await http.post(
      Uri.parse('https://navajowhite-worm-558163.hostingersite.com/getmycart.php'),
      body: injs
  
    );
    
   
    if(response.statusCode == 200){
      final projs = response.body;
      final prol = jsonDecode(projs);
     
  
      setState(() {
        listProducts = prol;
      });

    }
    else{
         if(mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Server or Client error.')),
      );
    }
  
    }
      setState(() {
        _requestdone = true;
      });

  }
  //get product end


  //remove from cart
 Future<void> removecart(value) async {

    //we get all the info
      final proid = value;
      final uid = widget.uid;  
      
      
       final proinfox = {
        'uid':uid,'prid':proid,
      };
    
      
      //we convert the data into a json
      final injs = jsonEncode(proinfox);

       //we send the json to our php to check the username and password
      final response = await http.post(
      Uri.parse('https://navajowhite-worm-558163.hostingersite.com/removefromcart.php'),
      body: injs,
    );

    if(response.statusCode == 200){

    if(mounted){

        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Removed')),
      );

      }


    }
    else{

      if(mounted){

        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot Remove')),
      );

      }

    }

    if(mounted){

    Navigator.of(context).pop();

    }


 }
 //remove cart end


  Future<void> _buyallcart() async {

    if(listProducts.isNotEmpty){
    //we get all the info
      final uid = widget.uid;
      final total = listProducts.last['total'];
      
      
       final proinfox = {
        'uid':uid,'total':total
      };

      
      //we convert the data into a json
      final injs = jsonEncode(proinfox);

       //we send the json to our php to check the username and password
      final response = await http.post(
      Uri.parse('https://navajowhite-worm-558163.hostingersite.com/buyallcart.php'),
      body: injs,
    );

    if(response.statusCode == 200){

    if(mounted){

        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All products purchased')),
      );

      }


    }
    else if(response.statusCode == 403){

    if(mounted){

        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insufficient balance')),
      );

      }


    }
    else{

   ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insufficient balance')),
      );


    }

    }
  }


  @override
  Widget build(BuildContext context) {
      return PopScope(
        onPopInvoked: (didPop) {
             Navigator.pushAndRemoveUntil(
            context,
          MaterialPageRoute(builder: (context) => const Menupage()),
          (route) => false,);
        
          
        },
        child: Scaffold(
        backgroundColor: const Color(0xFFFCEDC2),
           appBar: AppBar(
          backgroundColor: const Color(0xFFFCEDC2),
          title: const Text("Cart",style:TextStyle(fontWeight: FontWeight.bold)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
                  
             Navigator.pushAndRemoveUntil(
            context,
          MaterialPageRoute(builder: (context) => const Menupage()),
          (route) => false,);
            
            }
          ),
          
         
        ),
            
        
          body: Stack(
          children: [
            RefreshIndicator(
              onRefresh: callgetpro,
              child: CustomScrollView(
                slivers: [
                   const SliverAppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor:  const Color(0xFFFCEDC2),
                    floating: true,
                    snap: true, 
                    centerTitle: true,
                    title:  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                     
        
                    ),
                    
              
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 3.5,
                        crossAxisCount: 1,
                        crossAxisSpacing: 20.0,
                        mainAxisSpacing: 20.0,
                      ),
                      delegate: SliverChildBuilderDelegate(
                          childCount: listProducts.length,
                            (BuildContext context, int index) {
                              
                              return InkWell(
                                splashColor: const Color.fromARGB(255, 248, 3, 3),
                                
                                onTap: (){
            
                                },
                                
                                  child: Container(
                                    color: const Color(0xFFC2D1D9),
                                    height: 100,
                                    width: 100,
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Container(
                                      color: const Color(0xFFF2F5F7),
                                      height: 50,
                                      width: 5,
                                        child: Stack(
                                          children: [
                                            Row(
                                              children: [
                                                 CachedNetworkImage(
                                                  imageUrl: listProducts[index]['pimgs'],
                                                  width: 130,
                                                  height: 130,
                                                   fit: BoxFit.cover,
                                                  placeholder: (context, url) => const CircularProgressIndicator(),
                                                 errorWidget: (context, url, error) => const Icon(Icons.error),),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(vertical: 15.0),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                      Text(listProducts[index]['pname'], style: const TextStyle(color:Color(0xFF435964), fontWeight: FontWeight.bold, fontSize: 18),),
                                                      const SizedBox(height: 10,),
                                                        Row(children: [
                                                          Container(width: 80 ,child: Text('US\$${listProducts[index]['pprice']}', style: const TextStyle(fontSize: 16 ,fontWeight: FontWeight.bold,color:Color(0xFF435964,)))),
                                                          Text(listProducts[index]['trad'] == '1' ? "Tradeable" : "Not Tradeable"),
                                                        ],),
                                                    ],),
                                                  ),
                                                ),


                                              ],
                                            ),
                                                                     Positioned(
                                            top: 10,
                                          right: 10,
                                         child: PopupMenuButton(
                                              itemBuilder: (BuildContext context) => [
                                              PopupMenuItem(
                                              value: 'Operation',
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [

                                          TextButton(onPressed:() {


                                        showDialog(context: context, builder: (BuildContext context) {
                                          return AlertDialog(
                                        title: const Text("Confirmation"),
                                        content: const Text("Are you sure you want to delete your product?"),
                                        actions: [

                                          TextButton(
                                            child: const Text("Cancel"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                          },
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color.fromARGB(255, 160, 154, 154),
                                          ),
                                          child: const Text("Remove",style: TextStyle(color: Colors.black),),
                                          onPressed: () {
                                          removecart(listProducts[index]['pid']).then(
                                            (value) => Navigator.of(context).pop()).then(
                                            (value) => getmycart());


                                          },
                                        ),
                                          ],
                                          );
                                        });

                                                  },
                                                  child: const Text("Remove"),),
                                                ],
                                              ),
                                              ),
                                              ],
                                              icon: const Icon(Icons.more_vert),
                                            ),
                                            ),



                                                                       ],

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
             
          ],
        ),
          floatingActionButton: SizedBox(
            width: 130,
            height: 80,
            child: FloatingActionButton(
              backgroundColor: Color(0xFF49AFD2),
              onPressed: () {
                _buyallcart().then((value) => getmycart());
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text("Total: \$${listProducts.isNotEmpty ? listProducts.last['total'].toString() : ""}", style: TextStyle(fontSize: 16),),
                    Text("Buy all", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),),
                  ],
                ),
              ),
            ),
          ),





        ),
      );
  
    
  }
}