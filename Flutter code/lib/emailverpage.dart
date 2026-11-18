
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'menupage.dart';
import 'package:http/http.dart' as http;

class Emailverpage extends StatefulWidget {
  final String idtoken;
  final String email;

  const Emailverpage({required this.idtoken,required this.email, super.key});

  @override
  _EmailverpageState createState() => _EmailverpageState();
}





class _EmailverpageState extends State<Emailverpage> {

@override
  void initState() {
    super.initState();
    _checkperver();
  }
bool disasend = true;
int countime = 60;
Timer? _timer;
Timer? _checkveri;


Future <void> _checkperver() async {
  _checkveri = Timer.periodic(const Duration(seconds: 2), (timer) async {
        //we send request to get if the user if verified or not
      final responsefirever = await http.post(
      Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=AIzaSyA417a5xKZjx_k2y75GjwFto_WQ41pFpV0'),
      body: json.encode({
        'idToken': widget.idtoken
      }),
      );
      
    
       if(responsefirever.statusCode == 200){
       
      final userexdata = jsonDecode(responsefirever.body);
      final userinfxx = userexdata['users'];
      final userdatxx = userinfxx[0];
      final isverif = userdatxx['emailVerified'];

      if(isverif){
        _checkveri?.cancel();
        _timer?.cancel();
        if(mounted){
         Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) =>  const Menupage()),
          (route) => false
        );
        }
        
      }
       }



   });

}

//send verification method
  Future<void> _sendveri(token,emailx) async {

     
      //we send the verification link
      final responsever = await http.post(
      Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=AIzaSyA417a5xKZjx_k2y75GjwFto_WQ41pFpV0'),
      body: json.encode({
        'requestType': "VERIFY_EMAIL",
        'idToken': token
      }),
      );

      if(responsever.statusCode == 200){

          if(mounted){
        showDialog(context: context, builder: (BuildContext context){
        return AlertDialog(
          title: const Text("Email Verification"),
           content:  Text("An email has been sent to $emailx for account verification. Please check your inbox or junk to activate your account."),
                actions: [
                  TextButton(
                    child: const Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                 
                    ],

        );
        }
        );
          }
      
     }

     setState(() {
       disasend = false;
     });
  

     _timer = Timer.periodic(const Duration(seconds: 1), (timer) { 
      setState(() {
        if(countime > 0){
        countime--;
        }
        else{
          disasend = true;
        }
      });
      

    });
  
  }
  

//////////////////
//////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text("Account Verification"),

      ),
      body: Center(child: 
      
      Container(
        color: Colors.white,
        width: 300,
        height:200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Account Verification",style: TextStyle(fontWeight: FontWeight.bold),),
            const SizedBox(height: 20,),
            ElevatedButton(onPressed: (){disasend? _sendveri(widget.idtoken, widget.email):null;
        
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: disasend?Colors.blue:Colors.grey

            ),
            
            child: const Text("Verify",style: TextStyle(color: Colors.white),),
      
            ),
            Text(!disasend?"Resend After" " $countime sec":""),
            const Text("You will be redirected once u got verified"),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 InkWell(
                onTap: () {   
                  _timer?.cancel();
                  Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) => const Menupage()),
                  (route) => false
               
                  );
                
              },
              child: const Text("Verified?",style: TextStyle(decoration: TextDecoration.underline,color: Colors.blue,fontSize: 18,fontWeight: FontWeight.bold),),
          
                )

              ],

            ),
            
            
          ]
        ),
      )
       
    )
      
    );
  }
}