import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'chatpage.dart';
import 'menupage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProductInfo extends StatefulWidget {
  final List product;

  const ProductInfo({required this.product, super.key });

  
  @override
  _ProductInfoState createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {

//Variables
 late List info;
late String userid = "";
bool buybtn = true;
bool confbtn = true;

  List listProducts = [];
  // ignore: unused_field
  bool _requestdone = true;

 @override
  void initState() {
    super.initState();
    savepass().then((value) {
      setState(() {
        info = value ?? [];
        //we save the orginal info
        userid = info.isNotEmpty ? info[4] : '';

        getmyproducts(4);

      });
    });
  }

   

  Future<List<String>?> getthepass() async {
    SharedPreferences useinf = await SharedPreferences.getInstance();
    return useinf.getStringList('usersav');
  }

  Future<List<String>?> savepass() async {
    List<String>? savedinfo = await getthepass();
    return savedinfo;
  }
  Future<String?> getv() async {
    SharedPreferences infos = await SharedPreferences.getInstance();
    return infos.getString('appv');
  }




//Buy methode start
 Future<void> _buypro(buyer,proid) async {

  final uid = buyer;
  final prid = proid;

   
      //we map the data
      final useinfo = {
        'uid':uid,'prod':prid
        };
      
      //we convert the data into a json
      final injs = jsonEncode(useinfo);

       //we send the json to our php to check the username and password
      final response = await http.post(
      Uri.parse('https://navajowhite-worm-558163.hostingersite.com/buyprod.php'),
      body: injs,
    );

    
    if (response.statusCode == 200) {
      
      
      if(mounted){
           ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Purchased')),
      );

      }


    }
    else if(response.statusCode == 400){
  
      if(mounted){
           ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You already have the product')),
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
    else if(response.statusCode == 404){

        if(mounted){
           ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cancel or Reject any trades that include this product')),
      );

      }

    }
   
    
    setState(() {
      buybtn = true;
    });

    
 }



Future<void> _addcartpro(userxc,proid) async {

  final uid = userxc;
  final prid = proid;

   
      //we map the data
      final useinfo = {
        'uid':uid,'prod':prid
        };

      
      //we convert the data into a json
      final injs = jsonEncode(useinfo);

       //we send the json to our php to check the username and password
      final response = await http.post(
      Uri.parse('https://navajowhite-worm-558163.hostingersite.com/addcart.php'),
      body: injs,
    );

    
    if (response.statusCode == 200) {

         if(mounted){
           ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Added to Cart')),
      );

      }

    }
    else if(response.statusCode == 401){

      if(mounted){
           ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You already own the product')),
      );

      }

    }
    else if(response.statusCode == 402){

      if(mounted){
           ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Already in the cart')),
      );

      }


    }

}


//we call this on refresh
 Future<void> callgetpro() async {
  getmyproducts(4);
 }

 //get product method
  Future<void> getmyproducts(value) async {
      setState(() {
        _requestdone = false;
      });

     
      final uid = userid;
      final pid = widget.product[0];
     //we map the data
      final useinfo = {
        'uid':uid,'key':value,'pid':pid
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


//
Future<void> _sendtrade(productsender,productreceiver) async{

final prosendid = productsender;
final proreid = productreceiver;
final useridx = userid;


   //we map the data
      final tradeinfo = {
        'uid':useridx,'prosend':prosendid,'prore':proreid
        };

      //we convert the data into a json
      final injs = jsonEncode(tradeinfo);

     //we get all the products info
      final response = await http.post(
      Uri.parse('https://navajowhite-worm-558163.hostingersite.com/sendtrade.php'),
      body: injs
  
    );
    
    if(response.statusCode == 200){

        if(mounted){

         ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trade sent.')),
      );

      }

    }
    else if(response.statusCode == 400){

      if(mounted){

         ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Already own the product.')),
      );

      }

    }

       else if(response.statusCode == 401){

      if(mounted){

         ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('The other side already have the product.'),),
      );

      }

    }

    else if(response.statusCode == 402){

      if(mounted){

         ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A Pending trade already exists between the two parties.'),),
      );

      }


    }
    else{

         if(mounted){

         ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send request.'),),
      );

      }


    }

    Navigator.of(context).pop();


}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCEDC2),
      
      appBar: AppBar(
        title: const Text('Product Page', style: TextStyle(fontWeight: FontWeight.bold),), backgroundColor: const Color(0xFFFCEDC2),
        leading: IconButton(onPressed: (){
          Navigator.pushAndRemoveUntil(
          context,
        MaterialPageRoute(builder: (context) => const Menupage()),
        (route) => false,
          );

        }, icon: const Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.2),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.network(
                        widget.product[5].toString()
                        ,width: 350,
                        height: 350,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          width: 210,
                          child: Text(widget.product[1].toString(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),
                          ),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
                          ),
                          onPressed: () {

                              _addcartpro(userid, widget.product[0]);

                          },
                          child: const Text("Add to Cart", style: TextStyle(color: Colors.white),),
                        ),

                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          width: 280,
                          child: Text(
                            widget.product[2].toString(),
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        IconButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
                            ),
                            onPressed: () {
                          
                          
                              // Navigate to the other page
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ChatPage(sid: int.parse(widget.product[7]), username: widget.product[2],)),
                              );

                            },
                            icon: const Icon(Icons.chat_outlined, color: Colors.white,))
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "\$${widget.product[4].toString()}",
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Description:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                  Text(
                      widget.product[3].toString()
                      ,style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(const Size(150, 40)),
                        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF3A5A5E)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                        ),
                      ),
                      onPressed: buybtn? () {
                        setState(() {
                          buybtn = false;
                        });

                showDialog(context: context,barrierDismissible: false,builder: (BuildContext context) {
               return AlertDialog(
                title: const Text("Confirmation"),
                content: const Text("Are you sure you want to buy the product?"),
                actions: [
                  TextButton(
                    child: const Text("Cancel"),
                    onPressed: () {
                      setState(() {
                      buybtn = true;
                      });
                      Navigator.of(context).pop();
                    },
                  ),

                    buydia()

                    ],
                    );
                  });

                      }:(){
                        null;
                      },
                      child: const Text("BUY", style: TextStyle(color: Colors.white),),
                    ),
                   widget.product[6] == '1' ? ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
                        minimumSize: MaterialStateProperty.all<Size>(const Size(150, 40)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0), // Adjust this value to change roundness
                          ),
                        ),
                      ),
                      onPressed: () {
                          
                    tradeform(context);
                    setState(() {
    
                          });
                
                                 
                      },
                      child: const Text("TRADE", style: TextStyle(color: Colors.white),),
                    ):Text(""),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

 
  //edit form widget
Widget buydia(){

  return StatefulBuilder(

    builder: (context, setState) {
      
    
    return Stack(
      children: [

                  
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 160, 154, 154),
                    ),
                    onPressed: confbtn ?() {
                      setState(() {
                        confbtn = false;     
                      });
                       _buypro(userid, widget.product[0]).then(
                        (value) => Navigator.of(context).pop()).then(
                        (value) => setState(() {
                          confbtn = true;
                        },));
                  }:() {
                  
                  },
                    child: const Text("Confirm",style: TextStyle(color: Colors.black),)
                  ),

      ],

    );

    }

  );
}


 //edit form widget
Widget tradeform(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
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
                    children: [
                      Text("Tap to trade", style: TextStyle(fontWeight: FontWeight.bold),),
                  
                   
                    ],

                  ),
                  
            
                ),
                 SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.6,
                      crossAxisCount: 3,
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
                                  title: const Text("Confirmation"),
                                  content: const Text("Are you sure you want to trade with this product?"),
                                  actions: [
                                    TextButton(onPressed: (){

                                      _sendtrade(listProducts[index]['pid'],widget.product[0]);
                                      Navigator.pop(context);
                                      
                                     

                                    }, child: const Text("Confirm"))
                                    ,TextButton(onPressed: (){
                                     Navigator.of(context).pop();

                                    }, child: const Text("Cancel"))
                                  ]

                                );
                                 
                               });
                              
          
                              },
                              
                                child: Container(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                height: 50,
                                width: 5,
                                  child: Stack(
                                    children: [
                                     Column(
                                        
                                        children: [
                                           CachedNetworkImage(
                                            imageUrl: listProducts[index]['pimgs'],                                  
                                            width: 60,
                                            height: 60,
                                            placeholder: (context, url) => const CircularProgressIndicator(),
                                           errorWidget: (context, url, error) => const Icon(Icons.error),),
                                          Text(listProducts[index]['pname'], style: const TextStyle(color:Color(0xFF435964), fontWeight: FontWeight.bold, fontSize: 18),),
                                          const SizedBox(height: 5,),
                                          Text('US\$ ${listProducts[index]['pprice']}', style: const TextStyle(color:Color(0xFF435964))),
                                          Text(listProducts[index]['trad'] == '1' ? "Tradeable" : "Not Tradeable"),
                                          
                                          
                                          
                                        ],
                                      ),
                                      
                                     
                               ],
                                  )
                
                                ),
                              
                            );
                           
                      },
                     
                    ),
                  ),
                ),
              ],
            ),
         
      );
    },
  );

  // Add a return statement at the end
  return Text("");
}



}







