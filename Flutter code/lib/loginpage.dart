import 'dart:async';
import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'menupage.dart';
import 'signuppage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:http/http.dart' as http;


class Loginpage extends StatefulWidget {
  const Loginpage({ super.key });

  @override
  _LoginpageState createState() => _LoginpageState();
}


class _LoginpageState extends State<Loginpage> {
  //variables
  final _logform = GlobalKey<FormState>();
  final _logusern = TextEditingController();
  final _logpass = TextEditingController();
  final _uske = GlobalKey<FormFieldState>();
  final _passke = GlobalKey<FormFieldState>();

  bool showpass = true;
  bool invcred = false;
  bool edus = false;
  bool _noint = false;
  bool _requestdone = true;

  Timer? _checkint;
  
  


//when the application start
  @override
  void initState() {
    super.initState();
    _checkinternet();
    checkLoginStatus();
    
  }

  
  //check if user loged in start
  Future<bool> ceklog() async {
    SharedPreferences infos = await SharedPreferences.getInstance();
    return infos.getBool('infsav') ?? false;
  }

  void checkLoginStatus() async {
    bool saved = await ceklog();
    if (saved) {
      _checkint?.cancel();
      if(mounted){
          Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Menupage()),
          (route) => false
        );
      }
    }
  }
//check user if loged in end



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






//login methode start
 Future<void> _loginfo() async {

    edus = true;
    if (_logform.currentState!.validate()) {
      setState(() {
        _requestdone = false;
      });
      
      // we get the username and password from the form
      final email = _logusern.text;
      final password = _logpass.text;
      
      //we map the data
      final useinfo = {
        'username':email,'password':password
        };

      
      //we convert the data into a json
      final injs = jsonEncode(useinfo);
   
    

      //we send the json to our php to check the username and password
      final response = await http.post(
      Uri.parse('https://navajowhite-worm-558163.hostingersite.com/loginpage.php'),
      body: injs,
    );
    //if username and password match
    if (response.statusCode == 200) {
      
      //clear the form field
      final info = jsonDecode(response.body);
      final username = info['username'] as String;
      final email = info['email'] as String;
      final password = info['password'] as String;
      final pimg = info['pimg'] as String;
      final uid = info['uid'] as String;
      final uveri = info['uverf'] as String;
      final userinfo = [username,email,password,pimg,uid,uveri];


  
      _logusern.clear();
      _logpass.clear();
      if(mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged in')),
      );
      }
      
      if(uveri == "1"){
      // Save user login preference
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('infsav', true);
      }
      //save user info
      SharedPreferences passpref = await SharedPreferences.getInstance();
      await passpref.setStringList('usersav',userinfo);


      //get appversion
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final version = packageInfo.version;

      //save version
      SharedPreferences pref2 = await SharedPreferences.getInstance();
      await pref2.setString('appv',version);

        _checkint?.cancel();
        // go to main page page
        Timer(const Duration(seconds: 1), () {
        // go to login page
          Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Menupage()),
          (route) => false
        );
      });


    }
    
    //username and password dont match
    else if(response.statusCode == 400){
      if(mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid credential.')),
      );
      }
      setState(() {
       invcred = true;

      });
      _logform.currentState!.validate();
    }
    
    setState(() {
        _requestdone = true;
      });

    
    
    }
  }
//login method end



///////////////
//////////////
//Widget start
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCEDC2),


      body: 
      Stack(
        children:[ Center(
          child:Center(
            child: SingleChildScrollView(
              child: Container(
              alignment: Alignment.topCenter,
              width: 250,
              child: Column(
              children:[
                
              Image.asset('assets/images/Ribbirexstl.png',scale: 5,),
              const SizedBox(height: 30,),
               //create the login form
              Form(
                key: _logform,
                child: Column(
                  children: [
                    //username field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        
                      ),
                      child: TextFormField(
                        controller: _logusern,
                        key: _uske,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                        labelText: 'Email',
                        border: InputBorder.none     
                        ),
              
                        validator: (value) {
                          
                          if (value!.isEmpty) {
                            return 'Please enter a username or email.';
                          }
                          
                          if(invcred){
                            return 'Invalid credential.';
                          }
                          return null;
                          
                        },
                        
                        onChanged: (value){
                           setState(() {
                            invcred = false;
                      });
                         if(edus){
                            _logform.currentState!.validate();
                          } 
                      
                         edus = false;
                        _uske.currentState!.validate();
                                
                        },
                      
                      ),
                    ),
                    const SizedBox(height: 20,),
                    
                    //password field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextFormField(
                        controller: _logpass,
                        key: _passke,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                        border: InputBorder.none,
                        labelText: 'Password',
                        suffixIcon:Padding(
                        padding: const EdgeInsetsDirectional.only(end: 12.0),
                        child: IconButton(onPressed: () { 
                          setState(() {
                          showpass = !showpass;
                        
                          });
                         },
                         icon:Icon(showpass?Icons.remove_red_eye_outlined:Icons.visibility_off_outlined),
                         ),
                         ),
                         ),
                        
                        obscureText: showpass,
                        validator: (value) {
                         
                          if (value!.isEmpty) {
                            return 'Please enter a password.';
                          }
                          
                          if(invcred){
                            return 'Invalid credential.';
                          }
                          
                          return null;
                          
                        },
                        onChanged: (value){
                           setState(() {
                            invcred = false;
                      });
                        if(edus){
                            _logform.currentState!.validate();
                          } 
                         edus = false;
                         _passke.currentState!.validate();
                      
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
              
                    //when we press on the sign up button it call the signfo method
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF49AFD2),
                        fixedSize: const Size(100, 35)
                      ),
                      onPressed: _loginfo,
                      child: _requestdone?const Text(
                        'Log In',style:TextStyle(fontWeight: FontWeight.w600,fontSize: 16,color: Colors.white70)
                        ):const SizedBox(width: 23,height: 23,
                      child: CircularProgressIndicator(),
                      ),
                    ),
                    const SizedBox(height: 30,),
                    const Text("Need an account?"),
                    InkWell(
                    onTap: () { 
                     _checkint?.cancel();
                    Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Signuppage()),);
                  },
                  child: const Text("Register",style: TextStyle(color: Colors.blue,fontSize: 18,fontWeight:FontWeight.bold ),),
              
                    )
                  ],
                ),
              ),
              ],
              ),
                    ),
            ),
          ),
        ),
        
        ]
      ),
        

      
    );
  }
}