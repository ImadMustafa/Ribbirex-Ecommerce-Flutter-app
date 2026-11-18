import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'chatpage.dart';

class ChatContactPage extends StatefulWidget {
  const ChatContactPage({super.key});

  @override
  State<ChatContactPage> createState() => _ChatContactPageState();
}

class _ChatContactPageState extends State<ChatContactPage> {
  late List info;
  late String userid = "";
  List<String> receivername = [];
  List<String> receiverid = [];
  List<String> receiverPimg = [];
  List<String> sendername = [];
  List<String> senderid = [];
  List<String> senderPimg = [];

  late String cusername;


  @override
  void initState() {
    super.initState();
    savepass().then((value) {
      setState(() {
        info = value ?? [];
        userid = info.isNotEmpty ? info[4] : '';
        getContacts();
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

  Future<void> getContacts() async {
 
      http.Response response = await http.post(
        Uri.parse('https://navajowhite-worm-558163.hostingersite.com/getcontacts.php'),
        headers: <String, String>{
        },
        body: jsonEncode({
          'uidA': int.parse(userid),
        }),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          receivername.clear();
          receiverPimg.clear();
          receiverid.clear();
          receivername.addAll(data.map((contact) => contact['receiver_username'].toString()));
          receiverid.addAll(data.map((contact) => contact['receiverid'].toString()));
          receiverPimg.addAll(data.map((contact) => contact['receiver_pimg'].toString()));
          sendername.clear();
          senderPimg.clear();
          senderid.clear();
          sendername.addAll(data.map((contact) => contact['sender_username'].toString()));
          senderid.addAll(data.map((contact) => contact['senderid'].toString()));
          senderPimg.addAll(data.map((contact) => contact['sender_pimg'].toString()));

        });
      } 
      else {
        



      }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDF6DE),
      appBar: AppBar(

        title: Text('Contacts', style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Color(0xFFFCEDC2),
      ),
      body: ListView.builder(
        itemCount: receiverid.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black12,
                      width: 2.0,
                    ),
                  ),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    child: ClipOval(child: Image.network(senderid[index] == userid ? receiverPimg[index] : senderPimg[index])),

                  ),
                  title: Text(
                    senderid[index] == userid ? receivername[index] : sendername[index],
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  
                  onTap: () {
                    cusername = senderid[index] == userid ? receivername[index] : sendername[index];
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(sid: int.parse(senderid[index] == userid ? receiverid[index] : senderid[index],), username:cusername ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 11,),
            ],
          );
        },
      ),

    );
  }
}