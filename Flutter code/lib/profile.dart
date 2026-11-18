import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'loginpage.dart';
import 'menupage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';


class Profile extends StatefulWidget {
  const Profile({ super.key });

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
//variables
  final _formk1 = GlobalKey<FormState>();
  final _usernc = TextEditingController();
  final _emailc = TextEditingController();
  final _password = TextEditingController();
  bool showpass = true;
  late List info;
  late List newinf;
  bool peredit = false;
  bool untaken = false;
  bool etaken = false;
  late String orguser;
  late String orgemail;
  late String orgpass;
  late String uid;
  late String primg;
  late String orgveri;

  File? _image;
  bool afimg = false;
  bool updimg = false;
  bool nochang = false;
  bool firefaild = false;
  bool canedit = true;

  




  


  //logut method when we back from the profile edit if anything edited return to the login page
void _logout() async {

  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('infsav', false);
  if(mounted){
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => const Loginpage(),
    ),
  );
  }

}





//we get the user info and put them in the form start
  @override
  void initState() {
    super.initState();
    
    savepass().then((value) {
      setState(() {
        info = value ?? []; 
        //we set the form field info
        _usernc.text = info.isNotEmpty ? info[0] : '';
        _emailc.text = info.isNotEmpty ? info[1] : '';
        _password.text = info.isNotEmpty ? info[2] : '';

        //we save the orginal info
        orguser = info.isNotEmpty ? info[0] : '';
        orgemail = info.isNotEmpty ? info[1] : '';
        orgpass = info.isNotEmpty ? info[2] : '';
        primg = info.isNotEmpty ? info[3] : '';
        uid = info.isNotEmpty ? info[4] : '';
        orgveri = info.isNotEmpty ? info[5] : '';

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
//we get the user info and put them in the form end


//img select mehtod
Future<void>pickimgx() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      afimg = true;
      _image = File(pickedFile!.path);
      Future.delayed(const Duration(seconds: 5),upimg);
      
      
    });
  }

//send img to save it

  Future upimg() async {
    if (_image == null) return;

    var request = http.MultipartRequest('POST', Uri.parse('https://navajowhite-worm-558163.hostingersite.com/userpictureup.php'));
    request.files.add(await http.MultipartFile.fromPath('cover', _image!.path));
    request.fields['usid'] = uid;
    setState(() {
      updimg = true;
    });
    var response = await request.send();
    

   
    if (response.statusCode == 200) {
      
      var responsebod = await response.stream.bytesToString();

      final info = json.decode(responsebod);
      final pimg = info['pimg'] as String;
       SharedPreferences useinf = await SharedPreferences.getInstance();
      final inlist = useinf.getStringList('usersav');
      final usn = inlist?[0];
      final eun = inlist?[1];
      final pun = inlist?[2];
      final pin = pimg;

      List<String> updatedlist = [usn, eun, pun, pin,uid,orgveri].whereType<String>().toList();
      await useinf.setStringList('usersav', updatedlist);
      
      
      if(mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile picture updated.')),
      );
      }
    } 
    
    else {
      if(mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile picture.')),
      );
      }
    }
    setState(() {
      updimg = false;
    });
  }







 Future<void> _editpro() async {
    if (_formk1.currentState!.validate()) {
      // we get the username and password from the form
      final username = _usernc.text;
      final email = _emailc.text;
      final password = _password.text;
      
      //we save the old user and old pass to use them in the query
      final olduser = info.isNotEmpty ? info[0] : '';
      final oldemail = info.isNotEmpty ? info[1] : '';
      final oldpass = info.isNotEmpty ? info[2] : '';
     

        final userinfox = {
        'email': orgemail,
        'password': orgpass,
        'returnSecureToken': true,
      };
      
      //we convert the data into a json
      final injsxa = jsonEncode(userinfox);
    

      //we sign in first to get the user token
      final responsefire = await http.post(
      Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyA417a5xKZjx_k2y75GjwFto_WQ41pFpV0'),
      body: injsxa
    );
   
    
    if(responsefire.statusCode == 200){
      
       final userdata = jsonDecode(responsefire.body);
      //we get the user token
      final userid = userdata['idToken'];
      
      //if we changed the password
      if(password != oldpass){

        //we save the info for the update password request
        final userinfouppass = {
        'idToken': userid,
        'password': password,
        'returnSecureToken': true,
      };
      
      //we convert the data into a json
      final injsuppass = jsonEncode(userinfouppass);

      //we update the password in firebase
      final responseuppass = await http.post(
      Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:update?key=AIzaSyA417a5xKZjx_k2y75GjwFto_WQ41pFpV0'),
      body: injsuppass
    );

    peredit = true;
    if(responseuppass.statusCode != 200){
      firefaild = true;
    }
    else{
      setState(() {
        orgpass = password;
      });
    }

    }
      
      

      if(email != oldemail){

         
        //we save the data to update email
        final userinfoupemail = {
        'idToken': userid,
        'email': email,
        'returnSecureToken': true,
      };
      
      //we convert the data into a json
      final injsupemail = jsonEncode(userinfoupemail);


    //we update emal in firebase
    final responseupemail = await http.post(
      Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:update?key=AIzaSyA417a5xKZjx_k2y75GjwFto_WQ41pFpV0'),
      body: injsupemail
    );

    if(responseupemail.statusCode == 200){
    
      orgveri = "0";

       //we save the data to send verification email
        final userinfosendver = {
        'idToken': userid,
        'requestType': "VERIFY_EMAIL",
      };

      setState(() {
        orgemail = email;
      });
      //we convert the data into a json
      final injssendem = jsonEncode(userinfosendver);


    //we send  emal verification in firebase
    final responsesendemail = await http.post(
      Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=AIzaSyA417a5xKZjx_k2y75GjwFto_WQ41pFpV0'),
      body: injssendem
    );
    if(responsesendemail.statusCode == 200){

      if(mounted){
       showDialog(context: context, builder: (BuildContext context){
        return AlertDialog(
          title: const Text("Email Verification"),
           content:  Text("An email has been sent to $email for account verification. Please check your inbox or junk to activate your account."),
                actions: [
                  TextButton(
                    child: const Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                    ],
        );
        }
        );
      }
    }

    }
    else{
      firefaild = true;
    }
    
      }

    

      //if no data changed
      if(username == orguser && email == orgemail && password == orgpass){ 
        nochang = true;
      }
   
      if(!firefaild){
      //we map the data
      final useinfo = {
        'username':username,'email':email,'password':password,
        'olduser':olduser,'oldemail':oldemail,'oldpass':oldpass,'uid':uid
        };
      
      
      //we convert the data into a json
      final injs = jsonEncode(useinfo);

      
      //we send the json to our php to make the update
      final response = await http.post(
      Uri.parse('https://navajowhite-worm-558163.hostingersite.com/updateprofile.php'),
      body: injs,
    );
    
    //if username and password successfuly updated in database
    if (response.statusCode == 200) {

         
      SharedPreferences useinf = await SharedPreferences.getInstance();
      final inlistx = useinf.getStringList('usersav');
      final usimg = inlistx?[3];

      
      List<String> updatedlistx = [username, email, password, usimg,uid,orgveri].whereType<String>().toList();
      await useinf.setStringList('usersav', updatedlistx);
    
      //clear the form field
      newinf = [username,email,password];
      _usernc.clear();
      _emailc.clear();
      _password.clear();
      //set the new updated value to the form
      _usernc.text = newinf[0];
      _emailc.text = newinf[1];
      _password.text = newinf[2];
      
      if(mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved')),
      );
      if(peredit){
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login required for next launch.')),
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('infsav', false);
      }
      }

        setState(() {
          _usernc.text = newinf[0];
          _emailc.text = newinf[1];
          _password.text = newinf[2];
          //we save the new info to the info array so we can update correctly each time
          info = newinf;
        });

    

    } 
    //username exist in database
    else if(response.statusCode == 409){
      if(mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username already exist')),
      );
      }
      
    }

     else if(response.statusCode == 410){
      if(mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email already exist')),
      );
      }
    }
    else{

      if(mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile')),
      );
      }

    }
    
    }

    }
  
  }
  setState(() {
    canedit = true;
  });
 }


 Future<void> _checkform(value) async {
        
      
     
      
      // we get the username and password from the form
      final username = _usernc.text;
      final email = _emailc.text;
    
      //we save the old user and old pass to use them in the query
      final olduser = info.isNotEmpty ? info[0] : '';
      final oldemail = info.isNotEmpty ? info[1] : '';
   
       //we map the data
      final useinfo = {
        'username':username,
        'olduser':olduser,'email':email,'oldemail':oldemail,'key':value
        };

      //we convert the data into a json
      final injs = jsonEncode(useinfo);

  
      //we send the json to our php to make the update
      final response = await http.post(
      Uri.parse('https://navajowhite-worm-558163.hostingersite.com/checkeditform.php'),
      body: injs,
      
    );

  
    //username exist in database
     if(response.statusCode == 411){
     
      setState(() {
        untaken = true;
      });
     
    }

    //email exist in database
     if(response.statusCode == 412){
     
      setState(() {
        etaken = true;

      });

     
    }

     _formk1.currentState!.validate();
      
     
  }


Future<void> _deleteacc() async {

        final userinfox = {
        'email': orgemail,
        'password': orgpass,
        'returnSecureToken': true,
      };
      
      //we convert the data into a json
      final injsxa = jsonEncode(userinfox);

      //we sign in first to get the user token
      final responsefireget = await http.post(
      Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyA417a5xKZjx_k2y75GjwFto_WQ41pFpV0'),
      body: injsxa
    );
    
    if(responsefireget.statusCode == 200){
       final userdata = jsonDecode(responsefireget.body);
      //we get the user token
      final userid = userdata['idToken'];
    


  //we save the data to delete the account
        final userinfosendver = {
        'idToken': userid,
      };
   
      
      //we convert the data into a json
      final injsdel= jsonEncode(userinfosendver);


    //we send request to delete the account
    final responsesdele = await http.post(
      Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:delete?key=AIzaSyA417a5xKZjx_k2y75GjwFto_WQ41pFpV0'),
      body: injsdel
    );
    if(responsesdele.statusCode == 200){

    final useinfo = {
        'uid':uid
        };
    
      //we convert the data into a json
      final injs = jsonEncode(useinfo);

      //we send the json to our php to make the update
      final responsedeld = await http.post(
      Uri.parse('https://navajowhite-worm-558163.hostingersite.com/deleteacc.php'),
      body: injs,
    );
      if(responsedeld.statusCode == 200){

          if(mounted){
         Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Loginpage()),
        (route) => false,);
        }

           if(mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account successfully deleted.')),
      );
      }

      }
      else{

           if(mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete account.')),
      );
      }
      }
    }

    }
}


  @override
  Widget build(BuildContext context) {
     return PopScope(
      
       child: Scaffold(
        backgroundColor: const Color(0xFFFCEDC2),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFCEDC2),
          title: const Text("Profile",style:TextStyle(fontWeight: FontWeight.bold)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
                  
             Navigator.pushAndRemoveUntil(
            context,
          MaterialPageRoute(builder: (context) => const Menupage()),
          (route) => false,);
            
            }
          ),
          actions: [
        PopupMenuButton(
           itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 'delete',
          child: TextButton(onPressed: () { 
            showDialog(context: context, builder: (BuildContext context) {
                 return AlertDialog(
                  title: const Text("Confirmation"),
                  content: const Text("Are you sure you want to delete your account?"),
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
                      child: const Text("Delete",style: TextStyle(color: Colors.black),),
                      onPressed: () {
                        _deleteacc();
                       _logout();
                      },
                    ),
                      ],
                      );
                    });
            
                  },
                  child: const Text("Delete account"),),
                    ),
                  ],
                  icon: const Icon(Icons.more_vert),
                 ),
                 ],
                 ),
        
        
        body:Center(
          child: Container(
            width: 350,
            height: 720,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0), // Adjust the value to change the curvature
              color: Color(0x7BD7B99A),
            ),
            child: Stack(
              children:[Center(
                child:SingleChildScrollView(
                  child: Container(
                  alignment: Alignment.center,
                  width: 280,
                  child: Column(
                  children:[
                    const SizedBox(height: 30,),
                     Stack(
                    children: [
                      Stack(
                    children: [
                    ClipOval(
                    child: !afimg?CachedNetworkImage(
                    imageUrl:primg,
                     width: 150,
                      height: 150,
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(Icons.error),):_image != null ?
                      Image.file(_image!,width: 150,height: 150):const Text("Select image"),
                    ),
                    Positioned.fill(
                    child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                    height: 180,
                    width: 180,
                    child: updimg?const CircularProgressIndicator():null),
                        ),
                    )

                        ]
                      ),
                    Positioned(
                    top: -10,
                    right: -10,
                    child: IconButton(
                    tooltip: "Edit photo",
                    onPressed: () {
                    pickimgx();
                  },
                  icon: const Icon(Icons.edit),
                   ),
                   ),
                  ],
                        ),
                  const SizedBox(height: 30,),
                  const Text("Edit profile",style: TextStyle(fontSize:20,fontWeight: FontWeight.bold ),),
                  const SizedBox(height: 20,),
                   //create the sign up form
                  Form(
                    key: _formk1,
                    child: Column(
                      children: [
                        //username field
                        Container(
                            decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: TextFormField(
                            controller: _usernc,
                            decoration: const InputDecoration(
                            labelText: 'Username',
                            icon: Icon(Icons.person),
                            border: InputBorder.none,
                            ),

                            validator:(value) {
                              if (value!.isEmpty) {
                                return 'Please enter a username.';
                              }
                              const upattern = r'^[a-zA-Z0-9_]+$';
                              final regus = RegExp(upattern);
                              //we check if the date of brith entered match the pattern
                              if (!regus.hasMatch(value)) {
                              return 'Sorry, this username is invalid.';
                              }
                               if (value.length < 4 || value.length > 32) {
                              return 'Must be 4-32 characters.';
                            }

                            if (untaken) {
                              return 'This username is already taken.';
                            }
                              return null;
                            },
                            onChanged: (value) {
                            setState(() {
                                untaken = false;
                          });
                          _formk1.currentState!.validate();
                                       _checkform(1);
                              },

                          ),
                        ),
                        const SizedBox(height: 20,),
                        Container(
                            decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: TextFormField(
                            controller: _emailc,
                            decoration: const InputDecoration(
                            labelText: 'Email',
                            icon: Icon(Icons.alternate_email),
                            border: InputBorder.none
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter an email.';
                              }
                              //pattern for email
                              const pattern = (r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
                              final regExp = RegExp(pattern);
                              //we check if the date of brith entered match the pattern
                              if (!regExp.hasMatch(value)) {
                              return 'Sorry, this email is invalid.';
                              }
                              if (etaken) {
                              return 'This email is already exist.';
                            }

                              return null;
                            },
                            onChanged: (value) {
                            setState(() {
                                etaken = false;

                          });
                          _formk1.currentState!.validate();
                                       _checkform(2);

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
                            controller: _password,
                            decoration: InputDecoration(
                            labelText: 'Password',
                            icon:const Icon(Icons.password),
                            border: InputBorder.none,
                            suffixIcon:Padding(
                            padding: const EdgeInsetsDirectional.only(end: 12.0),
                            child: IconButton(onPressed: () {
                              setState(() {
                              showpass = !showpass;

                              });
                            },
                             icon: Icon(showpass?Icons.remove_red_eye_outlined:Icons.visibility_off_outlined),),),
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
                              _formk1.currentState!.validate();
                            },
                          ),
                        ),


                        const SizedBox(height: 20.0),

                        //when we press on the sign up button it call the signfo method

                        Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF49AFD2),
                              fixedSize: const Size(100, 35)
                            ),
                            onPressed: canedit? (){
                              setState(() {
                                canedit = false;
                              });
                              _editpro();

                            }:() {
                              null;
                            },
                            child: const Text("Save",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16,color: Colors.white70),),
                          ),
                        ),


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
          ),
        ),
           ),
     );
  }
     

  }


