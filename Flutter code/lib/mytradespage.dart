import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'menupage.dart';
import 'package:http/http.dart' as http;

class Mytradespage extends StatefulWidget {
  final String uid;
  const Mytradespage({required this.uid, super.key });

  @override
  _MytradespageState createState() => _MytradespageState();
}


class _MytradespageState extends State<Mytradespage> {



List listProducts = [];
List listProducts2 = [];
String test = "";
// ignore: unused_field
bool _requestdone = true;

String limitwords(String txt){
  if(txt.length > 12){
    return "${txt.substring(0, 12)}...";
  }else{
    return txt;
  }
}

@override
  void initState() {
    super.initState();
     _gettradesrece();
    _gettradessent();
   
    
  }


//we call this on refresh
 Future<void> callgettrade() async {
  _gettradessent();
  _gettradesrece();
 }


//get sent trades request start
Future <void> _gettradessent() async{

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
      Uri.parse('https://navajowhite-worm-558163.hostingersite.com/gettradessent.php'),
      body: injs
  
    );
    
    if(response.statusCode == 200){
      
      final projs = response.body;
    
  
      final prol = jsonDecode(projs);
      setState(() {
        listProducts = prol;
      });


    }

}
//get sent trade request end



//get received trades start
Future <void> _gettradesrece() async{

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
      Uri.parse('https://navajowhite-worm-558163.hostingersite.com/getreceivedtrade.php'),
      body: injs
  
    );
    
    if(response.statusCode == 200){
      
      final projs = response.body;

      final prol = jsonDecode(projs);
      setState(() {
        listProducts2 = prol;
      });


    }

}
//get received request end


//cancel trade start
Future <void> _canceltrade(tradid) async{

final tradeid = tradid;

//we map the data
      final useinfo = {
        'tradeid':tradeid,
        };

      
      //we convert the data into a json
      final injs = jsonEncode(useinfo);
     //we get all the products info
      final response = await http.post(
      Uri.parse('https://navajowhite-worm-558163.hostingersite.com/canceltrade.php'),
      body: injs
  
    );
    
    if(response.statusCode == 200){
      
      if(mounted){

         ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trade cancelled')),
      );

      }

    }
    else{

        if(mounted){

         ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to cancel the trade.')),
      );

      }

    }

}
//trade cancel end


//trade reject and accept start
Future <void> _rejactrade(tradid,keyx) async {


final tradeid = tradid;
final ekey = keyx;

//we map the data
      final useinfo = {
        'tradeid':tradeid,'key':ekey,
        };

      
      //we convert the data into a json
      final injs = jsonEncode(useinfo);
     //we get all the products info
      final response = await http.post(
      Uri.parse('https://navajowhite-worm-558163.hostingersite.com/tradeoperation.php'),
      body: injs
  
    );
    
    if(response.statusCode == 200){

        
           if(mounted){

         ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trade accepted check your acquired products')),
      );

    }
    }

    else if(response.statusCode == 201){

           if(mounted){

         ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rejected')),
      );

      }

    }
    else{

          if(mounted){
         ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to accept the trade')),
      );

      }

    }


}

//trade reject and accept end



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCEDC2),
         appBar: AppBar(
        backgroundColor: const Color(0xFFFCEDC2),
        title: const Text("Trades",style:TextStyle(fontWeight: FontWeight.bold)),
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
            onRefresh: callgettrade,
            child: CustomScrollView(
              slivers: [
                 const SliverAppBar(
                  automaticallyImplyLeading: false,
                     backgroundColor:  const Color(0xFFFCEDC2),
                  floating: true,
                  snap: true,
                  centerTitle: false,
                  title: Text("Your trade requests", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF435964)),)

                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 2.4,
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


                                    showDialog(context: context, builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Cancel Request"),
                                  content: const Text("Are you sure you want to cancel this trade?"),
                                  actions: [
                                    TextButton(onPressed: (){

                                      _canceltrade(listProducts[index]['tradeid']).then(
                                      (value) => Navigator.of(context).pop()).then(
                                      (value) => _gettradessent());




                                    }, child: const Text("Yes"))
                                    ,TextButton(onPressed: (){
                                     Navigator.of(context).pop();

                                    }, child: const Text("No"))
                                  ]

                                );

                               });




                              },

                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0), // Adjust the value to change the curvature
                                    color: Color(0xFF435964),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Container(

                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0), // Adjust the value to change the curvature
                                        color: Color(0xFFBEE2EF),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Stack(
                                          children: [
                                            Column(
                                              children: [
                                                Row(

                                                  children: [
                                                    Column(
                                                      children: [
                                                        Container(
                                                          color: Color(0xFF435964),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(1.0),
                                                            child: CachedNetworkImage(
                                                                imageUrl: listProducts[index]['senderpimg'],
                                                                width: 100,
                                                                height: 100,
                                                                placeholder: (context, url) => const CircularProgressIndicator(),
                                                                fit: BoxFit.cover,
                                                               errorWidget: (context, url, error) => const Icon(Icons.error),),
                                                          ),
                                                        ),

                                                            Text(
                                                              limitwords(listProducts[index]['senderpname']),
                                                              style: const TextStyle(color: Color(0xFF435964), fontWeight: FontWeight.w500, fontSize: 15,
                                                              ),
                                                            ),
                                                      ],
                                                    ),


                                                    Container(
                                                      width: 120,
                                                      child: Column(
                                                        children: [
                                                          const Icon(Icons.swap_horiz_sharp,size: 60, color: Color(0xFF435964),),
                                                          Text("Trading with ", style: const TextStyle(color:Color(0xFF435964), fontWeight: FontWeight.w500, fontSize: 13)),
                                                          Text("${listProducts[index]['receiveruser']}", style: const TextStyle(color:Color(0xFF435964), fontWeight: FontWeight.bold, fontSize: 15),),
                                                        ],
                                                      ),
                                                    ),

                                                     Column(
                                                       children: [
                                                         Container(
                                                           color: Color(0xFF435964),
                                                           child: Padding(
                                                             padding: const EdgeInsets.all(1.0),
                                                             child: CachedNetworkImage(
                                                                  imageUrl: listProducts[index]['receiverpimg'],
                                                                  width: 100,
                                                                  height: 100,
                                                                 fit: BoxFit.cover,
                                                                  placeholder: (context, url) => const CircularProgressIndicator(),
                                                                 errorWidget: (context, url, error) => const Icon(Icons.error),),
                                                           ),
                                                         ),

                                                             Text(
                                                               limitwords(listProducts[index]['receiverpname']),
                                                               style: const TextStyle(color: Color(0xFF435964), fontWeight: FontWeight.w500, fontSize: 15,
                                                               ),
                                                             ),
                                                       ],
                                                     ),




                                                  ],

                                                ),



                                              ],
                                            ),


                                                                     ],
                                        ),
                                      ),

                                    ),
                                  ),
                                ),

                            );

                      },

                    ),
                  ),
                ),
                 const SliverAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor:  const Color(0xFFFCEDC2),
                  floating: true,
                  snap: true,
                  centerTitle: false,
                  title: Text("Incoming trades from people", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF73633C)))

                ),
                 SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 2.4,
                      crossAxisCount: 1,
                      crossAxisSpacing: 20.0,
                      mainAxisSpacing: 20.0,
                    ),
                    delegate: SliverChildBuilderDelegate(
                        childCount: listProducts2.length,
                          (BuildContext context, int index) {

                            return InkWell(
                              splashColor: const Color.fromARGB(255, 248, 3, 3),

                              onTap: (){


                                    showDialog(context: context, builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Operation"),
                                  content: const Text("Accept or reject the trade"),
                                  actions: [
                                    TextButton(onPressed: (){

                                      _rejactrade(listProducts2[index]['tradeid'],1).then(
                                      (value) => Navigator.of(context).pop()).then(
                                      (value) => _gettradesrece());




                                    }, child: const Text("Accept"))
                                    ,TextButton(onPressed: (){
                                      _rejactrade(listProducts2[index]['tradeid'],2).then(
                                      (value) => Navigator.of(context).pop()).then(
                                      (value) => _gettradesrece());


                                    }, child: const Text("Reject")),
                                    TextButton(onPressed: (){
                                        Navigator.of(context).pop();

                                    }, child: const Text("Exit"))
                                  ]

                                );

                               });



                              },

                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0), // Adjust the value to change the curvature
                                    color: Color(0xFF73633C),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0), // Adjust the value to change the curvature
                                        color: Color(0xFFF6F1E9),
                                      ),
                                    height: 10,
                                    width: 5,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Stack(
                                          children: [
                                            Column(
                                              children: [
                                                Row(

                                                  children: [

                                                     Column(
                                                       children: [
                                                         Container(
                                                           color: Color(0xFF73633C),
                                                           child: Padding(
                                                             padding: const EdgeInsets.all(1.0),
                                                             child: CachedNetworkImage(
                                                                imageUrl: listProducts2[index]['receiverpimg'],
                                                                width: 100,
                                                                height: 100,
                                                                placeholder: (context, url) => const CircularProgressIndicator(),
                                                               errorWidget: (context, url, error) => const Icon(Icons.error),),
                                                           ),
                                                         ),

                                                             Text(
                                                               limitwords(listProducts2[index]['receiverpname']),
                                                               style: const TextStyle(color: Color(0xFF73633C), fontWeight: FontWeight.w500, fontSize: 15,
                                                               ),
                                                             ),
                                                       ],
                                                     ),
                                                       Container(
                                                         width: 120,
                                                         child: Column(
                                                           children: [
                                                             const Icon(Icons.swap_horiz_sharp,size: 60, color: Color(0xFF73633C),),
                                                             Text("Accept", style: const TextStyle(color:Color(0xFF73633C), fontWeight: FontWeight.w500, fontSize: 13),),
                                                             Text("${listProducts2[index]['senderuser']}", style: const TextStyle(color:Color(0xFF73633C), fontWeight: FontWeight.bold, fontSize: 15),),
                                                             Text("Trade?", style: const TextStyle(color:Color(0xFF73633C), fontWeight: FontWeight.w500, fontSize: 13),),
                                                           ],
                                                         ),
                                                       ),

                                                    Column(
                                                      children: [
                                                        Container(
                                                          color: Color(0xFF73633C),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(1.0),
                                                            child: CachedNetworkImage(
                                                                  imageUrl: listProducts2[index]['senderpimg'],
                                                                  width: 100,
                                                                  height: 100,
                                                                  placeholder: (context, url) => const CircularProgressIndicator(),
                                                                  fit: BoxFit.fill,
                                                                  errorWidget: (context, url, error) => const Icon(Icons.error),),
                                                          ),
                                                        ),

                                                            Text(
                                                              limitwords(listProducts2[index]['senderpname']),
                                                              style: const TextStyle(color: Color(0xFF73633C), fontWeight: FontWeight.w500, fontSize: 15,
                                                              ),
                                                            ),

                                                      ],
                                                    ),


                                                  ],

                                                ),


                                              ],
                                            ),


                                                                     ],
                                        ),
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
   
      
  
      
    );
  }


//widget








}