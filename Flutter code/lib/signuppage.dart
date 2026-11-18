
import 'dart:async';
import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'loginpage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';



class Signuppage extends StatefulWidget {
  const Signuppage({ super.key });

  @override
  _SignuppageState createState() => _SignuppageState();
}


class _SignuppageState extends State<Signuppage> {
  //Variables
  final _formk1 = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _repassword = TextEditingController();
 
  final _emailke = GlobalKey<FormFieldState>();
  final _passke = GlobalKey<FormFieldState>();
  final _repasske = GlobalKey<FormFieldState>();

  bool showpass = true;
  bool etaken = false;
  bool pasis = false;

  bool _requestdone = true;
  bool _noint = false;

  Timer? _checkint;
  


//when the application start
  @override
  void initState() {
    super.initState();
    _checkinternet();

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







 //method to handle the sign up start
  Future<void> _signfo() async {
    if (_formk1.currentState!.validate()) {
      // we get the username and password from the form
      
      setState(() {
        _requestdone = false;
      });

      final password = _password.text;
      final email = _email.text; 
    
      
      //info to send them to the sever
      final userinfox = {
        'email': email,
        'password': password,
        'returnSecureToken': true,
      };

      //we convert the data into a json
      final infoxjs = jsonEncode(userinfox);
      
      //we send the json to sign up in our firebase
      final response = await http.post(
      Uri.parse('YOUR_BACKEND_SIGNUP_URL'),
      body: infoxjs
  
    );

    //if we sign up the user successfully
    if (response.statusCode == 200) {
      final userdata = jsonDecode(response.body);
      //we get the user token
      final userid = userdata['idToken'];

      
      //we map the data to save them in our database
      final useinfo = {
        'password':password,'email':email,
        };
         //we convert the data into a json
      final injs = jsonEncode(useinfo);
      

      //we save in our database
      final responsetdb = await http.post(
      Uri.parse('https://navajowhite-worm-558163.hostingersite.com/signuppage.php'),
      body: injs
  
    );
    //if data saved in our database successfully
    if(responsetdb.statusCode == 200){
      
      //we send the verification link
      final responsever = await http.post(
      Uri.parse('YOUR_BACKEND_SIGNUP_URL'),
      body: json.encode({
        'requestType': "VERIFY_EMAIL",
        'idToken': userid
      }),
      );

      if(responsever.statusCode == 200){
       
      //clear field   
      _password.clear();
      _repassword.clear();
      _email.clear();

      if(mounted){
      showDialog(context: context, builder: (BuildContext context){
        return AlertDialog(
          title: const Text("Email Verification"),
           content:  Text("An email has been sent to $email for account verification. Please check your inbox or junk to activate your account."),
                actions: [
                 
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 160, 154, 154),
                    ),
                    child: const Text("Continue to login",style: TextStyle(color: Colors.black),),
                    onPressed: () async{
                    _checkint?.cancel();
                    Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Loginpage()),
                    );
                    
                    },
                  ),
                    ],
        );
      
      });
      }
      }
    }

    else{

      //we save the data to delete the account
        final userinfosendver = {
        'idToken': userid,
      };
   
      
      //we convert the data into a json
      final injsdel= jsonEncode(userinfosendver);


    //we send request to delete the account
    final responsesdele = await http.post(
      Uri.parse('YOUR_BACKEND_SIGNUP_URL'),
      body: injsdel
    );
    if(responsesdele.statusCode == 200){
      if(mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign up failed.')),
      );
      }
    }
      
    }
      
    }
    //username exist in database
    else if(response.statusCode == 400){
      if(mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email already exist.')),
      );
      }
    }

  
  }
   setState(() {
          _requestdone = true;
        });
}
  //method to handle sign up end





////////////////////////////
///////////////////////////
//widget start
  @override
  Widget build(BuildContext context) {
    
     return Scaffold(
      backgroundColor: const Color(0xFFFCEDC2),
      
      //drawer: Drawer(
       // backgroundColor: Colors.grey,
      //),
      body: Stack(
        children:[ 
         
            Center(
            child:SingleChildScrollView(
            child: Container(
            alignment: Alignment.center,
            width: 250,
            child: Column(
            children:[

              Container(
                alignment: Alignment.topLeft,
                  child: const Text("Register",style: TextStyle(fontSize:35,fontWeight: FontWeight.bold ),)),
            Container(
                alignment: Alignment.topLeft,
                child: const Text("Create an account",style: TextStyle(fontSize:23),)),
              
            const SizedBox(height: 30,),
             //create the sign up form
            Form(
              key: _formk1,
              child: Column(
                children: [
                  
                  
            
                   //email field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0), // Adjust the value to change the curvature
                    ),
                    child: TextFormField(
                      controller: _email,
                      key:_emailke,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      labelText: 'Email',
                      border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter an email.';
                        }
                        //pattern for email
                        const pattern = (r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
                        final regExp = RegExp(pattern);
                        if (!regExp.hasMatch(value)) {
                        return 'Sorry, this email is invalid.';
                        }
                        return null;
                      },
                      onChanged: (value){
                        _emailke.currentState!.validate();
                      },
                    ),
                  ),
            
                    const SizedBox(height: 20,),
            
                   //password field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0), // Adjust the value to change the curvature
                    ),
                    child: TextFormField(
                      controller: _password,
                      key:_passke,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      labelText: 'Password',
                      border: InputBorder.none,
                      suffixIcon:Padding(
                      padding: const EdgeInsetsDirectional.only(end: 12.0),
                      child: IconButton(onPressed: () { 
                        setState(() {
                        showpass = !showpass;
                      
                        });
                    
                       },
                      icon:Icon(showpass?Icons.remove_red_eye_outlined:Icons.visibility_off_outlined),),
                      )
                      ),
                      obscureText: showpass,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a password.';
                        }
                         if (value.length < 8) {
                          return 'Must be at least 8 characters long.';
                      }
                   
                        return null;
                      },
                      onChanged: (value){
                        _passke.currentState!.validate();
                        if(_repassword.text != ""){
                        if(_password.text == _repassword.text){
        
                          setState(() {
                            pasis = true;
                            _repasske.currentState!.validate();
                          });
                        }
                        else{
                            setState(() {
                            pasis = false;
                             _repasske.currentState!.validate();
                          });
                        }
                        }
                         
        
                      },
                    ),
                  ),
            
                  const SizedBox(height: 20.0),
        
                    //repassword field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0), // Adjust the value to change the curvature
                    ),
                    child: TextFormField(
                      controller: _repassword,
                      key:_repasske,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      labelText: 'Confirm-Password',
                      border: InputBorder.none,
                      suffixIcon:Padding(
                      padding: const EdgeInsetsDirectional.only(end: 12.0),
                      child: Icon(
                      (pasis?Icons.check:Icons.close),color: pasis? Colors.green:Colors.red,),
                      
                      )
                      ),
                      obscureText: showpass,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please repeat password.';
                        }
                         if (value.length < 8) {
                          return 'Must be at least 8 characters long.';
                      }
                      if(!pasis){
                        return 'Password dont match';
                      }
                        return null;
                      },
                      onChanged: (value){
                    
                        if(_repassword.text == _password.text){
                          setState(() {
                            pasis = true;
                            _repasske.currentState!.validate();
                          });
                        }
                        else{
                            setState(() {
                            pasis = false;
                            _repasske.currentState!.validate();
                          });
                        }
                     
                      },
                    ),
                  ),
        
                  const SizedBox(height: 20.0),
            
                  //when we press on the sign up button it call the signfo method
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF49AFD2),
                      fixedSize: const Size(160, 30)
                    ),
                    onPressed: _signfo,
                    child: _requestdone? const Text(
                      'Register',style: TextStyle( fontWeight: FontWeight.w600,fontSize: 16,color: Colors.white70),
                      ):const SizedBox(width: 23,height: 23,
                      child: CircularProgressIndicator(),
                      ),
                  ),
                  const SizedBox(height: 30,),
                  const Text("Already have an account?"),
                  InkWell(
                  onTap: () {  
                  _checkint?.cancel();
                  Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context)=>const Loginpage()),
                   
                  );
                  
                },
                child: const Text("Login",style: TextStyle(color: Colors.blue,fontSize: 18,fontWeight: FontWeight.bold),),
            
                  )
                ],
              ),
            ),
            ],
            ),
                  ),
          ),
        
        ),
         
       
         
        ]
      ),
    );
  }
}
