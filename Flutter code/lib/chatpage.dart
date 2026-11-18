import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {
  final int sid;
  final String username;
  const ChatPage({super.key, required this.sid,required this.username});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late List<String> messages;
  List<String> sentmessages = [];
  List<String> senderid = [];
  late String userId = "";
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // ignore: unused_field
  Timer? _fetchmess;


  @override
  void initState() {
    super.initState();
    _periomess();
    savepass().then((value) {
      setState(() {
        messages = value ?? [];
        userId = messages.isNotEmpty ? messages[4] : '';
        _fetchMessages();
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

  
//auto refresh message each 3 second start
Future <void> _periomess() async {
  _fetchmess = Timer.periodic(const Duration(minutes: 60), (timer) async {
   
    _fetchMessages();
      
  }
      );
}
//auto refresh message each 3 second end


//send message method start
Future<void> sendMessage(int senderId, int receiverId, String message) async {

  _messageController.clear();
  String url = 'https://navajowhite-worm-558163.hostingersite.com/sendmessage.php';

  //we map the data
  Map<String, dynamic> data = {
    'senderid': senderId,
    'receiverid': receiverId,
    'message': message,
  };

  // convert data to json
  String jsonData = jsonEncode(data);


    // send request
    http.Response response = await http.post(
      Uri.parse(url),
      body: jsonData,
    );

    // Check the response status code
    if (response.statusCode == 200) {

      //  if(mounted){
      //
      //    ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Message Sent.'),),
      // );
      //
      // }
      _fetchMessages();
  }
}
//send message end


  //get all messages method start
  Future<void> _fetchMessages() async {
   
      http.Response response = await http.post(
        Uri.parse('https://navajowhite-worm-558163.hostingersite.com/fetchmessage.php'),
       
        body: jsonEncode({
          'uidA': int.parse(userId),
          'uidB': widget.sid,
        }),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          sentmessages.clear(); // Clear existing messages
          sentmessages.addAll(data.map((message) => message['message'].toString()));
          senderid.clear(); // Clear existing messages
          senderid.addAll(data.map((message) => message['senderid'].toString()));
        });
      } 
      else {

       
  
      }
  }

  Alignment messagealign(int x){
    if(senderid[x] == userId){
      return Alignment.topRight;
    }else{
      return Alignment.topLeft;
    }
  }
  dynamic messagecolor(int x){
    if(senderid[x] == userId){
      return const Color(0xFF49AFD2);
    }else{
      return Colors.white;
    }
  }
  dynamic messagetextcolor(int x){
    if(senderid[x] == userId){
      return Colors.white;
    }else{
      return Colors.black;
    }
  }
//get all messages end



//////////////
////////////
///widget start
  @override
  Widget build(BuildContext context) {
  //we call it to scroll down when we send a msg
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _scrollController.animateTo(
    _scrollController.position.maxScrollExtent,
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeOut,
  );
});
    return Scaffold(
      backgroundColor: const Color(0xFFFCF4D8),
      appBar: AppBar(
        title: widget.username != null ? Text(widget.username) : const SizedBox(),
        backgroundColor: const Color(0xFFFCEDC2),
      ),
      body: RefreshIndicator(
        onRefresh: () async{
          _fetchMessages();
        },
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                 controller: _scrollController,
                itemCount: sentmessages.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      _buildMessageBubble(sentmessages[index], index),
        
                    ],
                  );
                },
              ),
            ),
            
            _buildMessageInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(String message, int x) {
    return Align(
      alignment: messagealign(x),
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: messagecolor(x),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Text(
          message,
          style: TextStyle(color: messagetextcolor(x)),
        ),
      ),
    );
  }

  Widget _buildMessageInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Type a message',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Color(0xFF49AFD2)),
            onPressed: () {
              String message = _messageController.text.trim();
              if (message.isNotEmpty) {
                sendMessage(int.parse(userId), widget.sid, message);
              }
            },
          ),
        ],
      ),
    );
  }
}


