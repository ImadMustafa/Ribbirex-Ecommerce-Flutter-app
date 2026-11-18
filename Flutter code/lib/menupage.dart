
import 'dart:async';
import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'acquiredproduct.dart';
import 'addproduct.dart';
import 'chatcontactpage.dart';
import 'emailverpage.dart';
import 'homepage.dart';
import 'loginpage.dart';
import 'mycart.dart';
import 'myproductpage.dart';
import 'mytradespage.dart';
import 'profile.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class Menupage extends StatefulWidget {
  const Menupage({ super.key });


  @override
  _MenupageState createState() => _MenupageState();
}



class _MenupageState extends State<Menupage> {

//Variables
String version = "";
 late List info;
  late String orguser;
  late String orgpass;
  late String orgemail;
  late String orgimg = "";
  late String orgid;
  late String orgverif;

  Timer? _checkint;
  bool _noint = false;
  late String balance = "";

  final _pagecont = PageController();



//we get the user info and put them in the form start
  @override
  void initState() {
    super.initState();
    _checkinternet();
    aftv();
    savepass().then((value) {
      setState(() {
        info = value ?? []; 
       

        //we save the orginal info
        orguser = info.isNotEmpty ? info[0] : '';
        orgimg = info.isNotEmpty ? info[3] : '';
        orgemail = info.isNotEmpty ? info[1] : '';
        orgpass = info.isNotEmpty ? info[2] : '';
        orgid = info.isNotEmpty ? info[4] : '';
        orgverif = info.isNotEmpty ? info[5] : '';

        _verifyuser(orgverif,orgid);
         _checkbalance();
        
      

      });
    });

  }



//method to check internet start
Future <void> _checkinternet() async {
  _checkint = Timer.periodic(const Duration(seconds: 1), (timer) async {
    //check if internet
      bool inter = await InternetConnection().hasInternetAccess;
    
      setState(() {
        _noint = inter;
      });
 
  }
      );
}
//method to check internet end



//method to check the balance start
Future <void> _checkbalance() async{

  final uid = orgid;

     //we map the data
      final useinfo = {
        'uid':uid
        };

      
      //we convert the data into a json
      final injs = jsonEncode(useinfo);
   
    

      //we send the json to our php to check the username and password
      final response = await http.post(
      Uri.parse('https://navajowhite-worm-558163.hostingersite.com/getbalance.php'),
      body: injs,
    );
    //if username and password match
    if (response.statusCode == 200) {
      final info = jsonDecode(response.body);
      final balncx = info['balance'] as String;
      setState(() {
        balance = balncx;
      });

    }
    else{
      setState(() {
        balance = "Faild to load";
      });
    }

}
//method to check balance end





    //method to check if the user email verified start
    Future<void> _verifyuser(verif,uid) async {

      final userinfox = {
        'email': orgemail,
        'password': orgpass,
        'returnSecureToken': true,
      };
      
      //we convert the data into a json
      final injs = jsonEncode(userinfox);

      //we sign in first to get the user token
      final responsefire = await http.post(
      Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyA417a5xKZjx_k2y75GjwFto_WQ41pFpV0'),
      body: injs
    );
    
    if(responsefire.statusCode == 200){
       final userdata = jsonDecode(responsefire.body);
      //we get the user token
      final userid = userdata['idToken'];
     
      
  
        //we send request to get if the user if verified or not
      final responsefirever = await http.post(
      Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=AIzaSyA417a5xKZjx_k2y75GjwFto_WQ41pFpV0'),
      body: json.encode({
        'idToken': userid
      }),
      );
      
    
       if(responsefirever.statusCode == 200){
       
      final userexdata = jsonDecode(responsefirever.body);
      final userinfxx = userexdata['users'];
      final userdatxx = userinfxx[0];
      final isverif = userdatxx['emailVerified'];
      final bool isverifdb = (verif == '1');
      
  
      if(isverif){
      if(isverif != isverifdb){


        final useinfo = {
        'uid':uid
        };
    
      //we convert the data into a json
      final injsx8 = jsonEncode(useinfo);
  
      //we send the json to our php to make the update
      final responsexver = await http.post(
      Uri.parse('https://navajowhite-worm-558163.hostingersite.com/emverif.php'),
      body: injsx8,
    );   
    if(responsexver.statusCode == 200){
 
      //we update the preference to set that user got verified
      SharedPreferences useinf = await SharedPreferences.getInstance();
    
      List<String> updatedlistx = [orguser, orgemail, orgpass, orgimg,uid,"1"].whereType<String>().toList();
      await useinf.setStringList('usersav', updatedlistx);

      if(mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email verified!')),
      );
      }
    }

      }
   
      }
      else if(!isverif){
          // go to verify page
        if(mounted){
          _checkint?.cancel();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) =>  Emailverpage(idtoken: userid, email: orgemail,)),
          (route) => false
        );
        }

      }
      }
      
    }
  
    }
    //method to check the user verified end
 


//method to get user info start
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

  void aftv() async {
    String? av = await getv();
    setState(() {
    version = av!;
  });
    }
//method to get user info end




//logut method start
void _logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('infsav', false);
}
//logout method end

//method to change the content when the icon tapp start
  int _tabindx = 0;
    final List<Widget> _tabs = const[
    HomePage(),
    Addproductpage(),
    ChatContactPage(),


  ];

  //change page start
  void _changepage(int index) {
    _pagecont.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    setState(() {
      _tabindx = index;
    });
  }
//change page end




/////////////////////
////////////////////
//widget start
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      backgroundColor: const Color(0xFFFCEDC2),
      appBar: AppBar(
        title:_noint? Image.asset('assets/images/ribbinamelog.png', width: 120,):
         Row(
          children: [
            const Text("Connecting",style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                    ),),
                    AnimatedTextKit(animatedTexts:[
                        //first
                       TyperAnimatedText(
                        '...',
                        textStyle: const TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                        ),
                        speed: const Duration(milliseconds: 200),
                      ),
                      //second
                      TyperAnimatedText(
                        '..',
                        textStyle: const TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                        ),
                        speed: const Duration(milliseconds: 200),
                      ),
                      //third
                      TyperAnimatedText(
                        '.',
                        textStyle: const TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                        ),
                        speed: const Duration(milliseconds: 200),
                      ),
                    ],
                    isRepeatingAnimation: true,
                    repeatForever: true,
                    totalRepeatCount: 1,
                    pause: const Duration(milliseconds: 500),
                    ),
                   
                      
                  ],
                ),
        
        
        backgroundColor: const Color(0xFFFCEDC2),
        actions: [
           
          Text("Balance: \$$balance"),
                  
          IconButton(
            tooltip: "Cart",
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {

            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  Mycart(uid: orgid,)));

            },
          ),
        ],
      ),

      drawer: Drawer(
      backgroundColor: const Color(0xFFFCEDC2),
      child: ListView(
      padding: const EdgeInsets.all(0.0),
    children: [
      SizedBox(
        height: 200,
        width: 10,
        child: Container(
            alignment: Alignment.topLeft,
            color: const Color(0xFFD7B99A),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                children: [
                  const SizedBox(height: 140,),
                  Row(
                    children: [
                      ClipOval(
                        child:
                        CachedNetworkImage(
                          imageUrl:orgimg,
                          width: 50,
                          height: 50,
                          placeholder: (context, url) => const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => const Icon(Icons.error),),
                      ),
                      SizedBox(width: 15,),
                      Text("@$orguser", style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, fontWeight: FontWeight.w500),),
                    ],
                  ),
                ],
              ),
            )

        ),
     ),
     
    //first list element
    ListTile(
    leading: const Icon(
      Icons.person_2_outlined
    ),
    title: const Text("Profile",style:TextStyle(fontWeight: FontWeight.bold)),
    onTap: () {
    _checkint?.cancel();
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const Profile()));
    }
    ),

    //second element
    ListTile(
    leading: const Icon(
      Icons.shop_2_outlined
    ),
    title: const Text("My Products",style:TextStyle(fontWeight: FontWeight.bold)),
    onTap: () {
    _checkint?.cancel();
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>  Myproductpage(uid: orgid,)));
    }
    ),

      //second element
    ListTile(
    leading: const Icon(
      Icons.track_changes
    ),
    title: const Text("Acquired Products",style:TextStyle(fontWeight: FontWeight.bold)),
    onTap: () {
    _checkint?.cancel();
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>  Acquiredproduct(uid: orgid,)));
    }
    ),


        //second element
    ListTile(
    leading: const Icon(
      Icons.swap_horizontal_circle_sharp
    ),
    title: const Text("Trades",style:TextStyle(fontWeight: FontWeight.bold)),
    onTap: () {
    _checkint?.cancel();
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>  Mytradespage(uid: orgid,)));
    }
    ),


    

    //second element
    ListTile(
    hoverColor: const Color.fromARGB(26, 102, 92, 92),
    leading: const Icon(
    Icons.logout_outlined
    ),
    title: const Text("Logout",style:TextStyle(fontWeight: FontWeight.bold)),
    onTap: () {
    _checkint?.cancel();
    _logout();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Loginpage()),
          (route) => false
        );
    }
    ),
    ListTile(
      title: Text("App version $version",style: const TextStyle(fontSize: 14),),
    )
    
     
    ]
    )
    ),

     bottomNavigationBar: BottomNavigationBar(
      backgroundColor: const Color(0xFFF5DC98),
       currentIndex: _tabindx,
       onTap: _changepage,
       selectedItemColor: const Color(0xFF49AFD2),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            ), 
           
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: 'Post',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
          
        ],
        ),
        

      body: PageView(
        controller: _pagecont,
        physics: const PageScrollPhysics(
        parent: BouncingScrollPhysics(),
        ),
        children: _tabs,
        onPageChanged: (index) {
        setState(() {
      _tabindx = index;
    });
  }
  ) 


  );
      
    
  }
}