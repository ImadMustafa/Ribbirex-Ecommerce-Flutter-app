import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'menupage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Acquiredproduct extends StatefulWidget {
  final String uid;
  const Acquiredproduct({required this.uid, super.key });

  @override
  _AcquiredproductState createState() => _AcquiredproductState();
}

class _AcquiredproductState extends State<Acquiredproduct> {

  
  List listProducts = [];
bool hoverover = false;
// ignore: unused_field
bool _requestdone = true;


String version = "";
  late List info;
  late String userid = "";

  bool tradable = false;
  List<String> categories = [];
  

  bool afimg = false;
  bool updimg = false;



  bool selcat = false;
  bool selimg = false;
  late String orgimg = "";
  late String zipname = "";
  bool editing = false;
  

@override
  void initState() {
    super.initState();
    
    getmyproducts(2);
    
  }





//we call this on refresh
 Future<void> callgetpro() async {
  getmyproducts(2);
 }

  //get product method
  Future<void> getmyproducts(value) async {
      setState(() {
        _requestdone = false;
      });

     
      final uid = widget.uid;  
      //we map the data
      final useinfo = {
        'uid':uid,'key':value
        };

      
      //we convert the data into a json
      final injs = jsonEncode(useinfo);

     //we get all the products info
      final response = await http.post(
      Uri.parse('https://navajowhite-worm-558163.hostingersite.com/myproductpage.php'),
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




///////////////////
///////////////////
////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCEDC2),
         appBar: AppBar(
        backgroundColor: const Color(0xFFFCEDC2),
        title: const Text("Acquired Product",style:TextStyle(fontWeight: FontWeight.bold)),
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
                      childAspectRatio: 0.5,
                      crossAxisCount: 3,
                      crossAxisSpacing: 14.0,
                      mainAxisSpacing: 14.0,
                    ),
                    delegate: SliverChildBuilderDelegate(
                        childCount: listProducts.length,
                          (BuildContext context, int index) {
                            
                            return InkWell(
                              splashColor: const Color.fromARGB(255, 248, 3, 3),
                              
                              onTap: (){
          
                              },
                              
                                child: Container(
                                  color: Color(0xFFC2D1D9),
                                  height: 60,
                                  width: 60,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Container(
                                    color: const Color(0xFFF2F5F7),
                                    height: 50,
                                    width: 5,
                                      child: Stack(
                                        children: [
                                          Column(

                                            children: [
                                               CachedNetworkImage(
                                                imageUrl: listProducts[index]['pimgs'],
                                                width: 140,
                                                height: 140,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) => const CircularProgressIndicator(),
                                               errorWidget: (context, url, error) => const Icon(Icons.error),),
                                              Container(height: 45 ,child: Text(listProducts[index]['pname'], style: const TextStyle(color:Color(0xFF435964), fontWeight: FontWeight.bold, fontSize: 15),)),
                                               Container(
                                                 width: 140,
                                                 height: 39,
                                                 color: Color(0xFFC2D1D9),
                                                 child: IconButton(onPressed: (){
                                                  final url = Uri.parse(listProducts[index]['pzip']);
                                                  launchUrl(url);
                                                                                           }, icon: const Icon(Icons.download)),
                                               )

                                            ],
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
   
      
    
      
    );
  
      
    
  }
}